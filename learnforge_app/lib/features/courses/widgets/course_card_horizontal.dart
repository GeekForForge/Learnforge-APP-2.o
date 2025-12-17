import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../models/course_model.dart';

class CourseCardHorizontal extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;
  final bool showProgress;

  const CourseCardHorizontal({
    Key? key,
    required this.course,
    this.onTap,
    this.showProgress = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = course.totalLessons > 0
        ? (course.lessons.where((l) => l.isCompleted).length /
            course.totalLessons)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.dark800,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.neonPurple.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonPink.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: AppColors.neonBlue.withOpacity(0.3),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Section (60%)
            Stack(
              children: [
                // Thumbnail
                Container(
                  height: 132,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(course.thumbnail),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Gradient Overlay
                Container(
                  height: 132,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),

                // Level Badge (Top Right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _getLevelColor(course.level).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: _getLevelColor(course.level).withOpacity(0.7),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      course.level,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),

                // Rating Badge (Top Left)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.neonYellow ?? Colors.amber,
                          size: 10,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          course.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Progress Indicator (Bottom)
                if (showProgress && progress > 0)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 3,
                            backgroundColor: AppColors.dark600,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.neonCyan,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            // Info Section (40%)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Course Title
                    Text(
                      course.title,
                      style: TextStyles.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Bottom Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Instructor
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: AppColors.grey400,
                              size: 10,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                course.instructor,
                                style: TextStyles.inter(
                                  fontSize: 10,
                                  color: AppColors.grey400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Lessons or Progress
                        if (showProgress && progress > 0)
                          Text(
                            '${(progress * 100).toInt()}% Complete',
                            style: TextStyles.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.neonCyan,
                            ),
                          )
                        else
                          Row(
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                color: AppColors.grey400,
                                size: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${course.totalLessons} lessons',
                                style: TextStyles.inter(
                                  fontSize: 10,
                                  color: AppColors.grey400,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return AppColors.neonGreen ?? Colors.green;
      case 'intermediate':
        return AppColors.neonYellow ?? Colors.amber;
      case 'advanced':
        return AppColors.neonPink;
      default:
        return AppColors.neonCyan;
    }
  }
}
