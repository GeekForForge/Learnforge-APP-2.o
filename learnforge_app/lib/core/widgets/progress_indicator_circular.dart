import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class CircularProgressIndicatorCustom extends StatelessWidget {
  final double progress;
  final double size;
  final String label;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final Color? progressColor;
  final Color? glowColor;
  final Color? textColor;

  const CircularProgressIndicatorCustom({
    Key? key,
    required this.progress,
    this.size = 120,
    this.label = '',
    this.labelStyle,
    this.backgroundColor,
    this.progressColor,
    this.glowColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: glowColor != null
          ? BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: glowColor!.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            )
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: (backgroundColor ?? AppColors.dark700).withOpacity(0.3),
                width: 2,
              ),
            ),
          ),

          // Progress indicator
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 6,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? AppColors.neonCyan,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOut),

          // Percentage and label
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: size * 0.18, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: textColor ?? AppColors.white,
                ),
              ),
              if (label.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  label,
                  style:
                      labelStyle ??
                      TextStyle(
                        fontSize: size * 0.1, // Responsive font size
                        color: textColor?.withOpacity(0.7) ?? AppColors.grey400,
                      ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
