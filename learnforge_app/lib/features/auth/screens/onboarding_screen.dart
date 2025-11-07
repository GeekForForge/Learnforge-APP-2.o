import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/glass_morphic_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark900, // Fixed: darkBg → dark900
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              children: [
                _OnboardingPage(
                  title: 'Welcome to LearnForge',
                  description:
                      'Your personal learning companion designed to help you master new skills',
                  icon: '📚',
                ),
                _OnboardingPage(
                  title: 'Track Your Progress',
                  description:
                      'Monitor your learning journey with streaks, XP, and achievements',
                  icon: '📊',
                ),
                _OnboardingPage(
                  title: 'Join the Arena',
                  description:
                      'Compete with peers in coding challenges and climb the leaderboard',
                  icon: '⚔️',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors
                                  .neonPurple // Fixed: primary → neonPurple
                            : AppColors.grey400.withOpacity(
                                0.3,
                              ), // Fixed: textMuted → grey400
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Button
                GradientButton(
                  text: _currentPage == 2
                      ? 'Get Started'
                      : 'Next', // Fixed: label → text
                  onPressed: () {
                    if (_currentPage == 2) {
                      context.go('/login');
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// Enhanced version with glass morphism and neon effects
class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final Color glowColor;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    this.glowColor = AppColors.neonPurple,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GlassMorphicCard(
          glowColor: glowColor,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: glowColor.withOpacity(0.1),
                  border: Border.all(color: glowColor.withOpacity(0.3)),
                ),
                child: Text(icon, style: const TextStyle(fontSize: 60))
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.elasticOut)
                    .fadeIn(),
              ),
              const SizedBox(height: 32),
              Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .slideY(duration: 500.ms, curve: Curves.easeOut)
                  .fadeIn(),
              const SizedBox(height: 16),
              Text(
                    description,
                    style: TextStyle(fontSize: 16, color: AppColors.grey400),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .slideY(duration: 600.ms, curve: Curves.easeOut)
                  .fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}
