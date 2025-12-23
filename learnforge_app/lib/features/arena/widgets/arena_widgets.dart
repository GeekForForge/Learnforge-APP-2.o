import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';

class ArenaStatusStrip extends StatelessWidget {
  final int activeChallengers;

  const ArenaStatusStrip({super.key, required this.activeChallengers});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.dark900.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: AppColors.neonPurple.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.neonGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGreen,
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(duration: 1.seconds, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2)),
              const SizedBox(width: 8),
              Text(
                'ARENA ONLINE',
                style: TextStyles.orbitron(
                  fontSize: 12,
                  color: AppColors.neonGreen,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          Text(
            '$activeChallengers ACTIVE CHALLENGERS',
            style: TextStyles.inter(
              fontSize: 10,
              color: AppColors.grey400,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerReadinessPanel extends StatelessWidget {
  const PlayerReadinessPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassMorphicCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      glowColor: AppColors.neonPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('ENERGY', '100%', AppColors.neonBlue),
          Container(width: 1, height: 24, color: AppColors.grey600),
          _buildStatItem('STREAK', '12x', AppColors.neonPink),
          Container(width: 1, height: 24, color: AppColors.grey600),
          _buildStatItem('ACCURACY', '94%', AppColors.neonGreen),
          Container(width: 1, height: 24, color: AppColors.grey600),
          _buildStatItem('RANK', '#42', AppColors.neonCyan),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyles.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.grey400,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class BattleModeSelector extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String> onModeChanged;

  const BattleModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dark800,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey600.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildModeButton(
            context,
            mode: 'solo',
            title: 'SOLO',
            subtitle: 'Stand alone. Rise by skill.',
            icon: Icons.person,
            activeColor: AppColors.neonCyan,
          ),
          _buildModeButton(
            context,
            mode: 'collab',
            title: 'COLLAB',
            subtitle: 'Forge minds. Win together.',
            icon: Icons.group,
            activeColor: AppColors.neonPink,
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context, {
    required String mode,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color activeColor,
  }) {
    final isSelected = selectedMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => onModeChanged(mode),
        child: AnimatedContainer(
          duration: 300.ms,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: activeColor.withValues(alpha: 0.5)) : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? activeColor : AppColors.grey400,
                size: 20,
              ).animate(target: isSelected ? 1 : 0).scale(duration: 300.ms),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyles.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? activeColor : AppColors.grey400,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  color: isSelected ? AppColors.white.withValues(alpha: 0.8) : AppColors.grey600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
