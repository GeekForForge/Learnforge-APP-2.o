import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../models/course_model.dart';

class HeroCourseBanner extends StatelessWidget {
  final Course course;
  final VoidCallback? onContinue;
  final VoidCallback? onBookmark;
  final bool isBookmarked;

  const HeroCourseBanner({
    super.key,
    required this.course,
    this.onContinue,
    this.onBookmark,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate progress
    final progress = course.totalLessons > 0
        ? (course.lessons.where((l) => l.isCompleted).length /
        course.totalLessons)
        : 0.0;
    final completedLessons = course.lessons.where((l) => l.isCompleted).length;

    return Container(
      height: 280,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with error handling
          Image.network(
            course.thumbnail,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback placeholder
              return Container(
                color: AppColors.dark800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 64,
                      color: AppColors.neonPurple.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Featured Course',
                      style: TextStyles.orbitron(
                        fontSize: 16,
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.9),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Title
                  Text(
                    course.title,
                    style: TextStyles.orbitron(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Instructor and Level
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: AppColors.grey400,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.instructor,
                        style: TextStyles.inter(
                          fontSize: 14,
                          color: AppColors.grey400,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getLevelColor(course.level).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getLevelColor(course.level),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          course.level,
                          style: TextStyles.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getLevelColor(course.level),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Progress Info
                  if (progress > 0) ...[
                    Row(
                      children: [
                        Text(
                          '${(progress * 100).toInt()}% Complete',
                          style: TextStyles.inter(
                            fontSize: 13,
                            color: AppColors.neonCyan,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyles.inter(
                            fontSize: 13,
                            color: AppColors.grey400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$completedLessons/${course.totalLessons} lessons',
                          style: TextStyles.inter(
                            fontSize: 13,
                            color: AppColors.grey400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: AppColors.dark600,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.neonCyan,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    Text(
                      '${course.totalLessons} lessons • ${course.duration} hours',
                      style: TextStyles.inter(
                        fontSize: 13,
                        color: AppColors.grey400,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Action Buttons
                  Row(
                    children: [
                      // Continue/Start Button
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.neonPurple,
                                AppColors.neonPink,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonPurple.withOpacity(0.6),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: onContinue,
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    progress > 0
                                        ? Icons.play_arrow_rounded
                                        : Icons.play_circle_outline,
                                    color: AppColors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    progress > 0 ? 'Continue' : 'Start Course',
                                    style: TextStyles.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Bookmark Button
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.dark700.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.neonPink.withOpacity(0.5),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neonPink.withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onBookmark,
                            borderRadius: BorderRadius.circular(12),
                            child: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: AppColors.neonPink,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(begin: 0.1, end: 0, duration: 600.ms, curve: Curves.easeOut);
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return AppColors.neonGreen;
      case 'intermediate':
        return AppColors.neonYellow;
      case 'advanced':
        return AppColors.neonPink;
      default:
        return AppColors.neonCyan;
    }
  }
}
