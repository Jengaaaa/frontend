import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool disabled;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color textColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.disabled = false,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.textColor = Colors.white,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: widget.disabled ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.disabled
                ? (widget.disabledBackgroundColor ?? const Color(0xFFC5DAE1))
                : _isHovered
                ? _darkenColor(
                    widget.backgroundColor ?? const Color(0xFFB0CBD4),
                  )
                : (widget.backgroundColor ?? const Color(0xFFB0CBD4)),
            foregroundColor: widget.textColor,
            textStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(widget.text),
        ),
      ),
    );
  }

  Color _darkenColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0)).toColor();
  }
}
