import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_morphic_card.dart';

class DailyMissionCard extends StatelessWidget {
  const DailyMissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassMorphicCard(
      glowColor: AppColors.neonYellow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.track_changes, color: AppColors.neonYellow),
                  const SizedBox(width: 8),
                  Text(
                    "TODAY'S MISSION",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonYellow,
                      fontFamily: 'Orbitron',
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.dark800,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.grey600),
                ),
                child: const Text(
                  '04:23:12', // Mock Timer
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.white,
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Complete 3 Coding Challenges',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 12),
          // Progress Bar
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.dark700,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 8,
                width: 200, // Mock progress
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.neonYellow, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonYellow.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '2/3 Completed',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey400,
              ),
            ),
          ),
        ],
      ),
    ).animate().shimmer(duration: 2.seconds, delay: 1.seconds);
  }
}
