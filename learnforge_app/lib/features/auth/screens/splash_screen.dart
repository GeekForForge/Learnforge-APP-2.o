import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark900,
      body: Stack(
        children: [
          // Enhanced animated gradient background
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2.0,
                colors: [
                  AppColors.neonPurple.withOpacity(0.15),
                  AppColors.neonCyan.withOpacity(0.1),
                  AppColors.neonPink.withOpacity(0.05),
                  AppColors.dark900,
                ],
                stops: const [0.1, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // Animated gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.neonPurple.withOpacity(0.05),
                  Colors.transparent,
                  AppColors.neonCyan.withOpacity(0.05),
                ],
              ),
            ),
          ),

          // Enhanced particle background - FIXED to cover entire screen
          _EnhancedParticleBackground(),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Enhanced Logo with pulse animation and fixed black circle issue
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow
                    Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.neonPurple.withOpacity(0.3),
                                AppColors.neonCyan.withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonPurple.withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                              BoxShadow(
                                color: AppColors.neonCyan.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .scale(
                          duration: 2000.ms,
                          curve: Curves.easeInOut,
                          begin: const Offset(1.0, 1.0),
                          end: const Offset(1.2, 1.2),
                        ),

                    // Logo container with proper background
                    Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.dark800,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/icon.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.neonPurple,
                                        AppColors.neonCyan,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.school,
                                    size: 50,
                                    color: AppColors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                        .animate()
                        .scale(
                          duration: 800.ms,
                          curve: Curves.elasticOut,
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1.0, 1.0),
                        )
                        .fadeIn(duration: 600.ms)
                        .then()
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(
                          duration: 2000.ms,
                          color: AppColors.neonPurple.withOpacity(0.2),
                        ),
                  ],
                ),

                const SizedBox(height: 32),

                // Enhanced App name with better text effects
                Stack(
                      children: [
                        // Text glow behind
                        Text(
                          'LearnForge',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Orbitron',
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = AppColors.neonPurple.withOpacity(0.5),
                          ),
                        ),
                        // Main text
                        Text(
                          'LearnForge',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Orbitron',
                            color: AppColors.white,
                            shadows: [
                              Shadow(
                                color: AppColors.neonPurple.withOpacity(0.8),
                                blurRadius: 15,
                                offset: const Offset(0, 0),
                              ),
                              Shadow(
                                color: AppColors.neonCyan.withOpacity(0.6),
                                blurRadius: 25,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    .animate()
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 700.ms,
                      curve: Curves.easeOut,
                    )
                    .fadeIn(duration: 700.ms),

                const SizedBox(height: 12),

                // Enhanced tagline with animated gradient
                ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          AppColors.neonCyan,
                          AppColors.neonPurple,
                          AppColors.neonPink,
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: Text(
                        'Learn. Compete. Grow.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          color: Colors.white,
                        ),
                      ),
                    )
                    .animate()
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 800.ms,
                      curve: Curves.easeOut,
                    )
                    .fadeIn(duration: 800.ms),

                const SizedBox(height: 40),

                // Enhanced loading indicator with moving gradient
                Container(
                  width: 120,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.dark700,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dark900.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Animated gradient bar
                      Container(
                            width: 120,
                            height: 6,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.neonPurple,
                                  AppColors.neonCyan,
                                  AppColors.neonPurple,
                                ],
                                stops: [0.0, 0.5, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(
                            duration: 1500.ms,
                            angle: 0.5,
                            color: AppColors.neonCyan.withOpacity(0.5),
                          ),
                    ],
                  ),
                ).animate().fadeIn(delay: 1000.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced particle background - FIXED VERSION
class _EnhancedParticleBackground extends StatelessWidget {
  final List<Color> particleColors = [
    AppColors.neonPurple,
    AppColors.neonCyan,
    AppColors.neonPink,
    AppColors.neonBlue,
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return IgnorePointer(
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          children: List.generate(
            25, // Increased number of particles for better coverage
            (index) => Positioned(
              left: _getParticlePosition(screenSize.width, index, true),
              top: _getParticlePosition(screenSize.height, index, false),
              child: _AnimatedParticle(index: index),
            ),
          ),
        ),
      ),
    );
  }

  double _getParticlePosition(double max, int index, bool isWidth) {
    // Create a more distributed pattern using mathematical distribution
    final basePosition = (index / 25) * max;

    // Add some randomness but ensure coverage
    final randomOffset =
        (index * 37) % (max * 0.3); // Prime number for better distribution

    if (isWidth) {
      return (basePosition + randomOffset) % max;
    } else {
      // For height, use a different pattern to avoid diagonal lines
      final heightPattern = (index * 23) % max; // Different prime number
      return (basePosition + heightPattern) % max;
    }
  }
}

class _AnimatedParticle extends StatelessWidget {
  final int index;
  final List<Color> colors = [
    AppColors.neonPurple,
    AppColors.neonCyan,
    AppColors.neonPink,
    AppColors.neonBlue,
  ];

  _AnimatedParticle({required this.index});

  @override
  Widget build(BuildContext context) {
    final color = colors[index % colors.length];
    final size = 1.5 + (index % 4).toDouble(); // More size variation

    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withOpacity(0.6),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fade(
          duration: (1800 + index * 200).ms,
          curve: Curves.easeInOut,
          begin: 0.3,
          end: 0.9,
        )
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(2.0, 2.0),
          duration: (2200 + index * 300).ms,
          curve: Curves.easeInOut,
        )
        .move(
          duration: (3500 + index * 400).ms,
          curve: Curves.easeInOut,
          begin: const Offset(0, 0),
          end: Offset(
            (index.isEven ? 1 : -1) * 50.0, // Increased movement range
            (index % 3 == 0 ? 1 : -1) * 40.0, // Increased movement range
          ),
        );
  }
}
