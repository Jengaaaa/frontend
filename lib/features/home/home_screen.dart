import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  final String job; // "police" or "fire"
  final double stressScore;

  const HomeScreen({
    super.key,
    this.job = "police",
    this.stressScore = 0.27,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPolice = job == "police";

    final Color bgColor = isPolice ? Color(0xFF8ACAE6) : Color(0xFFE7621F);
    final String characterImg = isPolice
        ? "assets/images/police.png"
        : "assets/images/firefighter.png";

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildAppBar(context),

            const SizedBox(height: 20),

            // Circle Stress Gauge
            _buildStressGauge(characterImg),

            const SizedBox(height: 20),
            const Text(
              "오늘은 안정적인 하루예요!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            // Stats Section (심박수/수면/활동량)
            _buildStatsSection(),

            const SizedBox(height: 20),

            // Meditation Section
            _buildMeditationSection(),

            const SizedBox(height: 20),

            // Emotion Section
            _buildEmotionSection(),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }

  // -------------------------
  //      WIDGETS BELOW
  // -------------------------

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  Widget _buildStressGauge(String img) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: CircularProgressIndicator(
            value: 0.27,
            strokeWidth: 20,
            valueColor: AlwaysStoppedAnimation(Colors.white),
            backgroundColor: Colors.white.withOpacity(0.3),
          ),
        ),
        Column(
          children: [
            Image.asset(img, width: 120),
            const SizedBox(height: 10),
            const Text("스트레스 지수",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            const Text("0.27", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text("Low", style: TextStyle(fontSize: 16)),
          ],
        )
      ],
    );
  }

  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard("심박수(bpm)", "72bpm", "정상", Icons.favorite_border),
        _buildStatCard("수면(h)", "7.2", "양호", Icons.nights_stay),
        _buildStatCard("활동량", "0.3", "어제보다 ↓", Icons.trending_down),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String status, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(status, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMeditationSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("요즘 인기 있는 명상",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMeditationImage("assets/images/med1.jpg"),
              _buildMeditationImage("assets/images/med2.jpg"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMeditationImage(String imgPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(imgPath, width: 140, height: 120, fit: BoxFit.cover),
    );
  }

  Widget _buildEmotionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("감정 한 컷",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text("최근 찍은 감정이 없어요"),
          ),
          const SizedBox(height: 20),

          const Text("강민님, 지금 기분은 어때요?",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEmotionBtn("별로예요", Icons.sentiment_very_dissatisfied),
              _buildEmotionBtn("그냥 그래요", Icons.sentiment_neutral),
              _buildEmotionBtn("좋아요!", Icons.sentiment_satisfied_alt),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionBtn(String label, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, size: 28),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
