import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../dashboard/providers/daily_goals_provider.dart';

class SetGoalScreen extends ConsumerStatefulWidget {
  const SetGoalScreen({super.key});

  @override
  ConsumerState<SetGoalScreen> createState() => _SetGoalScreenState();
}

class _SetGoalScreenState extends ConsumerState<SetGoalScreen> {
  // Mission State
  int _selectedWatchTime = 30;
  int _selectedQuestionCount = 10;
  bool _quizEnabled = false;
  bool _confirmed = false;

  final List<int> _watchTimeOptions = [15, 30, 45, 60];
  final List<int> _questionOptions = [5, 10, 15, 20];

  String _getDifficultyTag(int count) {
    switch (count) {
      case 5:
        return 'Easy';
      case 10:
        return 'Focused';
      case 15:
        return 'Intense';
      case 20:
        return 'Beast Mode';
      default:
        return 'Unknown';
    }
  }

  String _getEstimatedTime() {
    // Rough estimate: Watch time + (2 mins per question) + (5 mins for quiz)
    int total = _selectedWatchTime + (_selectedQuestionCount * 2);
    if (_quizEnabled) total += 5;
    
    if (total >= 60) {
      final hours = total ~/ 60;
      final mins = total % 60;
      return '${hours}h ${mins}m';
    }
    return '${total}m';
  }

  @override
  Widget build(BuildContext context) {
    // Deep charcoal background
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: Stack(
        children: [
          // 1. Ambient Background Effects
          _buildBackgroundAmbience(),

          // 2. Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER SECTION
                  _buildHeader(),
                  
                  const SizedBox(height: 32),

                  // MISSION SECTIONS
                  _buildWatchTimeSection(),
                  const SizedBox(height: 24),
                  
                  _buildQuestionsSection(),
                  const SizedBox(height: 24),
                  
                  _buildQuizSection(),
                  const SizedBox(height: 40),

                  // SUMMARY & CONFIRMATION
                  _buildMissionSummary(),
                  const SizedBox(height: 24),
                  
                  _buildConfirmationCheckbox(),
                  const SizedBox(height: 24),

                  // LOCK BUTTON
                  _buildLockButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundAmbience() {
    return Stack(
      children: [
        // Purple glow (Top-Right)
        Positioned(
          top: -100,
          right: -100,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonPurple.withValues(alpha: 0.15),
              ),
            ),
          ),
        ),
        // Cyan glow (Bottom-Left)
        Positioned(
          bottom: -50,
          left: -50,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonCyan.withValues(alpha: 0.15),
              ),
            ),
          ),
        ),
        // Noise Overlay (Optional - Simulated with opacity)
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.02), // Subtle texture feel
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Set Your',
          style: TextStyles.inter(
            fontSize: 14,
            color: Colors.grey[500]!,
          ).copyWith(letterSpacing: 2),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
        
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white, Colors.white.withValues(alpha: 0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: Text(
            'DAILY GOALS',
            style: TextStyles.orbitron(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ).copyWith(letterSpacing: 2),
          ),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1).then().shimmer(
          duration: 2000.ms,
          color: AppColors.neonBlue.withValues(alpha: 0.3),
        ),

        const SizedBox(height: 8),
        
        // System Status Label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(4),
            color: AppColors.neonCyan.withValues(alpha: 0.05),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.neonCyan,
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .fadeIn(duration: 500.ms)
               .then()
               .fadeOut(duration: 500.ms),
              const SizedBox(width: 8),
              Text(
                'SYSTEM STATUS: CONFIGURATION REQUIRED',
                style: TextStyles.orbitron(
                  fontSize: 10,
                  color: AppColors.neonCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        Text(
          'Build consistency by achieving small targets every day.',
          style: TextStyles.inter(
            fontSize: 14,
            color: Colors.grey[400]!,
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildWatchTimeSection() {
    return _buildMissionCard(
      color: AppColors.neonPurple,
      icon: FontAwesomeIcons.clock,
      title: 'WATCH TIME',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _watchTimeOptions.map((time) {
              final isSelected = _selectedWatchTime == time;
              return GestureDetector(
                onTap: () => setState(() => _selectedWatchTime = time),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.neonPurple.withValues(alpha: 0.2)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.neonPurple : Colors.grey[800]!,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppColors.neonPurple.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ] : [],
                  ),
                  child: Text(
                    '$time min',
                    style: TextStyles.orbitron(
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.grey[500]!,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            '≈ ${( _selectedWatchTime / 15 ).toStringAsFixed(1)} lessons per day',
            style: TextStyles.inter(
              fontSize: 12,
              color: AppColors.neonPurple.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildQuestionsSection() {
    return _buildMissionCard(
      color: AppColors.neonCyan,
      icon: FontAwesomeIcons.code,
      title: 'SOLVE QUESTIONS',
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _questionOptions.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final count = _questionOptions[index];
            final isSelected = _selectedQuestionCount == count;
            
            return GestureDetector(
              onTap: () => setState(() => _selectedQuestionCount = count),
              child: AnimatedContainer(
                duration: 200.ms,
                width: 80,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.neonCyan.withValues(alpha: 0.15)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.neonCyan : Colors.grey[800]!,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: AppColors.neonCyan.withValues(alpha: 0.2),
                      blurRadius: 10,
                    )
                  ] : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$count',
                      style: TextStyles.orbitron(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey[600]!,
                      ),
                    ),
                    Text(
                      'QNS',
                      style: TextStyles.orbitron(
                        fontSize: 10,
                        color: isSelected ? AppColors.neonCyan : Colors.grey[700]!,
                      ).copyWith(letterSpacing: 1),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.neonCyan : Colors.grey[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getDifficultyTag(count),
                        style: TextStyle(
                          fontSize: 9,
                          color: isSelected ? Colors.black : Colors.grey[500]!,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1);
  }

  Widget _buildQuizSection() {
    return _buildMissionCard(
      color: AppColors.neonPink,
      icon: FontAwesomeIcons.brain,
      title: 'DAILY QUIZ',
      child: GestureDetector(
        onTap: () => setState(() => _quizEnabled = !_quizEnabled),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _quizEnabled 
                ? AppColors.neonPink.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border.all(
              color: _quizEnabled ? AppColors.neonPink : Colors.grey[800]!,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: 300.ms,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _quizEnabled ? AppColors.neonPink : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _quizEnabled ? AppColors.neonPink : Colors.grey[600]!,
                    width: 2,
                  ),
                ),
                child: _quizEnabled 
                    ? const Icon(Icons.check, size: 16, color: Colors.black)
                    : null,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _quizEnabled ? 'STREAK MODE ENABLED' : 'Take a Quick Quiz',
                    style: TextStyles.orbitron(
                      fontSize: 16,
                      color: _quizEnabled ? AppColors.neonPink : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate(target: _quizEnabled ? 1 : 0).shimmer(duration: 1000.ms),
                  const SizedBox(height: 4),
                  Text(
                    _quizEnabled ? 'Daily Quiz Activated' : 'Test your knowledge daily',
                    style: TextStyles.inter(
                      fontSize: 12,
                      color: Colors.grey[400]!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1);
  }

  Widget _buildMissionCard({
    required Color color,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return GlassMorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18)
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: 2000.ms, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyles.orbitron(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.bold,
                ).copyWith(letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Separator line
          Container(
            height: 1,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildMissionSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D25),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: AppColors.neonBlue, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAILY COMMITMENT',
            style: TextStyles.orbitron(
              fontSize: 14,
              color: Colors.grey[400]!,
            ).copyWith(letterSpacing: 2),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Watch Time', '${_selectedWatchTime}m', AppColors.neonPurple),
          const SizedBox(height: 8),
          _buildSummaryRow('Questions', '$_selectedQuestionCount Qns', AppColors.neonCyan),
          const SizedBox(height: 8),
          _buildSummaryRow('Quiz', _quizEnabled ? 'Active' : 'Skipped', AppColors.neonPink),
          
          const SizedBox(height: 16),
          Divider(color: Colors.grey[800]),
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EST. DURATION',
                style: TextStyles.inter(color: Colors.grey[400]!, fontSize: 12),
              ),
              Text(
                _getEstimatedTime(),
                style: TextStyles.orbitron(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyles.inter(color: Colors.grey[500]!, fontSize: 14)),
        Text(
          value,
          style: TextStyles.orbitron(color: color, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildConfirmationCheckbox() {
    return GestureDetector(
      onTap: () => setState(() => _confirmed = !_confirmed),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: _confirmed ? AppColors.neonGreen : Colors.grey[600]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
              color: _confirmed ? AppColors.neonGreen.withValues(alpha: 0.2) : Colors.transparent,
            ),
            child: _confirmed 
                ? const Icon(Icons.check, size: 16, color: AppColors.neonGreen)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'I understand these goals reset every 24 hours. Consistency is mandatory.',
              style: TextStyles.inter(
                fontSize: 12,
                color: _confirmed ? Colors.white : Colors.grey[500]!,
              ).copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 900.ms);
  }

  Widget _buildLockButton() {
    return IgnorePointer(
      ignoring: !_confirmed,
      child: AnimatedOpacity(
        duration: 300.ms,
        opacity: _confirmed ? 1.0 : 0.5,
        child: GradientButton(
          text: 'LOCK DAILY GOALS',
          padding: const EdgeInsets.symmetric(vertical: 18),
          onPressed: () async {
            // Save goals to provider
            await ref.read(dailyGoalsProvider.notifier).updateGoals(
              watchTimeMinutes: _selectedWatchTime,
              questionCount: _selectedQuestionCount,
              quizEnabled: _quizEnabled,
            );
            
            if (!mounted) return;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.lock, color: Colors.black, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'MISSION PARAMETERS LOCKED',
                      style: TextStyles.orbitron(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                backgroundColor: AppColors.neonGreen,
                duration: const Duration(seconds: 2),
              ),
            );
            
            // Navigate to dashboard
            context.go('/dashboard');
          },
        ),
      ),
    ).animate().fadeIn(delay: 1000.ms);
  }
}