import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/particle_background.dart';
import '../../../features/arena/models/challenge_model.dart';
import '../../../features/arena/providers/arena_provider.dart';
import '../../../features/courses/models/youtube_playlist_model.dart';
import '../../../features/courses/providers/course_provider.dart';
import '../../../features/profile/providers/profile_provider.dart';

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
      ref.read(courseProvider.notifier).loadPlaylists();
      ref.read(courseProvider.notifier).loadMyPlaylists();
      ref.read(profileProvider.notifier).loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseProvider);
    final enrolledPlaylists = ref.watch(myPlaylistsProvider);
    final activeChallengesAsync = ref.watch(activeChallengesProvider);
    final profileState = ref.watch(profileProvider);

    return ParticleBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: activeChallengesAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.neonCyan),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Error loading challenges: $error',
              style: TextStyles.inter(color: AppColors.white),
            ),
          ),
          data: (activeChallenges) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(),
                _buildHeroHeader(profileState),
                _buildQuickStatsSection(
                  enrolledPlaylists.length,
                  activeChallenges.length,
                  profileState.profile?.experience ?? 0,
                ),
                _buildContinueLearningSection(enrolledPlaylists),
                _buildArenaHighlightsSection(activeChallenges),
                _buildDailyMissionsSection(
                  profileState.profile?.userData['streak'] ?? 0,
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            );
          },
        ),
      ),
    );
  }

  // -------------------- TOP APP BAR --------------------
  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      elevation: 0,
      pinned: true,
      floating: false,
      snap: false,
      toolbarHeight: 72,
      backgroundColor: AppColors.dark900.withOpacity(0.99),

      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8),
        child: GestureDetector(
          onTap: () {
            // Optional: navigate to home or about
          },
          child: CircleAvatar(
            radius: 22, // Adjust size as needed
            backgroundColor: Colors.transparent, // No background color
            child: ClipOval(
              child: Image.asset(
                'assets/images/icon-removebg-preview.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),

      title: const AnimatedNeonText(text: "LearnForge", fontSize: 24),

      centerTitle: true,

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 8),
          child: CircleAvatar(
            backgroundColor: AppColors.dark700.withOpacity(0.8),
            child: IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: AppColors.neonPink,
                size: 20,
              ),
              onPressed: () => _openNotificationPanel(context),
            ),
          ),
        ),
        // .animate(onPlay: (controller) => controller.repeat())
        // .shimmer(
        //   duration: 2000.ms,
        //   color: AppColors.neonPink.withOpacity(0.3),
        // ),
      ],
    );
  }

  // -------------------- WELCOME HEADER --------------------

  Widget _buildHeroHeader(UserProfileState profileState) {
    final user = profileState.profile;

    return SliverToBoxAdapter(
      child:
          Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: GlassMorphicCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            context.push('/profile'), // <-- open profile page
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.neonCyan.withOpacity(0.25),
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: AppColors.dark700,
                            backgroundImage: AssetImage(
                              'assets/images/avatar_default.png',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        user?.displayName ?? "Learner",
                        style: TextStyles.orbitron(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Level ${_calculateLevelFromXP(user?.experience ?? 0)} • ${user?.experience ?? 0} XP",
                        style: TextStyles.inter(
                          fontSize: 14,
                          color: AppColors.grey400,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.dark700,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: LinearProgressIndicator(
                          value: _calculateLevelProgress(
                            user?.experience ?? 0,
                            _calculateLevelFromXP(user?.experience ?? 0),
                          ),
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.neonCyan,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.1, end: 0, duration: 600.ms)
              .shimmer(
                duration: 2000.ms,
                color: AppColors.neonCyan.withOpacity(0.1),
              ),
    );
  }

  double _calculateLevelProgress(int experience, int level) {
    // Simple progression: each level requires 500 XP more than previous
    final baseXP = (level - 1) * 500;
    final nextLevelXP = level * 500;
    final currentLevelXP = experience - baseXP;
    return currentLevelXP / 500;
  }

  int _calculateLevelFromXP(int xp) {
    // Every 500 XP = +1 level
    if (xp <= 0) return 1;

    return (xp / 500).floor() + 1;
  }

  // -------------------- QUICK STATS SECTION --------------------
  Widget _buildQuickStatsSection(
    int playlistCount,
    int challengeCount,
    int totalXP,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 12),
              child: Text(
                'Quick Stats',
                style: TextStyles.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatCard(
                  icon: '📚',
                  title: 'My Courses',
                  value: '$playlistCount',
                  subtitle: 'Enrolled',
                  color: AppColors.neonPurple,
                  onTap: () => context.push('/courses'),
                ),
                _buildStatCard(
                  icon: '🏆',
                  title: 'Active Challenges',
                  value: '$challengeCount',
                  subtitle: 'Participating',
                  color: AppColors.neonCyan,
                ),
                _buildStatCard(
                  icon: '⏱',
                  title: 'Hours Watched',
                  value: '12',
                  subtitle: 'This week',
                  color: AppColors.neonPink,
                ),
                _buildStatCard(
                  icon: '💡',
                  title: 'Total XP',
                  value: '$totalXP',
                  subtitle: 'Experience',
                  color: AppColors.neonBlue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GlassMorphicCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value,
                  style: TextStyles.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyles.inter(
              fontSize: 14,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(subtitle, style: TextStyles.inter(fontSize: 12, color: color)),
        ],
      ),
    ).animate().scale(duration: 600.ms);
  }

  // -------------------- CONTINUE LEARNING SECTION --------------------
  Widget _buildContinueLearningSection(List<YouTubePlaylist> playlists) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 16),
              child: Text(
                'Continue Learning',
                style: TextStyles.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),

            if (playlists.isEmpty)
              EmptyState(
                title: 'No Courses Enrolled',
                subtitle: 'Start your learning journey by enrolling in courses',
                actionLabel: 'Browse Courses',
                onActionPressed: () => context.push('/courses'),
                glowColor: AppColors.neonPurple,
              )
            else
              SizedBox(
                height: 280,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 8),
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlists[index];
                    return Container(
                      margin: EdgeInsets.only(
                        right: index == playlists.length - 1 ? 8 : 16,
                      ),
                      child: _buildLearningCard(playlist),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningCard(YouTubePlaylist playlist) {
    return GlassMorphicCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push('/playlist/${playlist.id}'),

      child: SizedBox(
        width: 260,
        height: 280, // bounded card height -> makes layout predictable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // THUMBNAIL (fixed height)
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(playlist.thumbnailUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.45),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // XP badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neonCyan,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "+50 XP",
                        style: TextStyles.inter(
                          fontSize: 11,
                          color: AppColors.dark900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Category chip
                  Positioned(
                    bottom: 8,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.neonPurple.withOpacity(0.7),
                      ),
                      child: Text(
                        playlist.channelTitle,
                        style: TextStyles.inter(
                          fontSize: 10,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // BODY: Expanded uses remaining bounded height (safe because SizedBox above)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // spaceBetween ensures title top, button bottom
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title + optional progress area (top)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playlist.title,
                          style: TextStyles.orbitron(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        if (playlist.userProgress > 0) ...[
                          LinearProgressIndicator(
                            value: playlist.userProgress,
                            backgroundColor: AppColors.dark700,
                            valueColor: AlwaysStoppedAnimation(
                              AppColors.neonBlue,
                            ),
                            minHeight: 6,
                          ),
                          const SizedBox(height: 8),
                        ] else
                          const SizedBox(height: 8),
                      ],
                    ),

                    // Button area (bottom)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GradientButton(
                          text: playlist.userProgress > 0
                              ? "Continue"
                              : "Start Learning",
                          onPressed: () =>
                              context.push('/playlist/${playlist.id}'),
                          height: 42,
                        ),
                        const SizedBox(height: 4), // safe padding for glow
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

  // -------------------- ARENA HIGHLIGHTS SECTION --------------------
  Widget _buildArenaHighlightsSection(List<ChallengeModel> challenges) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 16),
              child: Text(
                'Arena Highlights',
                style: TextStyles.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
            // Arena Cards
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(width: 8),
                  _buildArenaCard(
                    title: 'Solo Challenge',
                    subtitle: 'Quick Sort Challenge',
                    icon: Icons.person_rounded,
                    color: AppColors.neonPurple,
                    onTap: () => context.push('/arena?solo=true'),
                  ),
                  _buildArenaCard(
                    title: 'Multiplayer Mode',
                    subtitle: 'Compete with others',
                    icon: Icons.people_rounded,
                    color: AppColors.neonCyan,
                    onTap: () => context.push('/arena?mode=multiplayer'),
                  ),
                  _buildArenaCard(
                    title: 'Collaborate Mode',
                    subtitle: 'Team up & learn',
                    icon: Icons.group_work_rounded,
                    color: AppColors.neonPink,
                    onTap: () => context.push('/arena?mode=collaborate'),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // XP Earned and Go to Arena Button
            GlassMorphicCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'XP Earned Today',
                          style: TextStyles.inter(
                            fontSize: 14,
                            color: AppColors.grey400,
                          ),
                        ),
                        Text(
                          '120 XP',
                          style: TextStyles.orbitron(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neonCyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GradientButton(
                    text: 'Go to Arena',
                    onPressed: () => context.push('/arena'),
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArenaCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: GlassMorphicCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyles.inter(fontSize: 12, color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- DAILY MISSIONS SECTION --------------------
  Widget _buildDailyMissionsSection(int streakDays) {
    final completedMissions = 1;
    final totalMissions = 3;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 16),
              child: Text(
                'Daily Missions',
                style: TextStyles.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
            GlassMorphicCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Streak Tracker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            color: AppColors.neonPink,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Streak: $streakDays days',
                            style: TextStyles.inter(
                              fontSize: 14,
                              color: AppColors.neonPink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$completedMissions/$totalMissions Completed',
                        style: TextStyles.inter(
                          fontSize: 14,
                          color: AppColors.grey400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Mission Items
                  _buildMissionItem(
                    icon: Icons.play_lesson_rounded,
                    title: 'Watch 30 minutes',
                    completed: true,
                  ),
                  _buildMissionItem(
                    icon: Icons.code_rounded,
                    title: 'Complete 1 coding exercise',
                    completed: false,
                  ),
                  _buildMissionItem(
                    icon: Icons.quiz_rounded,
                    title: 'Take a quick quiz',
                    completed: false,
                  ),
                  const SizedBox(height: 16),
                  GradientButton(
                    text: 'Set Goals',
                    onPressed: () => context.push('/goals'),
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionItem({
    required IconData icon,
    required String title,
    required bool completed,
  }) {
    return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.dark700.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: completed
                  ? AppColors.neonCyan.withOpacity(0.3)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: completed
                      ? AppColors.neonCyan.withOpacity(0.2)
                      : AppColors.dark600,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: completed ? AppColors.neonCyan : AppColors.grey400,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyles.inter(
                    color: completed ? AppColors.white : AppColors.grey400,
                    fontWeight: completed ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: 300.ms,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: completed
                      ? AppColors.neonCyan.withOpacity(0.2)
                      : AppColors.dark600,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: completed ? AppColors.neonCyan : AppColors.grey600,
                  ),
                ),
                child: Icon(
                  completed
                      ? Icons.check_rounded
                      : Icons.radio_button_unchecked,
                  color: completed ? AppColors.neonCyan : AppColors.grey400,
                  size: 16,
                ),
              ),
            ],
          ),
        )
        .animate(
          onComplete: (controller) {
            if (completed) controller.repeat();
          },
        )
        .shimmer(duration: 2000.ms, color: AppColors.neonCyan.withOpacity(0.3));
  }

  // -------------------- NAVIGATION METHODS --------------------
  void _openProfileScreen(BuildContext context) {
    context.push('/profile');
  }

  void _openNotificationPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildNotificationPanel(),
    );
  }

  Widget _buildNotificationPanel() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.dark800.withOpacity(0.95),
            AppColors.dark900.withOpacity(0.98),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyles.orbitron(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: AppColors.grey400),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildNotificationItem(
                  title: 'Level Up!',
                  subtitle: 'You reached Level 5!',
                  icon: Icons.emoji_events_rounded,
                  color: AppColors.neonCyan,
                ),
                _buildNotificationItem(
                  title: 'New Challenge Available',
                  subtitle: 'Quick Sort Challenge is live!',
                  icon: Icons.timer_rounded,
                  color: AppColors.neonPurple,
                ),
                _buildNotificationItem(
                  title: '+50 XP Earned',
                  subtitle: 'For completing Flutter Basics',
                  icon: Icons.star_rounded,
                  color: AppColors.neonPink,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dark700.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.inter(
                    fontSize: 14,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyles.inter(
                    fontSize: 12,
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedNeonText extends StatefulWidget {
  final String text;
  final double fontSize;

  const AnimatedNeonText({super.key, required this.text, this.fontSize = 24});

  @override
  _AnimatedNeonTextState createState() => _AnimatedNeonTextState();
}

class _AnimatedNeonTextState extends State<AnimatedNeonText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // change to 6s for slower sweep
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        TextStyles.orbitron(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white, // color still required for ShaderMask
        ).copyWith(
          // add soft glow shadows here via copyWith
          shadows: [
            Shadow(blurRadius: 18, color: AppColors.neonBlue.withOpacity(0.65)),
            Shadow(
              blurRadius: 36,
              color: AppColors.neonPurple.withOpacity(0.5),
            ),
          ],
        );

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final start = -1 + _controller.value * 2;
        final end = 1 + _controller.value * 2;

        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(start, 0),
              end: Alignment(end, 0),
              colors: [
                AppColors.neonPurple,
                AppColors.neonBlue,
                AppColors.neonCyan,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Text(widget.text, style: baseStyle),
        );
      },
    );
  }
}
