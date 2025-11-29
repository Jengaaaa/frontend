import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/bottom_nav.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final TextEditingController diaryController = TextEditingController();

  // 샘플 데이터
  final List<Map<String, String>> diaryList = [
    {"date": "10/25 (금)", "text": "요즘 스트레스가 줄고있어서 마음이 편안하다."},
    {"date": "10/26 (토)", "text": "친구들과 만나 즐거운 하루 였다"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              _buildTitle(),

              const SizedBox(height: 10),
              _buildDiaryInput(),

              const SizedBox(height: 30),
              _buildDiaryList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }

  // -------------------------------
  // 🔵 AppBar
  // -------------------------------
  Widget _buildAppBar() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        const Icon(Icons.more_horiz),
      ],
    );
  }

  // -------------------------------
  // 🔵 "감정 일기" 타이틀
  // -------------------------------
  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "감정 일기",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  // -------------------------------
  // 🔵 감정 일기 입력 영역
  // -------------------------------
  Widget _buildDiaryInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.sentiment_satisfied, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text(
                "오늘의 기분 요약",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: diaryController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "오늘 느낀 감정을 자유롭게 적어보세요",
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: const [
              Icon(Icons.attach_file, size: 20),
              SizedBox(width: 6),
              Text("이미지 첨부", style: TextStyle(fontSize: 14)),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (diaryController.text.isEmpty) return;

                setState(() {
                  diaryList.insert(0, {
                    "date": "오늘",
                    "text": diaryController.text,
                  });
                  diaryController.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "저장하기",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------
  // 🔵 감정 일기 기록 영역
  // -------------------------------
  Widget _buildDiaryList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "나의 감정 일기 기록",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          Column(
            children: List.generate(diaryList.length, (i) {
              final diary = diaryList[i];

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${diary['date']}\n${diary['text']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade200,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "보기",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
