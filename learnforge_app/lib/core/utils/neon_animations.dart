import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      color: glowColor?.withOpacity(0.3) ?? Colors.white.withOpacity(0.3),
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
