import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../models/challenge_model.dart';

class BattleChallengeCard extends StatelessWidget {
  final ChallengeModel challenge;
  final bool isLive;
  final bool isUpcoming;
  final VoidCallback onTap;

  const BattleChallengeCard({
    super.key,
    required this.challenge,
    required this.onTap,
    this.isLive = false,
    this.isUpcoming = false,
  });

  @override
  Widget build(BuildContext context) {
    final isCollab = challenge.mode == 'collab';
    final primaryColor = isCollab ? AppColors.neonPink : AppColors.neonCyan;

    final glowColor = isLive
        ? AppColors.danger
        : isUpcoming
            ? primaryColor
            : AppColors.grey600;

    final borderColor = isLive ? AppColors.danger.withValues(alpha: 0.6) : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: GlassMorphicCard(
          glowColor: glowColor,
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Status Badge & Rewards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusBadge(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.dark900.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.bolt, size: 14, color: isCollab ? AppColors.neonPink : AppColors.neonCyan),
                          const SizedBox(width: 4),
                          Text(
                            '${challenge.points} XP',
                            style: TextStyle(
                              color: isCollab ? AppColors.neonPink : AppColors.neonCyan,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  challenge.title,
                  style: TextStyles.orbitron(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                // Difficulty & Participants
                Row(
                  children: [
                    _buildDifficultyMeter(),
                    const SizedBox(width: 12),
                    Text(
                      '•   ${challenge.participantCount} ${isCollab ? 'Squads' : 'Gladiators'}',
                      style: TextStyle(color: AppColors.grey400, fontSize: 12),
                    ),
                    if (isCollab) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.group, size: 12, color: AppColors.neonPink),
                      const Text(
                        ' 2-4 Players',
                        style: TextStyle(color: AppColors.neonPink, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 16),

                // Footer: Timers or Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFooterInfo(),
                    if (!isUpcoming)
                    const Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().scale(duration: 300.ms, curve: Curves.easeOut);
  }

  Widget _buildStatusBadge() {
    if (isLive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.danger.withValues(alpha: 0.5)),
        ),
        child: const Text('LIVE BATTLE', style: TextStyle(color: AppColors.danger, fontSize: 10, fontWeight: FontWeight.bold))
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 1.5.seconds, color: Colors.white.withValues(alpha: 0.5)),
      );
    } else if (isUpcoming) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: (challenge.mode == 'collab' ? AppColors.neonPink : AppColors.neonCyan).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: (challenge.mode == 'collab' ? AppColors.neonPink : AppColors.neonCyan).withValues(alpha: 0.5)),
        ),
        child: Text(
          'LOCKED',
          style: TextStyle(
            color: challenge.mode == 'collab' ? AppColors.neonPink : AppColors.neonCyan,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDifficultyMeter() {
    Color color;
    int bars;
    switch (challenge.difficulty.toLowerCase()) {
      case 'medium':
        color = AppColors.warning;
        bars = 2;
        break;
      case 'hard':
        color = AppColors.danger;
        bars = 3;
        break;
      default:
        color = AppColors.success;
        bars = 1;
    }

    return Row(
      children: List.generate(3, (index) {
        return Container(
          width: 6,
          height: 12,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: index < bars ? color : AppColors.dark700,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  Widget _buildFooterInfo() {
    if (isLive) {
      return const Text(
        'ENDING IN 02:45:12',
        style: TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
      );
    } else if (isUpcoming) {
      return Text(
        'STARTS IN 12h 30m',
        style: TextStyle(
          color: challenge.mode == 'collab' ? AppColors.neonPink : AppColors.neonCyan,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      );
    } else {
      return const Text(
        'COMPLETED',
        style: TextStyle(color: AppColors.grey400, fontSize: 12, fontWeight: FontWeight.bold),
      );
    }
  }
}
