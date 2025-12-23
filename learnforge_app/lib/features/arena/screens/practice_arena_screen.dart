import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../../../core/widgets/particle_background.dart';
import '../providers/arena_provider.dart';

class PracticeArenaScreen extends ConsumerStatefulWidget {
  const PracticeArenaScreen({super.key});

  @override
  ConsumerState<PracticeArenaScreen> createState() => _PracticeArenaScreenState();
}

class _PracticeArenaScreenState extends ConsumerState<PracticeArenaScreen> {
  String _selectedMode = 'solo'; // 'solo', 'squad'
  String _selectedDifficulty = 'Medium';
  String _selectedTopic = 'Arrays';
  double _questionCount = 10;
  bool _isFocusMode = false;

  final List<String> _topics = ['Arrays', 'Linked List', 'Stack', 'Queue', 'Trees', 'Graphs', 'DP'];
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard', 'Adaptive'];

  @override
  Widget build(BuildContext context) {
    final primaryColor = _selectedMode == 'solo' ? AppColors.neonCyan : AppColors.neonPurple;

    return ParticleBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                'PRACTICE ARENA',
                style: TextStyles.orbitron(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Train. Analyze. Improve.',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.grey400,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: AppColors.dark900.withValues(alpha: 0.8),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Practice Mode Selector
              _buildModeSelector(primaryColor),
              const SizedBox(height: 24),

              // 2. Training Configuration Panel
              GlassMorphicCard(
                glowColor: primaryColor,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TRAINING CONFIGURATION',
                          style: TextStyles.orbitron(
                            fontSize: 14,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.tune, color: primaryColor, size: 20),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Difficulty
                    _buildSectionLabel('DIFFICULTY'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _difficulties.map((diff) {
                        final isSelected = _selectedDifficulty == diff;
                        return ChoiceChip(
                          label: Text(diff),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedDifficulty = diff);
                          },
                          checkmarkColor: AppColors.white,
                          backgroundColor: AppColors.dark800,
                          selectedColor: primaryColor.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? primaryColor : AppColors.grey400,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isSelected ? primaryColor : AppColors.grey600.withValues(alpha: 0.3),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Topics
                    _buildSectionLabel('TOPIC'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _topics.map((topic) {
                        final isSelected = _selectedTopic == topic;
                        return ChoiceChip(
                          label: Text(topic),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedTopic = topic);
                          },
                          checkmarkColor: AppColors.white,
                          backgroundColor: AppColors.dark800,
                          selectedColor: primaryColor.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? primaryColor : AppColors.grey400,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isSelected ? primaryColor : AppColors.grey600.withValues(alpha: 0.3),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Question Count
                    _buildSectionLabel('QUESTION COUNT: ${_questionCount.round()}'),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: primaryColor,
                        inactiveTrackColor: AppColors.dark700,
                        thumbColor: AppColors.white,
                        overlayColor: primaryColor.withValues(alpha: 0.2),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: _questionCount,
                        min: 5,
                        max: 20,
                        divisions: 3,
                        label: _questionCount.round().toString(),
                        onChanged: (val) => setState(() => _questionCount = val),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Focus Mode Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('FOCUS MODE', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Hide timer and hints', style: TextStyle(color: AppColors.grey400, fontSize: 10)),
                          ],
                        ),
                        Switch(
                          value: _isFocusMode,
                          onChanged: (val) => setState(() => _isFocusMode = val),
                          activeColor: primaryColor,
                          activeTrackColor: primaryColor.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 24),

              // 3. Squad Panel (Conditional)
              if (_selectedMode == 'squad')
                GlassMorphicCard(
                  glowColor: AppColors.neonPurple,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('SQUAD LOBBY', style: TextStyle(color: AppColors.neonPurple, fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.neonPurple.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('WAITING...', style: TextStyle(color: AppColors.white, fontSize: 10)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildAvatar('You', true, AppColors.neonPurple),
                          const SizedBox(width: 12),
                          _buildAvatar('Shadow', false, AppColors.grey600),
                          const SizedBox(width: 12),
                          _buildAddButton(),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),

              if (_selectedMode == 'squad') const SizedBox(height: 24),

              // 4. Session Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.dark800.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey600.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPreviewItem('Est. Duration', '${(_questionCount * 1.5).round()} min', Icons.timer),
                    _buildPreviewItem('XP Potential', '${(_questionCount * 10).round()} XP', Icons.bolt),
                    if (_isFocusMode) _buildPreviewItem('Bonus', '+20%', Icons.verified),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 32),

              // 5. Start Button
              GestureDetector(
                onTap: () {
                  // Initialize quiz with config
                  ref.read(arenaProvider.notifier).startQuiz(
                    topic: _selectedTopic,
                    difficulty: _selectedDifficulty,
                  );
                  context.push('/arena/quiz');
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withValues(alpha: 0.6)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow, color: AppColors.dark900),
                      const SizedBox(width: 8),
                      Text(
                        'START SIMULATION',
                        style: TextStyles.orbitron(
                          color: AppColors.dark900,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOut),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.dark800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey600.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          _buildModeButton('solo', 'SOLO PRACTICE', Icons.person, AppColors.neonCyan),
          _buildModeButton('squad', 'SQUAD PRACTICE', Icons.group, AppColors.neonPurple),
        ],
      ),
    );
  }

  Widget _buildModeButton(String mode, String title, IconData icon, Color color) {
    final isSelected = _selectedMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMode = mode),
        child: AnimatedContainer(
          duration: 300.ms,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: color.withValues(alpha: 0.5)) : null,
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? color : AppColors.grey400, size: 20),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? color : AppColors.grey400,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.grey400,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildAvatar(String name, bool isReady, Color borderColor) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
            image: const DecorationImage(
              image: NetworkImage('https://via.placeholder.com/150'), // Replace with asset
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(color: AppColors.white, fontSize: 10)),
      ],
    );
  }

  Widget _buildAddButton() {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.grey600, width: 1, style: BorderStyle.solid),
          ),
          child: const Icon(Icons.add, color: AppColors.grey400),
        ),
        const SizedBox(height: 4),
        const Text('Invite', style: TextStyle(color: AppColors.grey400, fontSize: 10)),
      ],
    );
  }

  Widget _buildPreviewItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.grey400, size: 16),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: AppColors.grey600, fontSize: 10)),
      ],
    );
  }
}
