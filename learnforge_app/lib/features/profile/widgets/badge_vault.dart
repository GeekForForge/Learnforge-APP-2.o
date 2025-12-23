import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_morphic_card.dart';

class BadgeVault extends StatelessWidget {
  const BadgeVault({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock badges
    final badges = [
      {'icon': '🚀', 'locked': false},
      {'icon': '🔥', 'locked': false},
      {'icon': '⚔️', 'locked': false},
      {'icon': '💎', 'locked': true},
      {'icon': '👑', 'locked': true},
      {'icon': '🛡️', 'locked': true},
      {'icon': '⚡', 'locked': true},
      {'icon': '🌪️', 'locked': true},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BADGE VAULT',
          style: TextStyle(
             fontSize: 18,
             fontWeight: FontWeight.bold,
             color: AppColors.white,
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
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];
            final isLocked = badge['locked'] as bool;
            final icon = badge['icon'] as String;

            return GlassMorphicCard(
              glowColor: isLocked ? Colors.transparent : AppColors.neonBlue,
              padding: EdgeInsets.zero,
              child: Stack(
                alignment: Alignment.center,
                children: [
                   Center(
                      child: Text(
                        icon,
                        style: TextStyle(
                          fontSize: 32,
                          color: isLocked ? Colors.white.withValues(alpha: 0.2) : null,
                        ),
                      ),
                   ),
                   if (isLocked)
                     Positioned.fill(
                       child: Container(
                         color: Colors.black.withValues(alpha: 0.3),
                         child: const Icon(
                           Icons.lock,
                           color: AppColors.grey600,
                           size: 16,
                         ),
                       ),
                     ),
                ],
              ),
            ).animate().slideY(
              delay: (index * 50).ms,
              curve: Curves.easeOut,
            );
          },
        ),
      ],
    );
  }
}
