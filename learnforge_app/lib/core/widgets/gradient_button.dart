import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final double width;
  final double height;
  final bool disabled;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.disabled = false,
    this.borderRadius = 25.0,
    this.textStyle,
    this.isLoading = false,
    required EdgeInsets padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: disabled
            ? const LinearGradient(colors: [Colors.grey, Colors.grey])
            : gradient ?? _defaultGradient(context),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: disabled
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style:
              textStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  Gradient _defaultGradient(BuildContext context) {
    return LinearGradient(
      colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).colorScheme.secondary,
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }
}
