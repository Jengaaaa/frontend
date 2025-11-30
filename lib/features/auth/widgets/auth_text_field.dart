import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscure;
  final TextEditingController controller;
  final String? errorText;
  final Color borderColor;
  final Color? errorBorderColor;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    this.obscure = false,
    required this.controller,
    this.errorText,
    this.borderColor = const Color(0xFFCCCCCC),
    this.errorBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final Color effectiveBorderColor = hasError
        ? (errorBorderColor ?? Colors.red)
        : borderColor;

    OutlineInputBorder outlined(Color color) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 1.5),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            enabledBorder: outlined(effectiveBorderColor),
            focusedBorder: outlined(effectiveBorderColor),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
