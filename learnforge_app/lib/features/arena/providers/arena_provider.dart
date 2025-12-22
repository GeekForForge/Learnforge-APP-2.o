import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnforge_app/core/constants/dummy_data.dart';
import 'package:learnforge_app/features/arena/data/models/question_model.dart';
import 'package:learnforge_app/features/arena/data/repositories/arena_repository.dart';

// --- Repository Provider ---
final arenaRepositoryProvider = Provider((ref) => ArenaRepository());

// --- State Class ---
class ArenaState {
  final bool isLoading;
  final List<QuestionModel> questions;
  final int currentIndex;
  final Map<int, String> userAnswers; // questionId -> answer
  final bool isSubmitted;
  final String? errorMessage;
  final int score;

  const ArenaState({
    this.isLoading = false,
    this.questions = const [],
    this.currentIndex = 0,
    this.userAnswers = const {},
    this.isSubmitted = false,
    this.errorMessage,
    this.score = 0,
  });

  ArenaState copyWith({
    bool? isLoading,
    List<QuestionModel>? questions,
    int? currentIndex,
    Map<int, String>? userAnswers,
    bool? isSubmitted,
    String? errorMessage,
    int? score,
  }) {
    return ArenaState(
      isLoading: isLoading ?? this.isLoading,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      errorMessage: errorMessage ?? this.errorMessage,
      score: score ?? this.score,
    );
  }
}

// --- Notifier ---
class ArenaNotifier extends Notifier<ArenaState> {
  late final ArenaRepository _repository;

  @override
  ArenaState build() {
    _repository = ref.read(arenaRepositoryProvider);
    return const ArenaState();
  }

  Future<void> startQuiz({String topic = 'Java', String difficulty = 'Medium'}) async {
    state = state.copyWith(isLoading: true, errorMessage: null, questions: [], currentIndex: 0, userAnswers: {}, isSubmitted: false, score: 0);
    
    try {
      final questions = await _repository.getQuestions(topic: topic, difficulty: difficulty);
      state = state.copyWith(isLoading: false, questions: questions);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectAnswer(int questionId, String answer) {
    if (state.isSubmitted) return;
    final newAnswers = Map<int, String>.from(state.userAnswers);
    newAnswers[questionId] = answer;
    state = state.copyWith(userAnswers: newAnswers);
  }

  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void prevQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  Future<void> submitQuiz(String userId) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _repository.submitAnswers(userId: userId, answers: state.userAnswers);
      // Assuming result contains 'score' or similar
      // For now, simple client-side calc if result doesn't have it, or use result
      int score = 0;
      if (result.containsKey('score')) {
        score = (result['score'] is int) ? result['score'] : int.tryParse(result['score'].toString()) ?? 0;
      }
      
      state = state.copyWith(isLoading: false, isSubmitted: true, score: score);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final arenaProvider = NotifierProvider<ArenaNotifier, ArenaState>(ArenaNotifier.new);

// --- Existing Providers (Keep for UI compatibility for now) ---
final challengesProvider = FutureProvider((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return DummyData.getChallenges();
});

final leaderboardProvider = FutureProvider((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  // Replace with backend later: ref.read(arenaRepositoryProvider).getLeaderboard()
  return DummyData.getLeaderboard();
});

final selectedTabProvider = StateProvider<String>((ref) => 'live');
