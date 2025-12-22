import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';

class NeonParticleBackground extends StatelessWidget {
  const NeonParticleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Example: multiple glowing circles floating with neon colors
        Positioned(
          top: 100,
          left: 50,
          child: _glowingCircle(AppColors.neonPurple),
        ),
        Positioned(
          top: 200,
          right: 60,
          child: _glowingCircle(AppColors.neonCyan),
        ),
        Positioned(
          bottom: 120,
          left: 80,
          child: _glowingCircle(AppColors.neonPink),
        ),
        Positioned(
          bottom: 200,
          right: 100,
          child: _glowingCircle(AppColors.neonBlue),
        ),
        // Add more glowing circles or shapes here with different positions and sizes
      ],
    );
  }

  Widget _glowingCircle(Color color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.4),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.7),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
    ).glowPulse(glowColor: color);
  }
}

extension NeonAnimations on Widget {
  // Floating animation
  Widget float({Duration? duration}) {
    return animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: duration ?? 3000.ms)
        .scale(
          begin: Offset(1, 1),
          end: Offset(1.02, 1.02),
          duration: duration ?? 3000.ms,
          curve: Curves.easeInOut,
        );
  }

  // Glow pulse animation
  Widget glowPulse({Color? glowColor, Duration? duration}) {
    return animate(onPlay: (controller) => controller.repeat()).shimmer(
      duration: duration ?? 2000.ms,
      color: glowColor?.withValues(alpha: 0.3) ?? Colors.white.withValues(alpha: 0.3),
    );
  }

  // Slide in with fade
  Widget slideInFade({Duration? delay}) {
    return animate(delay: delay ?? 0.ms)
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOut);
  }

  // Bounce in animation
  Widget bounceIn({Duration? delay}) {
    return animate(delay: delay ?? 0.ms)
        .scale(
          begin: Offset(0.8, 0.8),
          end: Offset(1, 1),
          duration: 600.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 600.ms);
  }
}
