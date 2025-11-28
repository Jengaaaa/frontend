import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool disabled;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color textColor;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.disabled = false,
    this.backgroundColor = Colors.black,
    this.disabledBackgroundColor = const Color(0xFFE0E0E0),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled ? disabledBackgroundColor : backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
