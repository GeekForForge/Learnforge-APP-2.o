import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';
import 'package:learnforge_app/core/widgets/gradient_button.dart';
import 'package:learnforge_app/features/courses/providers/selected_course_provider.dart';
import 'package:learnforge_app/features/courses/widgets/chapter_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:learnforge_app/core/widgets/particle_background.dart'; // Add this import

class CourseDetailScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isJoined = false;
  final double _progress = 0.65;
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();

    // For demo, empty videoId; replace with a real one if available
    _youtubeController = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _joinCourse() {
    setState(() {
      _isJoined = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.neonGreen,
        content: const Text(
          'Course Enrolled! Happy Learning!',
          style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  void _startCourse() {
    // Navigate to first lesson or video
  }

  @override
  Widget build(BuildContext context) {
    final selectedCourse = ref.watch(selectedCourseProvider);

    if (selectedCourse == null) {
      return Scaffold(
        backgroundColor: AppColors.dark900,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.neonCyan),
              const SizedBox(height: 16),
              Text(
                'Loading course...',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Replace NeonParticleBackground with ParticleBackground
          ParticleBackground(particleCount: 30),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(selectedCourse.thumbnail),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.dark900.withValues(alpha: 0.8),
                              Colors.transparent,
                              AppColors.dark900.withValues(alpha: 0.9),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedCourse.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ).animate().slideX(
                                  begin: -0.3,
                                  end: 0,
                                  duration: 600.ms,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildStatItem(
                                      Icons.schedule,
                                      '${selectedCourse.duration} Hours',
                                      AppColors.neonCyan,
                                    ),
                                    const SizedBox(width: 16),
                                    _buildStatItem(
                                      Icons.people,
                                      '${selectedCourse.enrolledCount} Enrolled',
                                      AppColors.neonPurple,
                                    ),
                                    const SizedBox(width: 16),
                                    _buildStatItem(
                                      Icons.star,
                                      '${selectedCourse.rating} (${selectedCourse.totalRatings})',
                                      AppColors.neonPink,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (_isJoined) _buildProgressSection(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: YoutubePlayer(
                          controller: _youtubeController,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: AppColors.neonPink,
                          progressColors: ProgressBarColors(
                            playedColor: AppColors.neonPink,
                            handleColor: AppColors.neonBlue,
                          ),
                        ),
                      ),
                      _buildSection(
                        title: 'Course Overview',
                        icon: Icons.description,
                        color: AppColors.neonBlue,
                        child: Text(
                          selectedCourse.description,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 16,
                            height: 1.6,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'What You\'ll Learn',
                        icon: Icons.checklist,
                        color: AppColors.neonGreen,
                        child: Column(
                          children: selectedCourse.learningObjectives
                              .map((objective) => _buildLearningItem(objective))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'Course Content',
                        icon: Icons.library_books,
                        color: AppColors.neonCyan,
                        child: ChapterList(
                          chapters: selectedCourse.chapters, // FIX
                          lessons: selectedCourse.lessons, // FIX
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.dark900.withValues(alpha: 0.9),
                    AppColors.dark900,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: const Border(
                  top: BorderSide(color: AppColors.dark700, width: 1),
                ),
              ),
              child: Row(
                children: [
                  if (!_isJoined)
                    Expanded(
                      child: GradientButton(
                        text: selectedCourse.isFree
                            ? 'Enroll for Free'
                            : 'Enroll for ₹${selectedCourse.price}',
                        onPressed: _joinCourse,
                        gradient: const LinearGradient(
                          colors: [AppColors.neonPurple, AppColors.neonPink],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    )
                  else ...[
                    Expanded(
                      flex: 2,
                      child: GradientButton(
                        text: 'Start Learning',
                        onPressed: _startCourse,
                        gradient: const LinearGradient(
                          colors: [AppColors.neonCyan, AppColors.neonBlue],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: AppColors.neonPurple.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.forum,
                            color: AppColors.neonPurple,
                          ),
                          onPressed: () {
                            // Navigate to discussion
                          },
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
      ],
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.neonCyan.withValues(alpha: 0.1),
            AppColors.neonPurple.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.neonCyan.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: TextStyle(
                  color: AppColors.neonCyan,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.dark700,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                    height: 8,
                    width: MediaQuery.of(context).size.width * _progress * 0.7,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.neonCyan, AppColors.neonBlue],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonCyan.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: 2000.ms,
                    color: AppColors.neonCyan.withValues(alpha: 0.3),
                  ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Complete the remaining lessons to finish the course',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.5, end: 0, duration: 500.ms);
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.dark800.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.dark700, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildLearningItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.neonGreen,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // List<ChapterModel> _generateMockChapters() {
  //   return [
  //     ChapterModel(
  //       id: '1',
  //       title: 'Introduction to the Course',
  //       description:
  //           'Get started with the basics and understand what you will learn',
  //       orderIndex: 1,
  //       totalLessons: 3,
  //       completedLessons: 3,
  //       estimatedMinutes: 30,
  //       isLocked: false,
  //       lessonIds: ['lesson_1_1', 'lesson_1_2', 'lesson_1_3'],
  //     ),
  //     ChapterModel(
  //       id: '2',
  //       title: 'Core Concepts',
  //       description: 'Dive deep into the fundamental concepts and principles',
  //       orderIndex: 2,
  //       totalLessons: 5,
  //       completedLessons: 5,
  //       estimatedMinutes: 45,
  //       isLocked: false,
  //       lessonIds: [
  //         'lesson_2_1',
  //         'lesson_2_2',
  //         'lesson_2_3',
  //         'lesson_2_4',
  //         'lesson_2_5',
  //       ],
  //     ),
  //     ChapterModel(
  //       id: '3',
  //       title: 'Advanced Topics',
  //       description: 'Explore advanced techniques and real-world applications',
  //       orderIndex: 3,
  //       totalLessons: 4,
  //       completedLessons: 2,
  //       estimatedMinutes: 60,
  //       isLocked: false,
  //       lessonIds: ['lesson_3_1', 'lesson_3_2', 'lesson_3_3', 'lesson_3_4'],
  //     ),
  //     ChapterModel(
  //       id: '4',
  //       title: 'Final Project',
  //       description:
  //           'Apply everything you have learned in a comprehensive project',
  //       orderIndex: 4,
  //       totalLessons: 3,
  //       completedLessons: 0,
  //       estimatedMinutes: 90,
  //       isLocked: true,
  //       lessonIds: ['lesson_4_1', 'lesson_4_2', 'lesson_4_3'],
  //     ),
  //   ];
  // }
}
