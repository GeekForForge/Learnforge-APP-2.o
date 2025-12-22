import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../../../core/widgets/progress_indicator_circular.dart';
import '../../../core/widgets/gradient_button.dart';

class ActiveCourseCard extends StatelessWidget {
  final dynamic course;
  final Color glowColor;

  const ActiveCourseCard({
    super.key,
    required this.course,
    this.glowColor = AppColors.neonPurple,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: GlassMorphicCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Continue Learning',
                        style: TextStyles.inter(
                          fontSize: 12,
                          color: AppColors.grey400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course['title'] ?? 'Course Title',
                        style: TextStyles.orbitron(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${((course['progress'] ?? 0.0) * 100).toInt()}% completed',
                        style: TextStyles.inter(
                          fontSize: 12,
                          color: AppColors.grey400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                CircularProgressIndicatorCustom(
                  progress: course['progress'] ?? 0.0,
                  size: 60,
                ),
              ],
            ),
            const SizedBox(height: 16),
            GradientButton(
              text: 'Resume',
              onPressed: () {
                // Add navigation to course detail
              },
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(duration: 400.ms);
  }
}
