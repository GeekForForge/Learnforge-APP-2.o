import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class GlassMorphicCard extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const GlassMorphicCard({
    super.key,
    required this.child,
    this.glowColor = AppColors.neonPurple,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [FadeEffect(), ScaleEffect()],
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.dark700.withValues(alpha: 0.8),
              AppColors.dark800.withValues(alpha: 0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: glowColor.withValues(alpha: 0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
