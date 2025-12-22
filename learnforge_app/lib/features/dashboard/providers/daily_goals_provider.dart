import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_goals_model.dart';

final dailyGoalsProvider = NotifierProvider<DailyGoalsNotifier, DailyGoals>(() {
  return DailyGoalsNotifier();
});

class DailyGoalsNotifier extends Notifier<DailyGoals> {
  @override
  DailyGoals build() {
    _loadGoals();
    return DailyGoals.defaultGoals();
  }

  Future<void> _loadGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final watchTime = prefs.getInt('watchTimeMinutes') ?? 30;
      final questionCount = prefs.getInt('questionCount') ?? 10;
      final quizEnabled = prefs.getBool('quizEnabled') ?? false;

      state = DailyGoals(
        watchTimeMinutes: watchTime,
        questionCount: questionCount,
        quizEnabled: quizEnabled,
      );
    } catch (e) {
      // If loading fails, keep default goals
      // print('Error loading goals: $e');
    }
  }

  Future<void> updateGoals({
    required int watchTimeMinutes,
    required int questionCount,
    required bool quizEnabled,
  }) async {
    state = DailyGoals(
      watchTimeMinutes: watchTimeMinutes,
      questionCount: questionCount,
      quizEnabled: quizEnabled,
    );

    // Persist to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('watchTimeMinutes', watchTimeMinutes);
      await prefs.setInt('questionCount', questionCount);
      await prefs.setBool('quizEnabled', quizEnabled);
    } catch (e) {
      // print('Error saving goals: $e');
    }
  }
}
