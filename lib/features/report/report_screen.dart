import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/bottom_nav.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int tabIndex = 0; // 0: 주간 변화, 1: 생체 데이터, 2: 감정 분석

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              const SizedBox(height: 16),
              _buildAlertCard(),
              const SizedBox(height: 16),
              _buildCounselRecord(),
              const SizedBox(height: 16),
              _buildTabs(),
              const SizedBox(height: 20),
              _buildGraphContent(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }

  // -----------------------------
  // 🔵 AppBar
  // -----------------------------
  Widget _buildAppBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(children: [Spacer(), Icon(Icons.more_horiz)]),
    );
  }

  // -----------------------------
  // 🔵 주의 단계 카드
  // -----------------------------
  Widget _buildAlertCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "주의 단계 0.63",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("+0.12 지난주보다 증가했어요"),
            SizedBox(height: 20),
            Text("최근 스트레스 지수가 높아요"),
            Text("수면시간이 평균보다 1시간 짧아요"),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // 🔵 탭 영역 (주간 변화 / 생체 데이터 / 감정 분석)
  // -----------------------------
  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _tabButton("주간 변화", Icons.calendar_month, 0),
        _tabButton("생체 데이터", Icons.trending_up, 1),
        _tabButton("감정 분석", Icons.sentiment_satisfied_alt, 2),
      ],
    );
  }

  Widget _tabButton(String text, IconData icon, int index) {
    final bool isSelected = tabIndex == index;

    return GestureDetector(
      onTap: () => setState(() => tabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueGrey.shade200 : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // 🔵 그래프 / 내용 영역
  // -----------------------------
  Widget _buildGraphContent() {
    if (tabIndex == 1) {
      return _buildPlaceholder("생체 데이터 그래프 영역");
    } else if (tabIndex == 2) {
      return _buildPlaceholder("감정 분석 결과 영역");
    }

    return _buildWeeklyChart();
  }

  Widget _buildWeeklyChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "주간 PTSD 위험 변화",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          // 실제 그래프 대신 이미지로 넣기 (향후 chart 패키지로 교체 가능)
          Center(
            child: Image.asset(
              "assets/images/chart_sample.png",
              width: 320,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 12),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "향후 3일간 스트레스 급상승 가능성 있음(신뢰도 82%)",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  // -----------------------------
  // 🔵 상담 기록
  // -----------------------------
  Widget _buildCounselRecord() {
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
            "상담 기록",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // 캐릭터 프로필 이미지
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage("assets/images/police.png"),
                ),

                const SizedBox(width: 16),

                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "2025.10.14",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "PTSD 위험 상담",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
