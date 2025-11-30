import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/primary_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;



class SurveyFaceScreen extends StatefulWidget {
  const SurveyFaceScreen({super.key});

  @override
  State<SurveyFaceScreen> createState() => _SurveyFaceScreenState();
}

class _SurveyFaceScreenState extends State<SurveyFaceScreen> {
  bool _cameraGranted = false;
  bool _microphoneGranted = false;
  bool _requesting = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final camStatus = await Permission.camera.status;
    final micStatus = await Permission.microphone.status;
    setState(() {
      _cameraGranted = camStatus.isGranted;
      _microphoneGranted = micStatus.isGranted;
    });
  }

  Future<void> _requestPermissions() async {
    setState(() => _requesting = true);
    final statuses = await [Permission.camera, Permission.microphone].request();
    setState(() {
      _cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
      _microphoneGranted = statuses[Permission.microphone]?.isGranted ?? false;
      _requesting = false;
    });
  }

void _goToCameraPage() async {
  if (!_cameraGranted || !_microphoneGranted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("카메라와 마이크 권한을 먼저 허용해주세요.")));
    return;
  }

  // 🔥 FastAPI에 세션 초기화 요청
  try {
    final uri = Uri.parse("http://10.0.2.2:8000/realtime/init?user_id=demo-user");
    await http.post(uri);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("서버 초기화 실패: 서버가 켜져 있나요?")),
    );
    return;
  }

  // 🔥 녹화 화면으로 이동
  Navigator.pushNamed(context, '/survey-camera');
}


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allGranted = _cameraGranted && _microphoneGranted;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "음성/얼굴 인식",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "다음 단계에서는 카메라와 마이크를 통해 감정 반응을 기록합니다.\n편안한 환경에서 진행해주세요.",
                      style: TextStyle(fontSize: 20, height: 1.4),
                    ),
                    const SizedBox(height: 40),
                    _buildPermissionStatus(
                      label: "카메라",
                      granted: _cameraGranted,
                      details: "얼굴을 화면 중앙에 맞춰주세요.",
                    ),
                    const SizedBox(height: 12),
                    _buildPermissionStatus(
                      label: "마이크",
                      granted: _microphoneGranted,
                      details: "환경음을 최소화한 뒤 말을 시작해주세요.",
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "준비가 되면 아래의 \"녹화 시작\" 버튼을 눌러\n다음 화면에서 5초간 얼굴과 음성을 녹화합니다.",
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      allGranted
                          ? "카메라와 마이크 준비가 완료되었습니다."
                          : "권한이 모두 승인되어야 녹화가 가능합니다.",
                      style: TextStyle(
                        color: allGranted
                            ? Colors.green
                            : Colors.orange.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!allGranted)
              PrimaryButton(
                text: "권한 요청",
                onPressed: _requestPermissions,
                disabled: _requesting,
              )
            else
              PrimaryButton(text: "녹화 시작", onPressed: _goToCameraPage),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionStatus({
    required String label,
    required bool granted,
    required String details,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: granted ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: granted ? Colors.green : Colors.grey.shade400,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                granted ? Icons.check_circle : Icons.info,
                color: granted ? Colors.green : Colors.orange,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(details, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
