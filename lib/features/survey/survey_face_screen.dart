import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/primary_button.dart';

class SurveyFaceScreen extends StatelessWidget {
  const SurveyFaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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

            const SizedBox(height: 60),

            Center(
              child: Image.asset(
                "assets/images/face_icon.png",
                width: 240,
              ),
            ),

            const Spacer(),

            PrimaryButton(
              text: "다음",
              onPressed: () {
                // TODO: 다음 페이지 이동 (AI 카메라·마이크 화면)
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
