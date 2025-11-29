import 'package:flutter/material.dart';
import 'package:frontend/common_widgets/bottom_nav.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  int selectedCategory = 0;
  final TextEditingController messageController = TextEditingController();

  final List<Map<String, String>> _messages = [
    {"type": "bot", "text": "안녕하세요. 어떤 이야기를 나눌까요?"},
  ];

  final List<String> _categories = ["스트레스 해소법", "수면 개선", "감정 일기"];

  final Map<String, String> _categoryResponses = {
    "스트레스 해소법": [
      "최근 스트레스 지수가 0.63으로 조금 높네요.",
      "최근 감정 일기에서도 ‘불안’이 자주 보였어요.",
      "짧은 호흡법(4초 들숨 / 6초 날숨)을 3회 반복해보세요.",
      "몸의 긴장도를 빠르게 낮춰주는 데 도움이 돼요.",
      "원하면 간단한 이완 명상도 추천해드릴게요.",
    ].join("\n\n"),
    "수면 개선": [
      "지난 며칠 평균 수면이 5시간대로 짧아져 있어요.",
      "깊은 수면 비율도 조금 낮네요.",
      "잠들기 전에 5분 정도 가벼운 스트레칭이나",
      "짧은 호흡 안정 루틴을 해보면 수면 진입이 빨라집니다.",
      "필요하시면 수면 유도 음원도 추천드릴게요.",
    ].join("\n\n"),
    "감정 일기": [
      "최근 일기에서 ‘피곤함’, ‘불안’이 자주 보였어요.",
      "오늘도 비슷한 감정이 드셨나요?",
      "오늘 느낀 감정 한 줄, 그리고 그 감정을 만든 이유 한 줄만 적어보면 좋습니다.",
      "작성하면 패턴 분석에 도움이 돼요.",
    ].join("\n\n"),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAppBar(),
                      _buildTitle(),
                      const SizedBox(height: 10),
                      _buildCategoryTabs(),
                      const SizedBox(height: 20),
                      _buildChatList(),
                    ],
                  ),
                ),
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  // ---------------------------------
  // 🔵 App Bar
  // ---------------------------------
  Widget _buildAppBar() {
    return const Row(children: [Spacer(), Icon(Icons.more_horiz)]);
  }

  // ---------------------------------
  // 🔵 상단 “챗봇” 타이틀
  // ---------------------------------
  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "챗봇",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ---------------------------------
  // 🔵 카테고리 탭
  // ---------------------------------
  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_categories.length, (i) {
          final isSelected = selectedCategory == i;
          return GestureDetector(
            onTap: () => _handleCategoryTap(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blueGrey.shade300
                    : Colors.blueGrey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(_categories[i], style: const TextStyle(fontSize: 14)),
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------
  // 🔵 대화 리스트
  // ---------------------------------
  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return msg["type"] == "user"
            ? _userChatBubble(msg["text"]!)
            : _botChatBubble(msg["text"]!);
      },
    );
  }

  // 🔹 사용자 말풍선
  Widget _userChatBubble(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(fontSize: 15)),
      ),
    );
  }

  // 🔹 챗봇 말풍선
  Widget _botChatBubble(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
          ],
        ),
        child: Text(text, style: const TextStyle(fontSize: 15)),
      ),
    );
  }

  // ---------------------------------
  // 🔵 메시지 입력창
  // ---------------------------------
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "메시지를 입력하세요",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blueGrey,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCategoryTap(int index) {
    setState(() {
      selectedCategory = index;
      final category = _categories[index];
      _messages.add({"type": "user", "text": category});
      _messages.add({
        "type": "bot",
        "text": _categoryResponses[category] ?? "그 주제에 대해 더 이야기해볼까요?",
      });
    });
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"type": "user", "text": text});
      _messages.add({
        "type": "bot",
        "text": "말씀해주신 내용을 잘 들었습니다. 조금 더 자세히 듣고 도와드릴게요.",
      });
      messageController.clear();
    });
  }
}
