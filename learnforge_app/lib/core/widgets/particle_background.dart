import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_colors.dart';

class ParticleBackground extends StatefulWidget {
  /// Number of moving particles in the background.
  final int particleCount;

  /// Optional child widget rendered above the particles.
  final Widget? child;

  const ParticleBackground({Key? key, this.particleCount = 20, this.child})
    : super(key: key);

  @override
  _ParticleBackgroundState createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 250),
    )..repeat();

    // Initialize particles with random neon colors
    for (int i = 0; i < widget.particleCount; i++) {
      particles.add(Particle());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            _updateParticles();
            return CustomPaint(
              painter: ParticlePainter(particles),
              size: Size.infinite,
            );
          },
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }

  void _updateParticles() {
    for (var particle in particles) {
      particle.update();
    }
  }
}

class Particle {
  double x = Random().nextDouble() * 100;
  double y = Random().nextDouble() * 100;
  double vx = Random().nextDouble() * 0.2 - 0.1;  // Slower movement
  double vy = Random().nextDouble() * 0.2 - 0.1;  // Slower movement
  double radius = Random().nextDouble() * 2 + 1;
  Color color = _getRandomNeonColor();
  double opacity = Random().nextDouble() * 0.5 + 0.3;

  static Color _getRandomNeonColor() {
    final colors = [
      AppColors.neonPurple,
      AppColors.neonCyan,
      AppColors.neonPink,
      AppColors.neonBlue,
    ];
    return colors[Random().nextInt(colors.length)];
  }

  void update() {
    x += vx;
    y += vy;

    // Wrap around edges
    if (x < 0) x = 100;
    if (x > 100) x = 0;
    if (y < 0) y = 100;
    if (y > 100) y = 0;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      paint.color = particle.color.withOpacity(particle.opacity);

      // Draw main particle
      canvas.drawCircle(
        Offset(particle.x * size.width / 100, particle.y * size.height / 100),
        particle.radius,
        paint,
      );

      // Glow effect
      paint.color = particle.color.withOpacity(particle.opacity * 0.3);
      canvas.drawCircle(
        Offset(particle.x * size.width / 100, particle.y * size.height / 100),
        particle.radius * 3,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
