import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/dummy_data.dart';

final dashboardStatsProvider = FutureProvider((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return DashboardStats(
    streakDays: 5,
    currentXP: 2650,
    dailyGoalProgress: 0.80,
    coursesEnrolled: 3,
    activeCourse: DummyData.getCourses().first,
    nextLesson: DummyData.getDummyLessons()[2],
  );
});

class DashboardStats {
  final int streakDays;
  final int currentXP;
  final double dailyGoalProgress;
  final int coursesEnrolled;
  final dynamic activeCourse;
  final dynamic nextLesson;

  DashboardStats({
    required this.streakDays,
    required this.currentXP,
    required this.dailyGoalProgress,
    required this.coursesEnrolled,
    required this.activeCourse,
    required this.nextLesson,
  });
}
