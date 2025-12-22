import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';

class WelcomeHeader extends StatelessWidget {
  final String userName;
  final int streakDays;

  const WelcomeHeader({
    super.key,
    this.userName = 'Learner',
    this.streakDays = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyles.inter(
                  fontSize: 14,
                  color: AppColors.grey400, // Fixed: textMuted → grey400
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 4),
              Text(
                userName,
                style: TextStyles.orbitron(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white, // Fixed: textLight → white
                ),
              ).animate().slideX(
                begin: -0.3,
                end: 0,
                duration: 500.ms,
                curve: Curves.easeOut,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.neonPurple, AppColors.neonPink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.neonPurple.withValues(
                  alpha: 0.5,
                ), // Fixed: accent → neonPurple
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonPurple.withValues(
                    alpha: 0.3,
                  ), // Fixed: accent → neonPurple
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  '$streakDays days',
                  style: TextStyles.orbitron(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors
                        .white, // Fixed: accent → white for better contrast
                  ),
                ),
              ],
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }
}
