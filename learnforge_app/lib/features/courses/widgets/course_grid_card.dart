import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';
import 'progress_bar_custom.dart';

class CourseGridCard extends StatelessWidget {
  final String courseId;
  final String title;
  final String instructor;
  final String thumbnail;
  final double rating;
  final int totalRatings;
  final int enrolledCount;
  final String level;
  final bool isFree;
  final double price;
  final int totalLessons;
  final int completedLessons;
  final bool isEnrolled;
  final VoidCallback? onTap;
  final VoidCallback? onEnroll;

  const CourseGridCard({
    Key? key,
    required this.courseId,
    required this.title,
    required this.instructor,
    required this.thumbnail,
    required this.rating,
    required this.totalRatings,
    required this.enrolledCount,
    required this.level,
    required this.isFree,
    required this.price,
    required this.totalLessons,
    required this.completedLessons,
    this.isEnrolled = false,
    this.onTap,
    this.onEnroll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    return Container(
      margin: const EdgeInsets.all(8),
      child: Stack(
        children: [
          // Main Card with neon glowing border
          Container(
            decoration: BoxDecoration(
              color: AppColors.dark800,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonPink.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppColors.neonBlue.withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: 12,
                ),
              ],
              border: Border.all(
                color: AppColors.neonPurple.withOpacity(0.7),
                width: 2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Thumbnail with overlay gradient and badges
                    Stack(
                      children: [
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(thumbnail),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),

                        // Level Badge
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getLevelColor(level).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: _getLevelColor(level).withOpacity(0.7),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Text(
                              level,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                shadows: [
                                  Shadow(color: Colors.black45, blurRadius: 4),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Free/Paid Badge
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isFree
                                  ? AppColors.neonGreen?.withOpacity(0.9) ??
                                        Colors.green
                                  : AppColors.neonPurple.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: isFree
                                      ? AppColors.neonGreen?.withOpacity(0.7) ??
                                            Colors.green.withOpacity(0.7)
                                      : AppColors.neonPurple.withOpacity(0.7),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Text(
                              isFree ? 'FREE' : '₹${price.toInt()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),

                        // Progress bar for enrolled courses
                        if (isEnrolled && progress > 0)
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: ProgressBarCustom(
                              progress: progress,
                              height: 4,
                              showPercentage: false,
                              // gradient removed because it's not a valid parameter
                            ),
                          ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Course Title
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              shadows: [
                                Shadow(
                                  color: AppColors.neonPink,
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 8),

                          // Instructor Info
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.white.withOpacity(0.6),
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  instructor,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Rating and Enrolled Info
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.neonYellow ?? Colors.amber,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${_formatCount(totalRatings)})',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.people,
                                color: Colors.white.withOpacity(0.6),
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatCount(enrolledCount),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Lessons Info & Action Button
                          Row(
                            children: [
                              if (isEnrolled) ...[
                                Icon(
                                  Icons.play_circle_fill,
                                  color: AppColors.neonCyan,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$completedLessons/$totalLessons',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const Spacer(),
                              ] else ...[
                                Icon(
                                  Icons.video_library,
                                  color: Colors.white.withOpacity(0.6),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$totalLessons lessons',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const Spacer(),
                              ],

                              if (!isEnrolled)
                                Container(
                                  height: 28,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.neonPurple,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.neonPink.withOpacity(
                                          0.6,
                                        ),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: onEnroll,
                                      borderRadius: BorderRadius.circular(14),
                                      child: const Center(
                                        child: Text(
                                          'Enroll',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  height: 28,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.neonGreen?.withOpacity(0.2) ??
                                        Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color:
                                          AppColors.neonGreen ?? Colors.green,
                                      width: 1,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Continue',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOut),
        ],
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

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
