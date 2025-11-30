import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/primary_button.dart';
import 'package:frontend/features/auth/login_screen.dart';

class SurveyJobScreen extends StatefulWidget {
  final String? userName; // 사용자 이름

  const SurveyJobScreen({super.key, this.userName});

  @override
  State<SurveyJobScreen> createState() => _SurveyJobScreenState();
}

class _SurveyJobScreenState extends State<SurveyJobScreen> {
  String? selectedJob; // 'police' 또는 'firefighter'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Text(
              "${widget.userName ?? '강민'}님의\n직업을 선택해주세요",
              style: const TextStyle(
                fontSize: 34,
                height: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _jobItem(
                  label: "경찰관",
                  image: "assets/images/police.png",
                  selected: selectedJob == "police",
                  color: Colors.blue,
                  onTap: () {
                    setState(() => selectedJob = "police");
                  },
                ),
                _jobItem(
                  label: "소방관",
                  image: "assets/images/firefighter.png",
                  selected: selectedJob == "firefighter",
                  color: Colors.orange,
                  onTap: () {
                    setState(() => selectedJob = "firefighter");
                  },
                ),
              ],
            ),

            const Spacer(),

            PrimaryButton(
              text: "다음",
              disabled: selectedJob == null,
              onPressed: () {
                if (selectedJob == null) return;
                // 직군 선택 후 로그인 화면으로 이동하면서 선택한 직군을 전달
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(job: selectedJob),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _jobItem({
    required String label,
    required String image,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return _JobItemWidget(
      label: label,
      image: image,
      selected: selected,
      color: color,
      onTap: onTap,
    );
  }
}

class _JobItemWidget extends StatefulWidget {
  final String label;
  final String image;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _JobItemWidget({
    required this.label,
    required this.image,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  State<_JobItemWidget> createState() => _JobItemWidgetState();
}

class _JobItemWidgetState extends State<_JobItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.3 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (_isHovered || widget.selected)
                  ? const Color(0xFFABC7D0)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Image.asset(widget.image, width: 140),
                const SizedBox(height: 10),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
