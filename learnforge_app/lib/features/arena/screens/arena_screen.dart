import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../../../core/widgets/particle_background.dart';
import '../providers/arena_provider.dart';
import '../widgets/arena_widgets.dart';
import '../widgets/battle_challenge_card.dart';

class ArenaScreen extends ConsumerWidget {
  const ArenaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    final selectedMode = ref.watch(arenaModeProvider);
    final challengesAsync = ref.watch(challengesProvider);

    return ParticleBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent, // Background handled by ParticleBackground
        appBar: AppBar(
          title: Text(
            'ARENA',
            style: TextStyles.orbitron(
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: AppColors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.dark900.withValues(alpha: 0.8),
          elevation: 0,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: ArenaStatusStrip(activeChallengers: 1243),
          ),
        ),
        body: challengesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.neonPurple)),
          error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.danger))),
          data: (challenges) {
            // Filter challenges by Tab AND Mode
            final filteredChallenges = challenges.where((c) {
              final matchesTab = c.status == selectedTab;
              final matchesMode = c.mode == selectedMode;
              return matchesTab && matchesMode;
            }).toList();

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // 1. Tab Switcher
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.dark800,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey600.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: ['live', 'upcoming', 'completed'].map((tab) {
                        final isSelected = selectedTab == tab;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ref.read(selectedTabProvider.notifier).state = tab;
                            },
                            child: AnimatedContainer(
                              duration: 200.ms,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.neonPurple.withValues(alpha: 0.2) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: isSelected ? Border.all(color: AppColors.neonPurple.withValues(alpha: 0.5)) : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.neonPurple.withValues(alpha: 0.2),
                                          blurRadius: 8,
                                        )
                                      ]
                                    : null,
                              ),
                              child: Text(
                                tab.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? AppColors.white : AppColors.grey400,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Battle Mode Selector
                  BattleModeSelector(
                    selectedMode: selectedMode,
                    onModeChanged: (mode) {
                      ref.read(arenaModeProvider.notifier).state = mode;
                    },
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 24),

                  // 3. Readiness Panel
                  const PlayerReadinessPanel()
                      .animate()
                      .fade(duration: 500.ms)
                      .slideY(begin: -0.2, end: 0, duration: 500.ms),
                  const SizedBox(height: 24),

                  // 4. Practice Arena Banner (Only in Solo Mode & Live Tab)
                  if (selectedTab == 'live' && selectedMode == 'solo') ...[
                    GestureDetector(
                      onTap: () => context.push('/arena/practice'),
                      child: GlassMorphicCard(
                        padding: const EdgeInsets.all(20),
                        glowColor: AppColors.neonBlue,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.neonBlue.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.neonBlue.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: const Icon(Icons.flash_on, color: AppColors.neonBlue, size: 32)
                                  .animate(onPlay: (c) => c.repeat(reverse: true))
                                  .fadeIn(duration: 1.seconds),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'PRACTICE ARENA',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                      fontFamily: 'Orbitron',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      _buildDiffChip('Easy', AppColors.success),
                                      const SizedBox(width: 6),
                                      _buildDiffChip('Med', AppColors.warning),
                                      const SizedBox(width: 6),
                                      _buildDiffChip('Hard', AppColors.danger),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => context.push('/arena/practice'),
                              icon: const Icon(Icons.arrow_forward_ios, color: AppColors.neonBlue),
                            ),
                          ],
                        ),
                      ),
                    ).animate().scale(duration: 400.ms, curve: Curves.easeOut),
                    const SizedBox(height: 24),
                  ],

                  // 5. Challenge List
                  ...filteredChallenges
                      .asMap()
                      .entries
                      .map(
                        (entry) => BattleChallengeCard(
                          challenge: entry.value,
                          isLive: selectedTab == 'live',
                          isUpcoming: selectedTab == 'upcoming',
                          onTap: () {
                            if (selectedTab == 'live') {
                              // Join logic
                            }
                          },
                        )
                            .animate()
                            .slideY(
                              duration: (300 + entry.key * 100).ms,
                              curve: Curves.easeOut,
                            ),
                      ),

                  if (filteredChallenges.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Icon(
                              selectedMode == 'collab' ? Icons.group_off : Icons.wifi_off,
                              size: 48,
                              color: AppColors.grey600,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'NO ${selectedMode.toUpperCase()} BATTLES FOUND',
                              style: TextStyle(
                                color: AppColors.grey400.withValues(alpha: 0.5),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDiffChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Add state provider for Arena Mode
final arenaModeProvider = StateProvider<String>((ref) => 'solo');

