import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';
import 'package:learnforge_app/core/widgets/empty_state.dart';
import 'package:learnforge_app/core/widgets/glass_morphic_card.dart';
import 'package:learnforge_app/core/widgets/gradient_button.dart';
import 'package:learnforge_app/features/arena/models/challenge_model.dart';
import 'package:learnforge_app/features/arena/providers/arena_provider.dart';
import 'package:learnforge_app/features/courses/models/course_model.dart';
import 'package:learnforge_app/features/courses/providers/course_provider.dart';
import 'package:learnforge_app/features/courses/providers/enrolled_courses_provider.dart';
import 'package:learnforge_app/features/courses/providers/selected_course_provider.dart';
import 'package:learnforge_app/features/profile/providers/profile_provider.dart';

// Define Trend enum at the top level
enum Trend { up, down }

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(courseProvider.notifier).loadCourses();
      ref.read(courseProvider.notifier).loadMyCourses();
      ref.read(userProfileProvider.notifier).loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfileProvider);
    final enrolledCourses = ref.watch(enrolledCoursesProvider);
    final activeChallengesAsync = ref.watch(
      activeChallengesProvider,
    ); // This is AsyncValue
    final userProgress = ref.watch(userCourseProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.dark900,
      body: activeChallengesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.neonCyan),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error loading challenges: $error',
            style: const TextStyle(color: AppColors.white),
          ),
        ),
        data: (activeChallenges) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(userProfileState),
              _buildQuickStats(
                userProfileState,
                enrolledCourses.length,
                activeChallenges.length,
              ),
              _buildContinueLearningSection(enrolledCourses, userProgress),
              _buildActiveChallengesSection(
                activeChallenges,
              ), // Now it's List<ChallengeModel>
              _buildDailyGoalsSection(),
              _buildLearningInsightsSection(),
              _buildCommunityActivitySection(),
            ],
          );
        },
      ),
    );
  }

  // -------------------- ENHANCED APP BAR --------------------
  SliverAppBar _buildAppBar(UserProfileState userProfileState) {
    return SliverAppBar(
      expandedHeight: 280,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          children: [
            // Animated gradient background
            Container(
                  decoration: BoxDecoration(
                    gradient: SweepGradient(
                      center: Alignment.topLeft,
                      colors: [
                        AppColors.neonPurple.withOpacity(0.4),
                        AppColors.neonCyan.withOpacity(0.3),
                        AppColors.neonPink.withOpacity(0.2),
                        AppColors.neonBlue.withOpacity(0.1),
                      ],
                      stops: const [0.1, 0.4, 0.7, 1.0],
                    ),
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: 20000.ms, begin: 0, end: 1),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome text with animation
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.white.withOpacity(0.8),
                      fontFamily: 'Inter',
                    ),
                  ).animate().fadeIn(duration: 500.ms),

                  const SizedBox(height: 8),

                  // User name with typewriter effect
                  Text(
                        userProfileState.profile?.displayName ?? 'Code Master',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontFamily: 'Inter',
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 300.ms)
                      .slideY(begin: 0.3, end: 0, duration: 600.ms),

                  const SizedBox(height: 16),

                  // Motivational quote
                  GlassMorphicCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.neonCyan,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Every line of code brings you closer to mastery',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.white.withOpacity(0.9),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      floating: true,
      actions: [
        // Notification bell with badge
        Stack(
          children: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.neonPurple, AppColors.neonPink],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonPurple.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.white,
                  size: 22,
                ),
              ),
              onPressed: () => context.push('/notifications'),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.neonCyan,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // -------------------- CREATIVE QUICK STATS --------------------
  Widget _buildQuickStats(
    UserProfileState userState,
    int courseCount,
    int challengeCount,
  ) {
    final user = userState.profile;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Stats Grid with creative design
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildCreativeStatCard(
                  title: 'Learning Streak',
                  value: '${user?.userData['streak'] ?? 7} days',
                  subtitle: 'Keep going! 🔥',
                  icon: Icons.local_fire_department_rounded,
                  color: AppColors.neonPurple,
                  progress: 0.8,
                  onTap: () => context.push('/streak'),
                ),
                _buildCreativeStatCard(
                  title: 'Total XP',
                  value: '${user?.experience ?? 2450}',
                  subtitle: 'Level ${user?.level ?? 5}',
                  icon: Icons.auto_awesome_rounded,
                  color: AppColors.neonCyan,
                  progress: (user?.experience ?? 0) / 5000,
                  onTap: () => context.push('/profile'),
                ),
                _buildCreativeStatCard(
                  title: 'Active Courses',
                  value: '$courseCount',
                  subtitle: '$courseCount in progress',
                  icon: Icons.school_rounded,
                  color: AppColors.neonPink,
                  progress: courseCount / 10,
                  onTap: () => context.push('/courses'),
                ),
                _buildCreativeStatCard(
                  title: 'Challenges',
                  value: '$challengeCount',
                  subtitle: 'Ready to compete?',
                  icon: Icons.emoji_events_rounded,
                  color: AppColors.neonBlue,
                  progress: challengeCount / 5,
                  onTap: () => context.push('/arena'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreativeStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double progress,
    required VoidCallback onTap,
  }) {
    return GlassMorphicCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon with glow effect
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                  ),
                  border: Border.all(color: color.withOpacity(0.5), width: 2),
                ),
                child: Icon(icon, color: color, size: 24),
              ),

              // Animated value counter
              TweenAnimationBuilder(
                duration: 1500.ms,
                tween: IntTween(
                  begin: 0,
                  end:
                      int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ??
                      0,
                ),
                builder: (context, value, child) {
                  return Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontFamily: 'Inter',
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.white.withOpacity(0.7),
              fontFamily: 'Inter',
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),

          const SizedBox(height: 12),

          // Animated progress bar
          ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.dark700,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: color.withOpacity(0.3)),
        ],
      ),
    ).animate().scale(duration: 600.ms, curve: Curves.elasticOut);
  }

  // -------------------- ENHANCED CONTINUE LEARNING --------------------
  Widget _buildContinueLearningSection(
    List<Course> courses,
    Map<String, double> progress,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Continue Learning',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontFamily: 'Inter',
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/courses'),
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: AppColors.neonCyan,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.neonCyan,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (courses.isEmpty)
              EmptyState(
                title: 'No Courses Enrolled',
                subtitle: 'Start your learning journey by enrolling in courses',
                actionLabel: 'Browse Courses',
                onActionPressed: () => context.push('/courses'),
                icon: Icons.school_outlined,
              )
            else
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    final courseProgress = progress[course.id] ?? 0.0;

                    return Container(
                          width: 300,
                          margin: EdgeInsets.only(
                            right: index == courses.length - 1 ? 0 : 16,
                          ),
                          child: _buildCourseCard(course, courseProgress),
                        )
                        .animate()
                        .fadeIn(delay: (200 * index).ms)
                        .slideX(begin: 0.5, end: 0, duration: 500.ms);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(Course course, double progress) {
    return GlassMorphicCard(
      onTap: () {
        ref.read(selectedCourseProvider.notifier).state = course;
        context.push('/course/${course.id}');
      },
      padding: const EdgeInsets.all(0),
      child: Stack(
        children: [
          // Course thumbnail with gradient overlay
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              image: DecorationImage(
                image: NetworkImage(course.thumbnail),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Progress indicator overlay
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.dark700,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.neonCyan,
                  ),
                ),
              ),
            ),
          ),

          // Course info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [
                    AppColors.dark900.withOpacity(0.9),
                    AppColors.dark800.withOpacity(0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.person_rounded,
                        color: AppColors.white.withOpacity(0.6),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          course.instructor,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.white.withOpacity(0.6),
                            fontFamily: 'Inter',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}% complete',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.neonCyan,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),

                      GradientButton(
                        text: 'Continue',
                        onPressed: () {
                          ref.read(selectedCourseProvider.notifier).state =
                              course;
                          context.push('/course/${course.id}');
                        },
                        height: 32,
                        width: 100,
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Level badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getLevelColor(course.level).withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                course.level,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- GAMIFIED CHALLENGES SECTION --------------------
  Widget _buildActiveChallengesSection(List<ChallengeModel> challenges) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Active Challenges',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontFamily: 'Inter',
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/arena'),
                  child: Row(
                    children: [
                      Text(
                        'Join More',
                        style: TextStyle(
                          color: AppColors.neonPurple,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.neonPurple,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (challenges.isEmpty)
              EmptyState(
                title: 'No Active Challenges',
                subtitle:
                    'Join challenges to test your skills and earn rewards',
                actionLabel: 'Browse Challenges',
                onActionPressed: () => context.push('/arena'),
                icon: Icons.emoji_events_outlined,
                glowColor: AppColors.neonPurple,
              )
            else
              Column(
                children: challenges.map((challenge) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: _buildChallengeCard(challenge),
                  ).animate().fadeIn().slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 500.ms,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(ChallengeModel challenge) {
    final timeLeft = challenge.endDate.difference(DateTime.now());
    final hoursLeft = timeLeft.inHours;

    return GlassMorphicCard(
      onTap: () => context.push('/challenge/${challenge.id}'),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Challenge icon with glow
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.neonPurple, AppColors.neonPink],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonPurple.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontFamily: 'Inter',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                Text(
                  challenge.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white.withOpacity(0.7),
                    fontFamily: 'Inter',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    // Participants
                    Row(
                      children: [
                        Icon(
                          Icons.people_rounded,
                          color: AppColors.white.withOpacity(0.6),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${challenge.participantCount}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.white.withOpacity(0.6),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 12),

                    // XP Points
                    Row(
                      children: [
                        Icon(
                          Icons.bolt_rounded,
                          color: AppColors.neonYellow ?? Colors.amber,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${challenge.points} XP',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.neonYellow ?? Colors.amber,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Time left
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: hoursLeft < 24
                            ? AppColors.neonPink.withOpacity(0.2)
                            : AppColors.neonCyan.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        hoursLeft < 24 ? 'Ending soon!' : '${hoursLeft}h left',
                        style: TextStyle(
                          fontSize: 10,
                          color: hoursLeft < 24
                              ? AppColors.neonPink
                              : AppColors.neonCyan,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
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
    );
  }

  // -------------------- DAILY GOALS SECTION --------------------
  Widget _buildDailyGoalsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: GlassMorphicCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daily Learning Goals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.neonPurple, AppColors.neonPink],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '2/3 Complete',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _buildGoalItem(
                icon: Icons.play_lesson_rounded,
                title: 'Complete 1 chapter',
                completed: true,
                xp: 25,
              ),
              _buildGoalItem(
                icon: Icons.timer_rounded,
                title: '30 minutes of learning',
                completed: false,
                progress: 0.6,
                xp: 50,
              ),
              _buildGoalItem(
                icon: Icons.quiz_rounded,
                title: 'Take 1 quiz',
                completed: false,
                xp: 75,
              ),

              const SizedBox(height: 16),

              GradientButton(
                text: 'Set Weekly Goals',
                onPressed: () => context.push('/goals'),
                gradient: const LinearGradient(
                  colors: [AppColors.neonCyan, AppColors.neonBlue],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),
      ),
    );
  }

  Widget _buildGoalItem({
    required IconData icon,
    required String title,
    required bool completed,
    double progress = 0.0,
    required int xp,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dark700.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: completed
              ? AppColors.neonCyan.withOpacity(0.3)
              : AppColors.dark600,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon with status
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: completed
                      ? AppColors.neonCyan.withOpacity(0.2)
                      : AppColors.dark600,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: completed
                      ? AppColors.neonCyan
                      : AppColors.white.withOpacity(0.5),
                  size: 20,
                ),
              ),
              if (completed)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.neonCyan,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.white,
                      size: 10,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),

                if (!completed && progress > 0) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.dark600,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.neonPurple,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // XP Reward
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  AppColors.neonYellow?.withOpacity(0.2) ??
                  Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    AppColors.neonYellow?.withOpacity(0.3) ??
                    Colors.amber.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.bolt_rounded,
                  color: AppColors.neonYellow ?? Colors.amber,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  '$xp XP',
                  style: TextStyle(
                    color: AppColors.neonYellow ?? Colors.amber,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- LEARNING INSIGHTS --------------------
  Widget _buildLearningInsightsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Insights',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                fontFamily: 'Inter',
              ),
            ),

            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildInsightCard(
                  title: 'Weekly Progress',
                  value: '+12%',
                  subtitle: 'From last week',
                  trend: Trend.up,
                  color: AppColors.neonGreen ?? Colors.green,
                ),
                _buildInsightCard(
                  title: 'Time Spent',
                  value: '8.5h',
                  subtitle: 'This week',
                  trend: Trend.up,
                  color: AppColors.neonCyan,
                ),
                _buildInsightCard(
                  title: 'Skills Improved',
                  value: '3',
                  subtitle: 'New competencies',
                  trend: Trend.up,
                  color: AppColors.neonPurple,
                ),
                _buildInsightCard(
                  title: 'Challenges Won',
                  value: '2',
                  subtitle: 'This month',
                  trend: Trend.up,
                  color: AppColors.neonPink,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String value,
    required String subtitle,
    required Trend trend,
    required Color color,
  }) {
    return GlassMorphicCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              trend == Trend.up
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              color: color,
              size: 20,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              fontFamily: 'Inter',
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.white.withOpacity(0.7),
              fontFamily: 'Inter',
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(duration: 600.ms, curve: Curves.elasticOut);
  }

  // -------------------- COMMUNITY ACTIVITY --------------------
  Widget _buildCommunityActivitySection() {
    final communityActivities = [
      {
        'name': 'Sarah Chen',
        'action': 'completed Flutter Animations course',
        'time': '2 hours ago',
        'avatar':
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
      },
      {
        'name': 'Mike Rodriguez',
        'action': 'earned 500 XP in UI Challenge',
        'time': '5 hours ago',
        'avatar':
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      },
      {
        'name': 'Alex Johnson',
        'action': 'started Advanced Dart Programming',
        'time': '1 day ago',
        'avatar':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      },
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Community Activity',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                fontFamily: 'Inter',
              ),
            ),

            const SizedBox(height: 16),

            GlassMorphicCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ...communityActivities.map((activity) {
                    return _buildCommunityItem(
                      avatar: activity['avatar']!,
                      name: activity['name']!,
                      action: activity['action']!,
                      time: activity['time']!,
                    ).animate().fadeIn().slideX(
                      begin: 0.5,
                      end: 0,
                      duration: 500.ms,
                    );
                  }),

                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: () => context.push('/community'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'See More Activity',
                          style: TextStyle(
                            color: AppColors.neonCyan,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.neonCyan,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityItem({
    required String avatar,
    required String name,
    required String action,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Avatar with gradient border
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.neonPurple, AppColors.neonCyan],
              ),
            ),
            child: ClipOval(
              child: Image.network(
                avatar,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.dark700,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.white,
                      size: 20,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                      TextSpan(
                        text: ' $action',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.7),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.white.withOpacity(0.5),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- HELPER METHODS --------------------
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
