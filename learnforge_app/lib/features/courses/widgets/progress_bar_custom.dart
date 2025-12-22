import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';

class ProgressBarCustom extends StatelessWidget {
  final double progress;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showPercentage;
  final bool animated;

  const ProgressBarCustom({
    Key? key,
    required this.progress,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
    this.showPercentage = false,
    this.animated = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            // Background
            Container(
              height: height,
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.dark700,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            // Progress with glowing gradient
            Container(
                  height: height,
                  width:
                      MediaQuery.of(context).size.width *
                      progress.clamp(0.0, 1.0),
                  decoration: BoxDecoration(
                    gradient: progressColor != null
                        ? LinearGradient(
                            colors: [progressColor!, progressColor!],
                          )
                        : const LinearGradient(
                            colors: [AppColors.neonCyan, AppColors.neonBlue],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                    borderRadius: BorderRadius.circular(height / 2),
                    boxShadow: [
                      BoxShadow(
                        color: (progressColor ?? AppColors.neonCyan)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                )
                .animate(target: animated ? 1 : 0)
                .scaleX(
                  duration: 1000.ms,
                  curve: Curves.easeOut,
                  begin: 0,
                  end: 1,
                ),
          ],
        ),
        if (showPercentage) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  color: AppColors.neonCyan,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class CircularProgressCustom extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showPercentage;

  const CircularProgressCustom({
    Key? key,
    required this.progress,
    this.size = 60,
    this.strokeWidth = 6,
    this.backgroundColor,
    this.progressColor,
    this.showPercentage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circle
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? AppColors.dark700,
          ),
        ),
        // Progress circle
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: strokeWidth,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? AppColors.neonCyan,
            ),
          ),
        ),
        // Percentage text
        if (showPercentage)
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.2,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
      ],
    ).animate().scale(duration: 500.ms, curve: Curves.elasticOut);
  }
}
