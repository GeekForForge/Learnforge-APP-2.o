import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_morphic_card.dart';

class StreakHeatmap extends StatelessWidget {
  const StreakHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for last 14 days (2 rows of 7)
    final activity = [
      true, true, false, true, true, true, false,
      true, true, true, true, false, true, true,
    ];

    return GlassMorphicCard(
      glowColor: AppColors.neonCyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ACTIVITY LOG',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.neonCyan,
              fontFamily: 'Orbitron',
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 14,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final isActive = activity[index];
              return Container(
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.neonCyan.withValues(alpha: 0.8)
                      : AppColors.dark700,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.neonCyan.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              ).animate().scale(delay: (index * 50).ms, duration: 300.ms);
            },
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '12 Day Streak',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
