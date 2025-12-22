import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:learnforge_app/features/arena/widgets/leaderboard_entry.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../providers/arena_provider.dart';
import '../widgets/challenge_card.dart';

class ArenaScreen extends ConsumerWidget {
  const ArenaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    final challengesAsync = ref.watch(challengesProvider);
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: AppColors.dark900, // Fixed: darkBg → dark900
      appBar: AppBar(
        title: const Text('Arena'),
        backgroundColor: AppColors.dark800, // Fixed: darkBgSecondary → dark800
        elevation: 0,
      ),
      body: challengesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (challenges) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tabs
                GlassMorphicCard(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: ['live', 'upcoming', 'completed'].map((tab) {
                      final isSelected = selectedTab == tab;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ref.read(selectedTabProvider.notifier).state = tab;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors
                                        .neonPurple // Fixed: primary → neonPurple
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              tab.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors
                                          .grey400, // Fixed: textMuted → grey400
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ).animate().slideY(duration: 400.ms, curve: Curves.easeOut),
                // Start Practice Banner
                GlassMorphicCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.neonBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flash_on, color: AppColors.neonBlue, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Practice Arena',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Test your skills with random MCQs',
                              style: TextStyle(color: AppColors.grey400, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Start Quiz Logic
                          ref.read(arenaProvider.notifier).startQuiz(topic: 'Java'); // Default for now
                          context.push('/arena/quiz');
                        },
                        icon: const Icon(Icons.arrow_forward_ios, color: AppColors.neonBlue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tabs

                // Challenges
                ...challenges
                    .where((c) => c.status == selectedTab)
                    .toList()
                    .asMap()
                    .entries
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ChallengeCard(challenge: entry.value)
                            .animate()
                            .slideY(
                              duration: (300 + entry.key * 100).ms,
                              curve: Curves.easeOut,
                            ),
                      ),
                    ),

                const SizedBox(height: 24),

                // Leaderboard Title
                Text(
                  'Live Leaderboard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white, // Fixed: textLight → white
                  ),
                ),
                const SizedBox(height: 12),

                // Leaderboard
                leaderboardAsync.when(
                  loading: () => const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => Text('Error: $err'),
                  data: (leaderboard) => LeaderboardList(entries: leaderboard),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
