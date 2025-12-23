import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:learnforge_app/features/auth/providers/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/widgets/particle_background.dart';
import '../widgets/avatar_picker_modal.dart';
import '../../arena/providers/arena_provider.dart';
import '../../arena/widgets/leaderboard_entry.dart';
import '../widgets/daily_mission_card.dart';
import '../widgets/streak_heatmap.dart';
import '../widgets/badge_vault.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final leaderboardAsync = ref.watch(leaderboardProvider);

    if (authState is Initial) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Not logged in')),
      );
    } else if (authState is Loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    } else if (authState is Authenticated) {
      final user = (authState).user;
      return Scaffold(
        backgroundColor: AppColors.dark900,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: AppColors.dark800,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              // Add Particle effect for "more nice" look
              const Positioned.fill(
                child: ParticleBackground(particleCount: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  // Cyberpunk Profile Header
                  const SizedBox(height: 30),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // XP Ring Glow
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonPurple.withValues(alpha: 0.4),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        // XP Progress Ring
                        SizedBox(
                          width: 135,
                          height: 135,
                          child: CircularProgressIndicator(
                            value: 0.75, // Mock progress for now (75% to next level)
                            strokeWidth: 6,
                            backgroundColor: AppColors.dark700,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
                          ),
                        ),
                        // Avatar
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: user.avatar.startsWith('assets/')
                                ? Image.asset(
                                    user.avatar,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: AppColors.dark700,
                                    child: Center(
                                      child: Text(
                                        user.avatar,
                                        style: const TextStyle(fontSize: 50),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        // Level Badge
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.neonPurple, AppColors.neonBlue],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.white, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neonBlue.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Text(
                              'LVL 12',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                fontFamily: 'Orbitron',
                              ),
                            ),
                          ),
                        ),
                        // Edit Badge
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () => _showAvatarPicker(context, ref, user.avatar),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.dark900,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.neonCyan, width: 1.5),
                              ),
                              child: const Icon(Icons.edit, color: AppColors.neonCyan, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

                  const SizedBox(height: 20),

                  // Identity
                  Center(
                    child: Column(
                      children: [
                        Text(
                          user.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            fontFamily: 'Orbitron',
                            letterSpacing: 2.0,
                            shadows: [
                              Shadow(color: AppColors.neonPurple, blurRadius: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'NEURAL APPRENTICE', // Mock Rank Title
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neonCyan,
                            fontFamily: 'Orbitron',
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // XP Bar text
                        Text(
                          '750 / 1000 XP',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.grey400,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 30),

                  // Enhanced Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Streak',
                          value: '${user.streakDays}',
                          icon: '🔥',
                          color: AppColors.neonPink,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Total XP',
                          value: '${user.totalXP}',
                          icon: '⚡',
                          color: AppColors.neonCyan,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Badges',
                          value: '${user.badges.length}',
                          icon: '🏆',
                          color: AppColors.neonBlue,
                        ),
                      ),
                    ],
                  ).animate().slideY(begin: 0.2, end: 0, delay: 300.ms, curve: Curves.easeOut),

                  const SizedBox(height: 30),

                  // Today's Mission Card
                  const DailyMissionCard(),
                  const SizedBox(height: 24),

                  // Streak Heatmap
                  const StreakHeatmap(),
                  const SizedBox(height: 30),

                  // Badge Vault
                  const BadgeVault(),
                  const SizedBox(height: 30),
                  // CONTROL CENTER
                  const Text(
                    'CONTROL CENTER',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontFamily: 'Orbitron',
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassMorphicCard(
                    glowColor: AppColors.neonBlue,
                    child: Column(
                      children: [
                        _SettingsRow(
                          title: 'Dark Mode',
                          icon: Icons.dark_mode,
                          value: true,
                          onChanged: (value) {},
                          color: AppColors.neonPurple,
                        ),
                        Divider(
                          color: AppColors.grey600.withValues(alpha: 0.3),
                          height: 24,
                        ),
                        _SettingsRow(
                          title: 'Notifications',
                          icon: Icons.notifications,
                          value: true,
                          onChanged: (value) {},
                          color: AppColors.neonCyan,
                        ),
                        Divider(
                          color: AppColors.grey600.withValues(alpha: 0.3),
                          height: 24,
                        ),
                        _SettingsRow(
                          title: 'Sound Effects',
                          icon: Icons.volume_up,
                          value: true,
                          onChanged: (value) {},
                          color: AppColors.neonGreen,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // EXIT SIMULATION
                  Center(
                    child: GradientButton(
                      text: 'EXIT SIMULATION',
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                        context.go('/login');
                      },
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF4500), Color(0xFFFF8C00)], // Red -> Orange
                      ),
                      width: 200,
                      height: 45,
                      borderRadius: 30,
                      padding: EdgeInsets.zero,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Orbitron',
                        letterSpacing: 1.5,
                      ),
                    )
                        .animate(
                          onPlay: (controller) => controller.repeat(
                            reverse: true,
                            period: 2.seconds,
                          ),
                        )
                        .fadeIn(delay: 200.ms),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(height: 32),

                  // Global Leaderboard
                  const Text(
                    'Global Leaderboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontFamily: 'Orbitron',
                    ),
                  ),
                  const SizedBox(height: 12),
                  leaderboardAsync.when(
                    loading: () => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, stack) => Text(
                      'Error loading leaderboard',
                      style: TextStyle(color: AppColors.danger),
                    ),
                    data: (leaderboard) => LeaderboardList(entries: leaderboard),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (authState is Error) {
      final message = (authState).message;
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(child: Text('Error: $message')),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Unknown state')),
      );
    }
  }

  void _showAvatarPicker(BuildContext context, WidgetRef ref, String currentAvatar) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AvatarPickerModal(
        currentAvatar: currentAvatar,
        onAvatarSelected: (newAvatar) {
          ref.read(authProvider.notifier).updateAvatar(newAvatar);
        },
      ),
    );
  }
}


class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassMorphicCard(
      glowColor: color,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Text(icon, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              fontFamily: 'Orbitron',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;
  final Color color;

  const _SettingsRow({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: color,
        ),
      ],
    );
  }
}
