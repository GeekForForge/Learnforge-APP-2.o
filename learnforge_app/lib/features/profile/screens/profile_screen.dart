import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:learnforge_app/features/auth/providers/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

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
      final user = (authState as Authenticated).user;
      return Scaffold(
        backgroundColor: AppColors.dark900, // Fixed: darkBg → dark900
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor:
              AppColors.dark800, // Fixed: darkBgSecondary → dark800
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              GlassMorphicCard(
                glowColor: AppColors.neonPurple,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.neonPurple.withOpacity(0.5),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonPurple.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.dark700,
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white, // Fixed: textLight → white
                        fontFamily: 'Orbitron',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey400, // Fixed: textMuted → grey400
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatColumn(
                          label: 'Streak',
                          value: '${user.streakDays}',
                          icon: '🔥',
                          color: AppColors.neonPink,
                        ),
                        _StatColumn(
                          label: 'XP',
                          value: '${user.totalXP}',
                          icon: '⚡',
                          color: AppColors.neonCyan,
                        ),
                        _StatColumn(
                          label: 'Badges',
                          value: '${user.badges.length}',
                          icon: '🏆',
                          color: AppColors.neonBlue,
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().slideY(duration: 400.ms, curve: Curves.easeOut),
              const SizedBox(height: 24),

              // Badges Section
              if (user.badges.isNotEmpty) ...[
                Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white, // Fixed: textLight → white
                    fontFamily: 'Orbitron',
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: user.badges.length,
                  itemBuilder: (context, index) {
                    return GlassMorphicCard(
                      glowColor: [
                        AppColors.neonPurple,
                        AppColors.neonCyan,
                        AppColors.neonPink,
                        AppColors.neonBlue,
                      ][index % 4],
                      child: Center(
                        child: Text(
                          user.badges[index],
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],

              // Settings
              Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white, // Fixed: textLight → white
                  fontFamily: 'Orbitron',
                ),
              ),
              const SizedBox(height: 12),
              _SettingsTile(
                title: 'Dark Mode',
                icon: Icons.dark_mode,
                value: true,
                onChanged: (value) {},
                color: AppColors.neonPurple,
              ),
              _SettingsTile(
                title: 'Notifications',
                icon: Icons.notifications,
                value: true,
                onChanged: (value) {},
                color: AppColors.neonCyan,
              ),
              const SizedBox(height: 24),

              // Logout
              GradientButton(
                    text: 'Logout',
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      // Note: Using Navigator might not work with go_router, adjust as needed
                      context.go('/login');
                    },
                    gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.deepOrange],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  )
                  .animate()
                  .slideY(
                    begin: 1,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(),
            ],
          ),
        ),
      );
    } else if (authState is Error) {
      final message = (authState as Error).message;
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(child: Text('Error: $message')),
      );
    } else {
      // Fallback: unknown state
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Unknown state')),
      );
    }
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(icon, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color, // Fixed: primary → dynamic color
            fontFamily: 'Orbitron',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.grey400, // Fixed: textMuted → grey400
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;
  final Color color;

  const _SettingsTile({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassMorphicCard(
      glowColor: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color), // Fixed: accent → dynamic color
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white, // Fixed: textLight → white
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color, // Fixed: primary → dynamic color
          ),
        ],
      ),
    );
  }
}
