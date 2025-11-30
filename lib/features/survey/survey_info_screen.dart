import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/primary_button.dart';

class SurveyInfoScreen extends StatefulWidget {
  const SurveyInfoScreen({super.key});

  @override
  State<SurveyInfoScreen> createState() => _SurveyInfoScreenState();
}

class _SurveyInfoScreenState extends State<SurveyInfoScreen> {
  // 어떤 직업에서 온 설문인지 (police / firefighter)
  late String job;

  // 드롭다운 옵션들
  late List<String> timeItems;
  late List<String> typeItems;
  late List<String> locationItems;

  // 현재 선택된 값
  String time = "";
  String type = "";
  String location = "";

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    job = (args is String) ? args : "firefighter"; // 기본값: 소방관

    timeItems = const ["낮", "밤"];

    if (job == "police") {
      // 경찰 직무 기준
      typeItems = const [
        "강력사건 대응",
        "절도 / 폭력 대응",
        "교통 단속",
        "가정폭력 신고",
        "기타 신고 출동",
      ];
      locationItems = const ["도심", "주택가", "외곽지역"];
    } else {
      // 소방 직무 기준
      typeItems = const [
        "화재 진압",
        "구조 활동 (교통사고 구조 등)",
        "응급 처치",
        "위험물 사고",
        "기타 출동",
      ];
      locationItems = const ["도심", "주택가", "공장/산업단지", "산악/농촌 지역"];
    }

    time = timeItems.first;
    type = typeItems.first;
    location = locationItems.first;

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    // 직업에 따른 색상
    final Color titleColor = job == "police" ? Colors.blue : Colors.orange;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false, // 이전(백) 버튼 제거
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "설문조사",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Text(
              "진행되었던 긴급 출동 관련 정보를\n기입해주세요",
              style: TextStyle(fontSize: 20, height: 1.4),
            ),

            const SizedBox(height: 50),

            _dropdownRow(
              title: "출동시간",
              value: time,
              items: timeItems,
              titleColor: titleColor,
              onChanged: (val) => setState(() => time = val!),
            ),

            _dropdownRow(
              title: "분류",
              value: type,
              items: typeItems,
              titleColor: titleColor,
              onChanged: (val) => setState(() => type = val!),
            ),

            _dropdownRow(
              title: "현장",
              value: location,
              items: locationItems,
              titleColor: titleColor,
              onChanged: (val) => setState(() => location = val!),
            ),

            const Spacer(),

            PrimaryButton(
              text: "다음",
              onPressed: () {
                Navigator.pushNamed(context, "/survey-face");
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _dropdownRow({
    required String title,
    required String value,
    required List<String> items,
    required Color titleColor,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: value,
                  items: items
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: _HoverableDropdownItem(
                            text: item,
                            hoverColor: titleColor.withOpacity(0.1),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverableDropdownItem extends StatefulWidget {
  final String text;
  final Color hoverColor;

  const _HoverableDropdownItem({required this.text, required this.hoverColor});

  @override
  State<_HoverableDropdownItem> createState() => _HoverableDropdownItemState();
}

class _HoverableDropdownItemState extends State<_HoverableDropdownItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered ? widget.hoverColor : Colors.transparent,
        child: Text(
          widget.text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
            color: _isHovered ? Colors.black : Colors.black87,
          ),
        ),
      ),
    );
  }
}
