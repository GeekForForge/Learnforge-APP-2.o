import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../models/course_model.dart';

class CourseGridCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;
  final int index;

  const CourseGridCard({
    Key? key,
    required this.course,
    required this.onTap,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassMorphicCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with proper error handling
          _buildThumbnail(),
          const SizedBox(height: 12),

          // Title
          Text(
            course.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 6),

          // Instructor
          Row(
            children: [
              Icon(Icons.person_outline, size: 12, color: AppColors.grey400),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  course.instructor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.grey400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Difficulty badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _getDifficultyColor(course.difficulty).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getDifficultyColor(course.difficulty).withOpacity(0.3),
              ),
            ),
            child: Text(
              course.difficulty,
              style: TextStyle(
                fontSize: 9,
                color: _getDifficultyColor(course.difficulty),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: course.progress,
                  minHeight: 6,
                  backgroundColor: AppColors.dark600,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(fontSize: 10, color: AppColors.grey400),
                  ),
                  Text(
                    '${(course.progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (100 + index * 100).ms);
  }

  Widget _buildThumbnail() {
    return Stack(
      children: [
        // Use Image.network instead of DecorationImage for proper error handling
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.dark700,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              course.thumbnail,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.dark600,
                  child: Icon(Icons.school, color: AppColors.grey400, size: 40),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.dark600,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.neonCyan,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Gradient overlay
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, AppColors.dark900.withOpacity(0.7)],
            ),
          ),
        ),

        // Progress indicator in corner
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.dark900.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${(course.progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppColors.neonCyan;
      case 'intermediate':
        return AppColors.neonPurple;
      case 'advanced':
        return AppColors.neonPink;
      default:
        return AppColors.neonBlue;
    }
  }
}
