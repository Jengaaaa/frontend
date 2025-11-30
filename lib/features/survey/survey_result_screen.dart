import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/primary_button.dart';

class SurveyResultScreen extends StatelessWidget {
  final double? score;
  final String? level;

  const SurveyResultScreen({
    super.key,
    this.score,
    this.level,
  });

  @override
  Widget build(BuildContext context) {
    final String scoreText =
        score != null ? score!.toStringAsFixed(2) : "분석 중";
    final String levelText = level ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          "분석 결과",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            const Icon(
              Icons.insights,
              color: Color(0xFFABC7D0),
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              "당신의 오늘 컨디션을 분석했어요",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5FAFC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "스트레스 지수",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scoreText,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            levelText,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: CircularProgressIndicator(
                          value: score != null
                              ? (score!.clamp(0.0, 1.0))
                              : null,
                          strokeWidth: 10,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFFABC7D0),
                          ),
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "수치가 높을수록 피로와 긴장이 쌓여 있다는 뜻이에요.\n오늘 하루는 조금 더 여유를 가지고 스스로를 돌봐주세요.",
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            const Spacer(),
            PrimaryButton(
              text: "홈으로 돌아가기",
              onPressed: () {
                // 스택을 처음까지 비우고 첫 화면(홈)으로 복귀
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


