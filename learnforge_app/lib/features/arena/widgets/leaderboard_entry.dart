import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learnforge_app/features/arena/models/challenge_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_morphic_card.dart';

class LeaderboardList extends StatelessWidget {
  final List<LeaderboardEntryModel> entries;

  const LeaderboardList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Container(
          decoration: entry.isCurrentUser
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.neonPurple.withValues(alpha: 0.5),
                    width: 2,
                  ),
                )
              : null,
          child:
              GlassMorphicCard(
                child: Row(
                  children: [
                    // Rank Badge
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _getRankColors(entry.rank),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${entry.rank}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.userName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: entry.isCurrentUser
                                  ? AppColors.neonPurple
                                  : AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${(entry.timeSpentSeconds / 60).toStringAsFixed(1)} mins',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.grey400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Score
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neonCyan.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.neonCyan.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        '${entry.score} pts',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neonCyan,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(
                duration: (300 + index * 50).ms,
                curve: Curves.easeOut,
              ),
        );
      },
    );
  }

  List<Color> _getRankColors(int rank) {
    switch (rank) {
      case 1:
        return [const Color(0xFFFFD700), const Color(0xFFFFA500)];
      case 2:
        return [const Color(0xFFC0C0C0), const Color(0xFF808080)];
      case 3:
        return [const Color(0xFFCD7F32), const Color(0xFF8B4513)];
      default:
        return [AppColors.dark700, AppColors.dark600];
    }
  }
}
