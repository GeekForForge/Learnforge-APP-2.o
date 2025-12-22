import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';
import 'package:learnforge_app/features/courses/models/chapter_model.dart';
import 'package:learnforge_app/features/courses/models/course_model.dart';
import 'package:learnforge_app/features/courses/models/course_model.dart';
import 'package:learnforge_app/features/courses/widgets/course_video_player.dart';
import 'progress_bar_custom.dart';

class ChapterList extends StatefulWidget {
  final List<ChapterModel> chapters;
  final List<Lesson> lessons;

  const ChapterList({
    Key? key,
    required this.chapters,
    required this.lessons, // ADD THIS
  }) : super(key: key);

  @override
  State<ChapterList> createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with progress
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Course Content',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  shadows: [
                    Shadow(
                      color: AppColors.neonPurple.withOpacity(0.9),
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
              Text(
                '${widget.chapters.length} chapters',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),

        // Overall progress
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: ProgressBarCustom(
                  progress: _calculateOverallProgress(),
                  height: 6,
                  showPercentage: true,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Chapters list with neon glowing effect and animation
        ...widget.chapters.asMap().entries.map((entry) {
          final index = entry.key;
          final chapter = entry.value;
          final isCompleted = chapter.isCompleted;
          final isLocked = chapter.isLocked;

          return _ChapterListItem(
                chapter: chapter,
                index: index,
                isCompleted: isCompleted,
                isLocked: isLocked,
                onTap: () {
                  if (isLocked) return;

                  // 1️⃣ Get all lessons inside this chapter
                  final chapterLessons = widget.lessons
                      .where((lesson) => chapter.lessonIds.contains(lesson.id))
                      .toList();

                  if (chapterLessons.isEmpty) {
                    print("❌ No lessons found for this chapter");
                    return;
                  }

                  final firstLesson = chapterLessons.first;

                  // 2️⃣ Open video player
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseVideoPlayer(
                        videoUrl: firstLesson.videoUrl,
                        videoTitle: firstLesson.title,
                        isYouTube:
                            firstLesson.videoUrl.contains("youtube.com") ||
                            firstLesson.videoUrl.contains("youtu"),
                        autoPlay: true,
                      ),
                    ),
                  );
                },
              )
              .animate()
              .fadeIn(delay: (100 * index).ms)
              .slideX(
                begin: 0.5,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOut,
              );
        }).toList(),
      ],
    );
  }

  double _calculateOverallProgress() {
    if (widget.chapters.isEmpty) return 0.0;
    final totalProgress = widget.chapters.fold<double>(
      0.0,
      (sum, chapter) => sum + chapter.progress,
    );
    return totalProgress / widget.chapters.length;
  }
}

class _ChapterListItem extends StatelessWidget {
  final ChapterModel chapter;
  final int index;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback onTap;

  const _ChapterListItem({
    Key? key,
    required this.chapter,
    required this.index,
    required this.isCompleted,
    required this.isLocked,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCurrent = chapter.progress > 0 && !chapter.isCompleted;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.neonPurple.withOpacity(0.2)
            : AppColors.dark800.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isCurrent
              ? AppColors.neonPurple.withOpacity(0.5)
              : AppColors.dark700,
          width: 1,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppColors.neonPurple.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: isLocked ? null : onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Chapter number & status with neon glow
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getStatusColor(isCurrent),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getStatusColor(isCurrent).withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(child: _getStatusIcon(isCurrent)),
                ),

                const SizedBox(width: 16),

                // Chapter title & info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Chapter ${index + 1}: ${chapter.title}',
                              style: TextStyle(
                                color: isLocked
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isLocked)
                            Icon(
                              Icons.lock_outline,
                              color: Colors.white.withOpacity(0.5),
                              size: 16,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${chapter.formattedDuration} • ${chapter.lessonsText}',
                        style: TextStyle(
                          color: isLocked
                              ? Colors.white.withOpacity(0.4)
                              : Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (chapter.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          chapter.description,
                          style: TextStyle(
                            color: isLocked
                                ? Colors.white.withOpacity(0.4)
                                : Colors.white.withOpacity(0.6),
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (!isLocked && chapter.totalLessons > 0) ...[
                        const SizedBox(height: 8),
                        Text(
                          chapter.completionText,
                          style: TextStyle(
                            color: AppColors.neonCyan,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Chapter progress
                if (!isLocked && chapter.totalLessons > 0)
                  CircularProgressCustom(
                    progress: chapter.progress,
                    size: 40,
                    strokeWidth: 3,
                    showPercentage: false,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(bool isCurrent) {
    if (isLocked) return AppColors.dark600;
    if (isCompleted) return AppColors.neonGreen ?? Colors.green;
    if (isCurrent) return AppColors.neonPurple;
    return AppColors.neonCyan;
  }

  Widget _getStatusIcon(bool isCurrent) {
    if (isLocked) {
      return Icon(Icons.lock, color: Colors.white.withOpacity(0.5), size: 18);
    } else if (isCompleted) {
      return const Icon(Icons.check, color: Colors.white, size: 18);
    } else if (isCurrent) {
      return const Icon(Icons.play_arrow, color: Colors.white, size: 18);
    } else {
      return Text(
        '${index + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      );
    }
  }
}
