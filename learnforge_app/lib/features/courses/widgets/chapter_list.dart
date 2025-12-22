import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';
import 'package:learnforge_app/features/courses/models/chapter_model.dart';
import 'package:learnforge_app/features/courses/models/course_model.dart';
import 'package:learnforge_app/features/courses/widgets/course_video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnforge_app/features/courses/providers/course_provider.dart';
import 'progress_bar_custom.dart';

class ChapterList extends StatefulWidget {
  final List<ChapterModel> chapters;
  final List<Lesson> lessons;
  final String courseId;

  const ChapterList({
    super.key,
    required this.chapters,
    required this.lessons,
    required this.courseId, // ADD THIS
  });

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
                      color: AppColors.neonPurple.withValues(alpha: 0.9),
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
              Text(
                '${widget.chapters.length} chapters',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
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

          // Get lessons for this chapter
          final chapterLessons = widget.lessons
              .where((lesson) => chapter.lessonIds.contains(lesson.id))
              .toList();

          return _ChapterListItem(
            chapter: chapter,
            index: index,
            isCompleted: isCompleted,
            isLocked: isLocked,
            lessons: chapterLessons,
            courseId: widget.courseId, 
          )
          .animate()
          .fadeIn(delay: (100 * index).ms)
          .slideX(
            begin: 0.5,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOut,
          );
        }),
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

class _ChapterListItem extends ConsumerStatefulWidget {
  final ChapterModel chapter;
  final int index;
  final bool isCompleted;
  final bool isLocked;
  final List<Lesson> lessons;
  final String courseId;

  const _ChapterListItem({
    required this.chapter,
    required this.index,
    required this.isCompleted,
    required this.isLocked,
    required this.lessons,
    required this.courseId,
  });

  @override
  ConsumerState<_ChapterListItem> createState() => _ChapterListItemState();
}

class _ChapterListItemState extends ConsumerState<_ChapterListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Check if any lesson in this chapter is currently playing or "current" (not implemented globally yet, purely visual based on expansion)
    final isCurrent = widget.chapter.progress > 0 && !widget.chapter.isCompleted;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isCurrent
                ? AppColors.neonPurple.withValues(alpha: 0.2)
                : AppColors.dark800.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isCurrent
                  ? AppColors.neonPurple.withValues(alpha: 0.5)
                  : AppColors.dark700,
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: widget.isLocked
                  ? null
                  : () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Chapter Status Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getStatusColor(isCurrent),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _getStatusColor(isCurrent).withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(child: _getStatusIcon(isCurrent)),
                    ),
                    const SizedBox(width: 16),
                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chapter ${widget.index + 1}: ${widget.chapter.title}',
                            style: TextStyle(
                              color: widget.isLocked ? Colors.white54 : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${widget.chapter.totalLessons} lessons',
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                           if (!widget.isLocked && widget.chapter.totalLessons > 0)
                             Padding(
                               padding: const EdgeInsets.only(top: 4.0),
                               child: Text(
                                 widget.chapter.completionText,
                                 style: const TextStyle(
                                   color: AppColors.neonCyan,
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                             ),
                        ],
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Expanded Lessons List
        if (_isExpanded && !widget.isLocked)
          ...widget.lessons.map((lesson) {
             final isLessonCompleted = lesson.isCompleted;
             return Container(
               margin: const EdgeInsets.only(left: 32, right: 16, bottom: 8),
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
               decoration: BoxDecoration(
                 color: AppColors.dark700.withValues(alpha: 0.5),
                 borderRadius: BorderRadius.circular(10),
                 border: Border.all(color: AppColors.dark600),
               ),
               child: Row(
                 children: [
                   // Play Button
                   IconButton(
                     icon: Icon(Icons.play_circle_fill, color: AppColors.neonBlue),
                     onPressed: () {
                        // Play video
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseVideoPlayer(
                              videoUrl: lesson.videoUrl,
                              videoTitle: lesson.title,
                              isYouTube: lesson.videoUrl.contains("youtube.com") || lesson.videoUrl.contains("youtu"),
                              autoPlay: true,
                            ),
                          ),
                        );
                     },
                   ),
                   const SizedBox(width: 8),
                   Expanded(
                     child: Text(
                       lesson.title,
                       style: TextStyle(
                         color: isLessonCompleted ? Colors.white54 : Colors.white,
                         decoration: isLessonCompleted ? TextDecoration.lineThrough : null,
                       ),
                     ),
                   ),
                   // Mark Complete Checkbox
                   Transform.scale(
                     scale: 0.9,
                     child: Checkbox(
                       value: isLessonCompleted,
                       onChanged: (val) {
                          ref.read(courseProvider.notifier).toggleLessonCompletion(widget.courseId, lesson.id);
                       },
                       activeColor: AppColors.neonGreen,
                       checkColor: Colors.black,
                       side: const BorderSide(color: Colors.white54),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                     ),
                   ),
                 ],
               ),
             ).animate().fadeIn().slideX(begin: 0.2, duration: 200.ms);
          }),
      ],
    );
  }

  Color _getStatusColor(bool isCurrent) {
    if (widget.isLocked) return AppColors.dark600;
    if (widget.isCompleted) return AppColors.neonGreen;
    if (isCurrent) return AppColors.neonPurple;
    return AppColors.neonCyan;
  }

  Widget _getStatusIcon(bool isCurrent) {
    if (widget.isLocked) {
      return Icon(Icons.lock, color: Colors.white.withValues(alpha: 0.5), size: 18);
    } else if (widget.isCompleted) {
      return const Icon(Icons.check, color: Colors.white, size: 18);
    } else {
      return Text(
        '${widget.index + 1}',
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
