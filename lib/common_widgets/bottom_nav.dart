import 'package:flutter/material.dart';
import 'package:frontend/features/home/home_screen.dart';
import 'package:frontend/features/report/report_screen.dart';
import 'package:frontend/features/chatbot/chatbot_screen.dart';
import 'package:frontend/features/mypage/mypage_screen.dart';

const Color _activeNavColor = Color(0xFFABC7D0);

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  static final List<_BottomNavItemConfig> _navItems = [
    _BottomNavItemConfig(
      index: 0,
      label: "Home",
      icon: Icons.home,
      builder: (_) => const HomeScreen(),
    ),
    _BottomNavItemConfig(
      index: 1,
      label: "Report",
      icon: Icons.analytics,
      builder: (_) => const ReportScreen(),
    ),
    _BottomNavItemConfig(
      index: 2,
      label: "Chat",
      icon: Icons.chat_bubble_outline,
      builder: (_) => const ChatbotScreen(),
    ),
    _BottomNavItemConfig(
      index: 3,
      label: "My",
      icon: Icons.person,
      builder: (_) => const MyPageScreen(),
    ),
  ];

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    final target = _navItems
        .firstWhere((element) => element.index == index)
        .builder;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: target),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: _navItems
                .map(
                  (item) => Expanded(
                    child: _NavItem(
                      config: item,
                      isSelected: currentIndex == item.index,
                      onTap: () => _onTap(context, item.index),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItemConfig {
  final int index;
  final String label;
  final IconData icon;
  final WidgetBuilder builder;

  const _BottomNavItemConfig({
    required this.index,
    required this.label,
    required this.icon,
    required this.builder,
  });
}

class _NavItem extends StatefulWidget {
  final _BottomNavItemConfig config;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.config,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool highlight = widget.isSelected || _isHovered;
    final color = highlight ? _activeNavColor : Colors.black87;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.config.icon, color: color),
              const SizedBox(height: 4),
              Text(
                widget.config.label,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
