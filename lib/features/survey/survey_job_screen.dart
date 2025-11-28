import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/primary_button.dart';

class SurveyJobScreen extends StatefulWidget {
  const SurveyJobScreen({super.key});

  @override
  State<SurveyJobScreen> createState() => _SurveyJobScreenState();
}

class _SurveyJobScreenState extends State<SurveyJobScreen> {
  String? selectedJob; // 'police' 또는 'firefighter'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              "강민님의\n직업을 선택해주세요",
              style: TextStyle(
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
                Navigator.pushNamed(
                  context,
                  "/survey-info",
                  arguments: selectedJob, // 'police' 또는 'firefighter'
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(image, width: 140),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
