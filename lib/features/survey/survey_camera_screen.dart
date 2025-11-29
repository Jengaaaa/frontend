import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/primary_button.dart';

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
  int _secondsRemaining = 5;
  Timer? _timer;

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
      _secondsRemaining = 5;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _recording = false;
          _secondsRemaining = 0;
        });
        return;
      }
      setState(() => _secondsRemaining--);
    });
  }

  void _proceedNext() {
    // TODO: 서버 업로드 흐름 등 다음 단계
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
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
              "화면에 얼굴이 잘 보이도록 위치를 잡은 뒤\n아래 버튼을 눌러 5초간 얼굴과 음성을 녹화합니다.",
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
                        : "준비되면 녹화 버튼을 눌러 5초간 얼굴과 목소리를 캡처하세요."),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              minHeight: 6,
              value: _recording
                  ? (5 - _secondsRemaining) / 5
                  : (_secondsRemaining == 0 ? 1.0 : 0.0),
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
