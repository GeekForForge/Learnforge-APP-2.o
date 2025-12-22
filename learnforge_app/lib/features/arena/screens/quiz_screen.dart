import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';
import 'package:learnforge_app/core/widgets/gradient_button.dart';
import 'package:learnforge_app/features/arena/providers/arena_provider.dart';
import 'package:go_router/go_router.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arenaProvider);
    final notifier = ref.read(arenaProvider.notifier);

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.dark900,
        body: Center(child: CircularProgressIndicator(color: AppColors.neonBlue)),
      );
    }

    if (state.errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.dark900,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(state.errorMessage!, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 24),
              GradientButton(text: 'Go Back', onPressed: () => context.pop()),
            ],
          ),
        ),
      );
    }

    if (state.questions.isEmpty) {
       return Scaffold(
        backgroundColor: AppColors.dark900,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: Text("No questions found.", style: TextStyle(color: Colors.white))),
      );
    }

    if (state.isSubmitted) {
      return Scaffold(
        backgroundColor: AppColors.dark900,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: AppColors.neonYellow, size: 80),
              const SizedBox(height: 24),
              const Text("Quiz Completed!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              Text("Score: ${state.score}", style: const TextStyle(fontSize: 20, color: AppColors.neonBlue)),
              const SizedBox(height: 32),
              GradientButton(
                text: 'Back to Arena',
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      );
    }

    final question = state.questions[state.currentIndex];
    final selectedAnswer = state.userAnswers[question.id];
    final totalQuestions = state.questions.length;
    final progress = (state.currentIndex + 1) / totalQuestions;

    return Scaffold(
      backgroundColor: AppColors.dark900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Question ${state.currentIndex + 1}/$totalQuestions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.dark800,
              valueColor: const AlwaysStoppedAnimation(AppColors.neonBlue),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 32),
            
            // Question Text
            Text(
              question.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Options
            Expanded(
              child: ListView.separated(
                itemCount: question.options.length,
                separatorBuilder: (c, i) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  // If backend provides 'A', 'B' etc, we might need to map index 0 -> A.
                  // For now assuming option string matches answer key or logic.
                  // We'll treat the option STRING as the answer value.
                  
                  final isSelected = selectedAnswer == option; // Using option string as value
                  // Or if backend expects "Option A" but sends "Option content"? 
                  // Assuming option string is the answer.

                  return GestureDetector(
                    onTap: () => notifier.selectAnswer(question.id, option),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.neonBlue.withValues(alpha: 0.2) : AppColors.dark800,
                        border: Border.all(
                          color: isSelected ? AppColors.neonBlue : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColors.neonBlue : AppColors.grey400,
                              ),
                              color: isSelected ? AppColors.neonBlue : Colors.transparent,
                            ),
                            child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(child: Text(option, style: const TextStyle(color: Colors.white, fontSize: 16))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Navigation Buttons
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (state.currentIndex > 0)
                  TextButton.icon(
                    onPressed: notifier.prevQuestion,
                    icon: const Icon(Icons.arrow_back, color: AppColors.grey400),
                    label: const Text('Previous', style: TextStyle(color: AppColors.grey400)),
                  )
                else
                  const SizedBox(width: 80),

                if (state.currentIndex < totalQuestions - 1)
                  GradientButton(
                    text: 'Next',
                    onPressed: notifier.nextQuestion,
                    width: 120,
                  )
                else
                  GradientButton(
                    text: 'Submit',
                    onPressed: () => notifier.submitQuiz('user123'), // Mock user ID for now
                    width: 120,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
