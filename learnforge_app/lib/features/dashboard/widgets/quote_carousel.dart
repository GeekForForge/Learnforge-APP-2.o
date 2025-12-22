import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async'; // Don't forget this import for Timer
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';

class QuoteCarousel extends StatefulWidget {
  final List<String> quotes;

  const QuoteCarousel({super.key, this.quotes = const []});

  @override
  State<QuoteCarousel> createState() => _QuoteCarouselState();
}

class _QuoteCarouselState extends State<QuoteCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && widget.quotes.isNotEmpty) {
        final nextIndex = (_currentIndex + 1) % widget.quotes.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultQuotes = [
      '"The only way to learn programming is by writing code."',
      '"Success is the sum of small efforts repeated day in and day out."',
      '"The expert in anything was once a beginner."',
    ];

    final quotes = widget.quotes.isNotEmpty ? widget.quotes : defaultQuotes;

    return GlassMorphicCard(
      glowColor: AppColors.neonCyan,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    quotes[index],
                    style: TextStyles.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ).copyWith(fontStyle: FontStyle.italic), // Using copyWith
                    textAlign: TextAlign.center,
                  ),
                ).animate().fadeIn(duration: 300.ms);
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              quotes.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: _currentIndex == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppColors.neonCyan
                      : AppColors.grey400.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: _currentIndex == index
                      ? [
                          BoxShadow(
                            color: AppColors.neonCyan.withValues(alpha: 0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ).animate().scale(duration: 300.ms),
            ),
          ),
        ],
      ),
    );
  }
}
