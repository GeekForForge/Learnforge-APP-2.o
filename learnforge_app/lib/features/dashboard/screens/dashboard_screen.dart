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
import 'package:learnforge_app/features/auth/models/user_model.dart';
import 'package:learnforge_app/features/courses/models/course_model.dart';
import 'package:learnforge_app/features/courses/providers/course_provider.dart';
import 'package:learnforge_app/features/profile/providers/profile_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProfileFutureProvider);
    final enrolledCourses = ref.watch(enrolledCoursesProvider);
    final activeChallenges = ref.watch(activeChallengesProvider);

    return Scaffold(
      backgroundColor: AppColors.dark900,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(userData),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildQuickStats(),
                  const SizedBox(height: 24),
                  _buildContinueLearningSection(enrolledCourses),
                  const SizedBox(height: 24),
                  _buildActiveChallenges(activeChallenges),
                  const SizedBox(height: 24),
                  _buildLearningGoals(),
                  const SizedBox(height: 24),
                  _buildCommunityActivity(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- APP BAR --------------------
  SliverAppBar _buildAppBar(AsyncValue<UserModel> userData) {
    return SliverAppBar(
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.neonPurple.withOpacity(0.3),
                AppColors.neonCyan.withOpacity(0.2),
                AppColors.dark900,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            child: userData.when(
              loading: () => _buildLoadingHeader(),
              error: (_, __) => _buildErrorHeader(),
              data: (user) => _buildUserHeader(user),
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.dark800,
      elevation: 0,
      pinned: true,
      floating: true,
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.neonPurple.withOpacity(0.5)),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.white,
            ),
          ),
          onPressed: () => context.push('/notifications'),
        ),
      ],
    );
  }

  Widget _buildUserHeader(UserModel user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.neonPurple, AppColors.neonCyan],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonPurple.withOpacity(0.5),
                blurRadius: 15,
              ),
            ],
          ),
          child: ClipOval(
            child: user.avatar.isNotEmpty
                ? Image.network(user.avatar, fit: BoxFit.cover)
                : const Icon(Icons.person, color: AppColors.white, size: 30),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(fontSize: 14, color: AppColors.grey400),
              ),
              const SizedBox(height: 4),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ready to continue your learning journey?',
                style: TextStyle(fontSize: 14, color: AppColors.grey400),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // -------------------- QUICK STATS --------------------
  Widget _buildQuickStats() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatCard(
          title: 'Learning Streak',
          value: '7 days',
          icon: Icons.local_fire_department,
          color: AppColors.neonPurple,
          progress: 0.7,
        ),
        _buildStatCard(
          title: 'XP Points',
          value: '2,450',
          icon: Icons.auto_awesome,
          color: AppColors.neonCyan,
          progress: 0.4,
        ),
        _buildStatCard(
          title: 'Courses',
          value: '5',
          icon: Icons.school,
          color: AppColors.neonPink,
          progress: 0.6,
        ),
        _buildStatCard(
          title: 'Challenges',
          value: '3',
          icon: Icons.emoji_events,
          color: AppColors.neonBlue,
          progress: 0.3,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required double progress,
  }) {
    return GlassMorphicCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 12, color: AppColors.grey400)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.dark700,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  // -------------------- CONTINUE LEARNING --------------------
  Widget _buildContinueLearningSection(AsyncValue<List<CourseModel>> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Continue Learning',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/courses'),
              child: Text(
                'View All',
                style: TextStyle(color: AppColors.neonCyan),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        courses.when(
          loading: () => _buildLoadingCourses(),
          error: (_, __) => _buildErrorCourses(),
          data: (courseList) {
            if (courseList.isEmpty) {
              return EmptyState(
                title: 'No Courses Yet',
                subtitle: 'Start your learning journey by enrolling in courses',
                actionLabel: 'Browse Courses',
                onActionPressed: () => context.push('/courses'),
              );
            }

            return SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: courseList.length,
                itemBuilder: (context, index) {
                  final course = courseList[index];
                  return Container(
                    width: 280,
                    margin: EdgeInsets.only(
                      right: index == courseList.length - 1 ? 0 : 12,
                    ),
                    child: GlassMorphicCard(
                      onTap: () {
                        ref.read(selectedCourseProvider.notifier).state =
                            course;
                        context.push('/course-detail');
                      },
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.dark700,
                                  image: course.thumbnail.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(course.thumbnail),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: course.thumbnail.isEmpty
                                    ? const Icon(
                                        Icons.school,
                                        color: AppColors.grey400,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${course.completedChapters}/${course.totalChapters} chapters',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.grey400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: course.progress,
                              backgroundColor: AppColors.dark700,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.neonCyan,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${(course.progress * 100).toInt()}% complete',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey400,
                                ),
                              ),
                              GradientButton(
                                text: 'Continue',
                                onPressed: () {
                                  ref
                                          .read(selectedCourseProvider.notifier)
                                          .state =
                                      course;
                                  context.push('/course-detail');
                                },
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: (100 * index).ms),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // -------------------- ACTIVE CHALLENGES --------------------
  Widget _buildActiveChallenges(AsyncValue<List<ChallengeModel>> challenges) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Active Challenges',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/arena'),
              child: Text(
                'View All',
                style: TextStyle(color: AppColors.neonCyan),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        challenges.when(
          loading: () => _buildLoadingChallenges(),
          error: (_, __) => _buildErrorChallenges(),
          data: (challengeList) {
            if (challengeList.isEmpty) {
              return EmptyState(
                title: 'No Active Challenges',
                subtitle:
                    'Join challenges to test your skills and earn rewards',
                actionLabel: 'Browse Challenges',
                onActionPressed: () => context.push('/arena'),
                glowColor: AppColors.neonPurple,
              );
            }

            return Column(
              children: challengeList.map((challenge) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: GlassMorphicCard(
                    onTap: () => context.push('/challenge/${challenge.id}'),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.neonPurple,
                                AppColors.neonCyan,
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            color: AppColors.white,
                            size: 24,
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
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${challenge.participantCount} participants • ${challenge.points} XP',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(
                              challenge.difficulty,
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getDifficultyColor(
                                challenge.difficulty,
                              ).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            challenge.difficulty,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getDifficultyColor(challenge.difficulty),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.greenAccent;
      case 'medium':
        return Colors.orangeAccent;
      case 'hard':
        return Colors.redAccent;
      default:
        return AppColors.neonCyan;
    }
  }

  // -------------------- PLACEHOLDERS --------------------
  Widget _buildLoadingHeader() =>
      const Center(child: CircularProgressIndicator(color: AppColors.neonCyan));

  Widget _buildErrorHeader() => const Text(
    'Error loading profile',
    style: TextStyle(color: AppColors.neonPink),
  );

  Widget _buildLoadingCourses() =>
      const Center(child: CircularProgressIndicator(color: AppColors.neonCyan));

  Widget _buildErrorCourses() => EmptyState(
    title: 'Error Loading Courses',
    subtitle: 'Unable to load your courses right now.',
    actionLabel: 'Retry',
    onActionPressed: () => ref.invalidate(enrolledCoursesProvider),
  );

  Widget _buildLoadingChallenges() =>
      const Center(child: CircularProgressIndicator(color: AppColors.neonCyan));

  Widget _buildErrorChallenges() => EmptyState(
    title: 'Error Loading Challenges',
    subtitle: 'Unable to load active challenges.',
    actionLabel: 'Retry',
    onActionPressed: () => ref.invalidate(activeChallengesProvider),
  );

  // -------------------- LEARNING GOALS + COMMUNITY --------------------
  Widget _buildLearningGoals() {
    return GlassMorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Learning Goals',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildGoalItem(
            icon: Icons.play_lesson,
            title: 'Complete 1 chapter',
            completed: true,
          ),
          _buildGoalItem(
            icon: Icons.timer,
            title: '30 minutes of learning',
            completed: false,
            progress: 0.6,
          ),
          _buildGoalItem(
            icon: Icons.quiz,
            title: 'Take 1 quiz',
            completed: false,
          ),
          const SizedBox(height: 16),
          GradientButton(
            text: 'Set Weekly Goals',
            onPressed: () => context.push('/goals'),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem({
    required IconData icon,
    required String title,
    required bool completed,
    double progress = 0.0,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.dark700.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: completed
                  ? AppColors.neonCyan.withOpacity(0.2)
                  : AppColors.dark600,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: completed ? AppColors.neonCyan : AppColors.grey400,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!completed && progress > 0) ...[
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.dark600,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.neonPurple,
                      ),
                      minHeight: 4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? AppColors.neonCyan : AppColors.grey400,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Community Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        GlassMorphicCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCommunityItem(
                avatar: 'https://example.com/avatar1.jpg',
                name: 'Sarah Chen',
                action: 'completed Flutter Basics course',
                time: '2 hours ago',
              ),
              _buildCommunityItem(
                avatar: 'https://example.com/avatar2.jpg',
                name: 'Mike Rodriguez',
                action: 'earned 500 XP in Coding Challenge',
                time: '5 hours ago',
              ),
              _buildCommunityItem(
                avatar: 'https://example.com/avatar3.jpg',
                name: 'Alex Johnson',
                action: 'started Advanced Dart Programming',
                time: '1 day ago',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityItem({
    required String avatar,
    required String name,
    required String action,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
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
                  return const Icon(
                    Icons.person,
                    color: AppColors.white,
                    size: 20,
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
                        ),
                      ),
                      TextSpan(
                        text: ' $action',
                        style: TextStyle(color: AppColors.grey400),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: AppColors.grey400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
