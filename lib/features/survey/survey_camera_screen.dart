import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/primary_button.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mic_stream/mic_stream.dart' as mic;

class SurveyCameraScreen extends StatefulWidget {
  const SurveyCameraScreen({super.key});

  @override
  State<SurveyCameraScreen> createState() => _SurveyCameraScreenState();
}

class _SurveyCameraScreenState extends State<SurveyCameraScreen> {
  CameraController? _controller;
  bool _initializing = true;
  String? _error;
  bool _recording = false;
  int _secondsRemaining = 30;
  Timer? _timer;
  Timer? _frameTimer;
  StreamSubscription<List<int>>? _audioSub;
  Timer? _resultTimer;
  double? _score;
  String? _level;

  static const String _baseUrl = "http://10.0.2.2:8000"; // TODO: 변경
  static const String _userId = "demo-user"; // TODO: 실제 사용자 ID로 교체

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(front, ResolutionPreset.medium);
      await controller.initialize();
      setState(() {
        _controller = controller;
        _initializing = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _initializing = false;
      });
    }
  }

  void _startRecording() {
    if (_recording) return;
    setState(() {
      _recording = true;
      _secondsRemaining = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _recording = false;
          _secondsRemaining = 0;
        });
        _stopStreaming();
        return;
      }
      setState(() => _secondsRemaining--);
    });

    // 8fps ≒ 125ms 간격으로 프레임 전송
    _frameTimer?.cancel();
    _frameTimer = Timer.periodic(
      const Duration(milliseconds: 125),
      (_) => _captureAndSendFrame(),
    );

    _startAudioStream();
    _startResultPolling();
  }

  void _proceedNext() {
    _stopStreaming();
    // TODO: 서버 업로드 흐름 등 다음 단계 or 결과 요약 화면 이동
  }

  @override
  void dispose() {
    _timer?.cancel();
    _frameTimer?.cancel();
    _audioSub?.cancel();
    _resultTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  bool _sendingFrame = false;

  Future<void> _captureAndSendFrame() async {
    if (!_recording ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return;
    }
    if (_sendingFrame) return;
    _sendingFrame = true;
    try {
      final XFile file = await _controller!.takePicture();
      final bytes = await file.readAsBytes();
      await _sendFrame(bytes);
    } catch (e) {
      // 전송 실패는 데모에서는 무시
    } finally {
      _sendingFrame = false;
    }
  }

  Future<void> _sendFrame(List<int> jpegBytes) async {
    final uri = Uri.parse("$_baseUrl/realtime/frame");
    final request = http.MultipartRequest('POST', uri)
      ..fields['user_id'] = _userId
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          jpegBytes,
          filename: 'frame.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    await request.send();
  }

  Future<void> _startAudioStream() async {
    try {
      final stream = await mic.MicStream.microphone(
        audioSource: mic.AudioSource.DEFAULT,
        sampleRate: 16000,
        channelConfig: mic.ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: mic.AudioFormat.ENCODING_PCM_16BIT,
      );

      const chunkMs = 150;
      const sampleRate = 16000;
      const bytesPerSample = 2; // 16bit PCM
      final samplesPerChunk = sampleRate * chunkMs ~/ 1000;
      final bytesPerChunk = samplesPerChunk * bytesPerSample;

      List<int> buffer = [];
      _audioSub?.cancel();
      _audioSub = stream.listen((List<int> data) {
        buffer.addAll(data);
        while (buffer.length >= bytesPerChunk && _recording) {
          final chunk = buffer.sublist(0, bytesPerChunk);
          buffer = buffer.sublist(bytesPerChunk);
          _sendAudioChunk(chunk);
        }
      });
    } catch (e) {
      // 마이크 초기화 실패는 데모에서는 무시
    }
  }

  Future<void> _sendAudioChunk(List<int> pcmBytes) async {
    final uri = Uri.parse("$_baseUrl/realtime/audio");
    final request = http.MultipartRequest('POST', uri)
      ..fields['user_id'] = _userId
      ..files.add(
        http.MultipartFile.fromBytes(
          'audio_chunk',
          pcmBytes,
          filename: 'chunk.pcm',
          contentType: MediaType('application', 'octet-stream'),
        ),
      );
    await request.send();
  }

  void _startResultPolling() {
    _resultTimer?.cancel();
    _resultTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _fetchLatestResult(),
    );
  }

  Future<void> _fetchLatestResult() async {
    try {
      final uri = Uri.parse("$_baseUrl/realtime/result?user_id=$_userId");
      final resp = await http.get(uri);
      if (resp.statusCode != 200) return;

      final data =
          jsonDecode(resp.body.isEmpty ? "{}" : resp.body)
              as Map<String, dynamic>;
      final dynamic scoreVal = data["score"];

      if (scoreVal == null) {
        // 모델이 아직 입력을 못 받음 → 점수 표시 유지/초기화
        setState(() {
          _score = null;
          _level = null;
        });
        return;
      }

      setState(() {
        _score = (scoreVal as num).toDouble();
        _level = data["level"] as String?;
      });
    } catch (_) {
      // 네트워크 오류는 조용히 무시
    }
  }

  void _stopStreaming() {
    _frameTimer?.cancel();
    _audioSub?.cancel();
    _resultTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "녹화 시작",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "화면에 얼굴이 잘 보이도록 위치를 잡은 뒤\n아래 버튼을 눌러 30초간 얼굴과 음성을 녹화합니다.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.black,
                  child: _initializing
                      ? const Center(child: CircularProgressIndicator())
                      : (_controller != null && _controller!.value.isInitialized
                            ? CameraPreview(_controller!)
                            : Center(
                                child: Text(
                                  _error ?? "카메라를 실행할 수 없습니다.",
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _recording
                  ? "녹화 중: $_secondsRemaining초 남았습니다."
                  : (_secondsRemaining == 0
                        ? "녹화가 완료되었습니다."
                        : "준비되면 녹화 버튼을 눌러 30초간 얼굴과 목소리를 캡처하세요."),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              minHeight: 6,
              value: _recording
                  ? (30 - _secondsRemaining) / 30
                  : (_secondsRemaining == 0 ? 1.0 : 0.0),
            ),
            const SizedBox(height: 12),
            if (_score != null)
              Text(
                "실시간 점수: ${_score!.toStringAsFixed(2)} (${_level ?? ""})",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            else if (_recording)
              const Text(
                "실시간 점수를 계산하는 중입니다...",
                style: TextStyle(fontSize: 14),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: _recording
                        ? "녹화 중..."
                        : (_secondsRemaining == 0 ? "다음 단계" : "녹화 시작"),
                    onPressed: _recording
                        ? () {}
                        : (_secondsRemaining == 0
                              ? _proceedNext
                              : _startRecording),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
