import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/bottom_nav.dart';
import 'package:frontend/common_widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final String job; // "police" or "fire"
  final double stressScore;

  const HomeScreen({super.key, this.job = "police", this.stressScore = 0.27});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _journalController = TextEditingController();
  final List<String> _dailyEntries = [];

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPolice = widget.job == "police";

    final Color bgColor = isPolice ? Color(0xFF8ACAE6) : Color(0xFFE7621F);
    final String characterImg = isPolice
        ? "assets/images/police.png"
        : "assets/images/firefighter.png";

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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

            // 분석하기 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryButton(
                text: "분석하기",
                onPressed: () {
                  // 현재 직군 정보를 설문 플로우로 전달
                  Navigator.pushNamed(
                    context,
                    "/survey-info",
                    arguments: widget.job,
                  );
                },
              ),
            ),

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
    return const Row(children: [Spacer(), Icon(Icons.more_horiz)]);
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
            const Text(
              "스트레스 지수",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            const Text(
              "0.27",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text("Low", style: TextStyle(fontSize: 16)),
          ],
        ),
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

  Widget _buildStatCard(
    String title,
    String value,
    String status,
    IconData icon,
  ) {
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
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
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
          const Text(
            "요즘 인기 있는 명상",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: _meditationVideos.length,
              itemBuilder: (context, index) {
                return _buildMeditationVideoCard(
                  context,
                  _meditationVideos[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionSection() {
    final bool hasEntries = _dailyEntries.isNotEmpty;
    final String latestEntry = hasEntries
        ? _dailyEntries.first
        : "최근 찍은 감정이 없어요";

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
          const Text(
            "감정 한 컷",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(latestEntry, style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "강민님, 지금 기분은 어때요?",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMoodButton(
                      "별로예요",
                      Icons.sentiment_very_dissatisfied,
                      Colors.red,
                    ),
                    _buildMoodButton(
                      "그냥 그래요",
                      Icons.sentiment_neutral,
                      Colors.amber,
                    ),
                    _buildMoodButton(
                      "좋아요!",
                      Icons.sentiment_satisfied_alt,
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _journalController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "오늘의 감정을 적어보세요",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _addDailyEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("기록하기"),
            ),
          ),
          if (hasEntries) ...[
            const SizedBox(height: 16),
            const Text("최근 기록", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _dailyEntries
                  .map(
                    (entry) => Chip(
                      backgroundColor: Colors.blueGrey.shade50,
                      label: Text(entry, style: const TextStyle(fontSize: 12)),
                    ),
                  )
                  .take(4)
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMoodButton(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _journalController.text = label,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _addDailyEntry() {
    final text = _journalController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _dailyEntries.insert(0, text);
      if (_dailyEntries.length > 5) {
        _dailyEntries.removeLast();
      }
      _journalController.clear();
    });
  }
}

Widget _buildMeditationVideoCard(BuildContext context, _MeditationVideo video) {
  return GestureDetector(
    onTap: () => _launchVideo(video.url),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Image.network(
            video.thumbnail,
            width: 220,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 220,
              height: 180,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image, size: 40),
            ),
          ),
          Container(
            width: 220,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.05),
                  Colors.black.withOpacity(0.55),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Row(
              children: const [
                Icon(Icons.play_circle_fill, color: Colors.white, size: 26),
                SizedBox(width: 6),
                Text(
                  "재생",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Text(
              video.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _launchVideo(String url) async {
  final uri = Uri.parse(url);
  if (!await canLaunchUrl(uri)) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

final List<_MeditationVideo> _meditationVideos = [
  _MeditationVideo(
    title: "편안한 밤 호흡 명상",
    url: "https://www.youtube.com/watch?v=inxAScz0PTM",
    thumbnail: "https://img.youtube.com/vi/inxAScz0PTM/maxresdefault.jpg",
  ),
  _MeditationVideo(
    title: "초점 집중 스트레스 해소",
    url: "https://www.youtube.com/watch?v=dZewQEbQQM0",
    thumbnail: "https://img.youtube.com/vi/dZewQEbQQM0/maxresdefault.jpg",
  ),
  _MeditationVideo(
    title: "숨 고르기 딥 리스펙트",
    url: "https://www.youtube.com/watch?v=B9GsLAPeA2M",
    thumbnail: "https://img.youtube.com/vi/B9GsLAPeA2M/maxresdefault.jpg",
  ),
];

class _MeditationVideo {
  final String title;
  final String url;
  final String thumbnail;

  _MeditationVideo({
    required this.title,
    required this.url,
    required this.thumbnail,
  });
}
