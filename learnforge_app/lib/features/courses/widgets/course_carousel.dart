import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../models/course_model.dart';
import 'course_card_horizontal.dart';

class CourseCarousel extends StatelessWidget {
  final String title;
  final String emoji;
  final List<Course> courses;
  final VoidCallback? onSeeAll;
  final bool showProgress;
  final int animationDelay;

  const CourseCarousel({
    super.key,
    required this.title,
    required this.emoji,
    required this.courses,
    this.onSeeAll,
    this.showProgress = true,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyles.orbitron(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'See All',
                        style: TextStyles.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neonCyan,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.neonCyan,
                        size: 12,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ).animate().fadeIn(
              delay: animationDelay.ms,
              duration: 400.ms,
            ),

        const SizedBox(height: 12),

        // Horizontal Scrolling List
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: courses.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CourseCardHorizontal(
                  course: courses[index],
                  showProgress: showProgress,
                  onTap: () {
                    // Navigate to course detail
                    context.push('/course/${courses[index].id}');
                  },
                ),
              )
                  .animate()
                  .fadeIn(
                    delay: (animationDelay + (index * 100)).ms,
                    duration: 400.ms,
                  )
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.0, 1.0),
                    delay: (animationDelay + (index * 100)).ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  );
            },
          ),
        ).animate().slideX(
              begin: 0.05,
              end: 0,
              delay: animationDelay.ms,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),
      ],
    );
  }
}
