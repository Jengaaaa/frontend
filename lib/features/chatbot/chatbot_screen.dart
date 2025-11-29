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

  // 샘플 대화 (디자인 기반)
  final List<Map<String, dynamic>> messages = [
    {
      "type": "user",
      "text": "요즘 잠이 잘 안 오고 자꾸 출동 생각이 나요."
    },
    {
      "type": "bot",
      "text":
          "지금 약간의 불안감을 느끼고 계신 것 같아요.\n최근 출동과 관련된 기억이 자주 떠오르시나요?\n필요하다면 심리 안정 루틴을 함께 해볼까요?"
    },
    {
      "type": "user",
      "text": "네, 자꾸 그 장면이 생각나서 잠들기 전에도 힘들어요."
    },
    {
      "type": "bot",
      "text":
          "그 기억이 반복되면 몸이 계속 긴장 상태일 수 있어요.\n지금 바로 짧은 호흡 안정 루틴을 함께 해볼까요?"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            _buildTitle(),

            const SizedBox(height: 10),
            _buildCategoryTabs(),

            const SizedBox(height: 20),

            // 채팅 리스트
            Expanded(child: _buildChatList()),

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
    final List<String> categories = ["스트레스 해소법", "수면 개선", "감정 일기"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(categories.length, (i) {
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: selectedCategory == i
                    ? Colors.blueGrey.shade300
                    : Colors.blueGrey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                categories[i],
                style: const TextStyle(fontSize: 14),
              ),
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
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];

        return msg["type"] == "user"
            ? _userChatBubble(msg["text"])
            : _botChatBubble(msg["text"]);
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
        child: Text(
          text,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  // 🔹 챗봇 말풍선
  Widget _botChatBubble(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 챗봇 아이콘
        Container(
          margin: const EdgeInsets.only(top: 6),
          child: Image.asset(
            "assets/images/bot_icon.png",
            width: 38,
            height: 38,
          ),
        ),

        const SizedBox(width: 10),

        // 말풍선
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------
  // 🔵 메시지 입력창
  // ---------------------------------
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: messageController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "메시지를 입력하세요",
          ),
          onSubmitted: (text) {
            if (text.trim().isEmpty) return;
            setState(() {
              messages.add({"type": "user", "text": text});
              messageController.clear();
            });
          },
        ),
      ),
    );
  }
}
