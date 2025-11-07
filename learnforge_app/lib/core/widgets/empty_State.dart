import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import 'gradient_button.dart';
import 'glass_morphic_card.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;
  final Color glowColor;

  const EmptyState({
    Key? key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.onActionPressed,
    this.actionLabel,
    this.glowColor = AppColors.neonPurple,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassMorphicCard(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Custom icon with animation
            _buildCustomIcon(),

            const SizedBox(height: 24),

            // Title
            Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .slideY(duration: 400.ms, curve: Curves.easeOut)
                .fadeIn(),

            const SizedBox(height: 12),

            // Subtitle
            Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey400,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .slideY(duration: 500.ms, curve: Curves.easeOut)
                .fadeIn(),

            // Action button
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 24),
              GradientButton(
                    text: actionLabel!,
                    onPressed: onActionPressed!,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  )
                  .animate()
                  .slideY(duration: 600.ms, curve: Curves.easeOut)
                  .fadeIn(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCustomIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: glowColor.withOpacity(0.1),
        border: Border.all(color: glowColor.withOpacity(0.3), width: 2),
      ),
      child: Icon(icon ?? Icons.inbox_outlined, size: 50, color: glowColor),
    ).animate().scale(duration: 600.ms, curve: Curves.elasticOut).fadeIn();
  }
}
