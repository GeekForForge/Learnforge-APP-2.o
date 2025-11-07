import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learnforge_app/features/courses/models/course_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../../../core/widgets/progress_indicator_circular.dart';
import '../../../core/widgets/gradient_button.dart';
import '../providers/course_provider.dart';

// Chapter model for type safety
class Chapter {
  final String id;
  final String title;
  final String? summary;
  final bool completed;
  final String? duration;
  final String? videoUrl;

  Chapter({
    required this.id,
    required this.title,
    this.summary,
    required this.completed,
    this.duration,
    this.videoUrl,
  });

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Untitled',
      summary: map['summary']?.toString(),
      completed: map['completed'] as bool? ?? false,
      duration: map['duration']?.toString(),
      videoUrl: map['videoUrl']?.toString(),
    );
  }
}

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(selectedCourseProvider);

    // Handle null case first
    if (courseAsync == null) {
      return _buildNoCourseSelected();
    }

    return Scaffold(
      backgroundColor: AppColors.dark900,
      appBar: AppBar(
        title: Text(
          'Course Details',
          style: TextStyles.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.dark800,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: courseAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: AppColors.neonPurple, size: 64),
              const SizedBox(height: 16),
              Text(
                'Failed to load course',
                style: TextStyles.inter(fontSize: 18, color: AppColors.white),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  error.toString(),
                  style: TextStyles.inter(
                    fontSize: 14,
                    color: AppColors.grey400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 16),
              GradientButton(
                text: 'Retry',
                onPressed: () => ref.invalidate(selectedCourseProvider),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ],
          ),
        ),
        data: (course) {
          if (course == null) {
            return _buildNoCourseSelected();
          }

          final List<Chapter> chapters = _convertChapters(course.chapters);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCourseHeader(context, course),
                const SizedBox(height: 24),
                _buildProgressSection(course),
                const SizedBox(height: 24),
                _buildContinueLearningButton(context, course, chapters),
                const SizedBox(height: 24),
                _buildChaptersSection(chapters),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoCourseSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, color: AppColors.neonCyan, size: 64),
          const SizedBox(height: 16),
          Text(
            'No course selected',
            style: TextStyles.inter(fontSize: 18, color: AppColors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Please select a course to view details',
            style: TextStyles.inter(fontSize: 14, color: AppColors.grey400),
          ),
        ],
      ),
    );
  }

  List<Chapter> _convertChapters(List<dynamic> rawChapters) {
    return rawChapters.map((chapter) {
      if (chapter is Map<String, dynamic>) {
        return Chapter.fromMap(chapter);
      } else if (chapter is Chapter) {
        return chapter;
      } else {
        return Chapter(
          id: chapter.hashCode.toString(),
          title: chapter.toString(),
          completed: false,
        );
      }
    }).toList();
  }

  Widget _buildCourseHeader(BuildContext context, dynamic course) {
    return GlassMorphicCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  // Use Image.network for better error handling
                  Image.network(
                    course.thumbnail,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.dark700,
                        child: Icon(
                          Icons.broken_image,
                          color: AppColors.grey400,
                          size: 48,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.dark900.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: TextStyles.orbitron(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'By ${course.instructor}',
                  style: TextStyles.inter(
                    fontSize: 14,
                    color: AppColors.grey400,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neonPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.neonPurple.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        course.difficulty,
                        style: TextStyles.inter(
                          fontSize: 12,
                          color: AppColors.neonPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      course.rating.toString(),
                      style: TextStyles.inter(
                        fontSize: 12,
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(duration: 400.ms);
  }

  Widget _buildProgressSection(dynamic course) {
    return GlassMorphicCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress',
                style: TextStyles.inter(fontSize: 14, color: AppColors.grey400),
              ),
              const SizedBox(height: 8),
              Text(
                '${course.completedChapters}/${course.totalChapters} Chapters',
                style: TextStyles.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          CircularProgressIndicatorCustom(
            progress: course.progress,
            size: 90,
            progressColor: AppColors.neonCyan,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildContinueLearningButton(
    BuildContext context,
    dynamic course,
    List<Chapter> chapters,
  ) {
    return GradientButton(
      text: 'Continue Learning',
      onPressed: () {
        _navigateToNextChapter(context, course, chapters);
      },
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildChaptersSection(List<Chapter> chapters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chapters',
          style: TextStyles.titleLarge.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 12),
        ChapterList(chapters: chapters).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  void _navigateToNextChapter(
    BuildContext context,
    dynamic course,
    List<Chapter> chapters,
  ) {
    if (chapters.isEmpty) return;

    final nextChapter = chapters.firstWhere(
      (chapter) => !chapter.completed,
      orElse: () => chapters.first,
    );

    // TODO: Implement navigation logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to: ${nextChapter.title}'),
        backgroundColor: AppColors.neonPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

extension on CourseModel {
  when({
    required Center Function() loading,
    required Center Function(dynamic error, dynamic stack) error,
    required Widget Function(dynamic course) data,
  }) {}
}

class ChapterList extends StatelessWidget {
  final List<Chapter> chapters;

  const ChapterList({Key? key, required this.chapters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No chapters available',
          style: TextStyles.inter(color: AppColors.grey400),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GlassMorphicCard(
            onTap: () {
              _onChapterTap(context, chapter);
            },
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: chapter.completed
                        ? AppColors.neonCyan.withOpacity(0.2)
                        : AppColors.dark700,
                    border: Border.all(
                      color: chapter.completed
                          ? AppColors.neonCyan
                          : AppColors.grey400.withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: chapter.completed
                        ? Icon(Icons.check, size: 20, color: AppColors.neonCyan)
                        : Text(
                            '${index + 1}',
                            style: TextStyles.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.title,
                        style: TextStyles.inter(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (chapter.summary != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          chapter.summary!,
                          style: TextStyles.inter(
                            fontSize: 12,
                            color: AppColors.grey400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (chapter.duration != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    chapter.duration!,
                    style: TextStyles.inter(
                      fontSize: 12,
                      color: AppColors.grey400,
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: AppColors.grey400),
              ],
            ),
          ).animate().fadeIn(delay: (100 + index * 50).ms),
        );
      },
    );
  }

  void _onChapterTap(BuildContext context, Chapter chapter) {
    // TODO: Implement chapter navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening: ${chapter.title}'),
        backgroundColor: AppColors.neonCyan,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
