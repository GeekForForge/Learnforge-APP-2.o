import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';
import 'course_provider.dart';

// Provider for enrolled courses with progress
final enrolledCoursesProvider = Provider<List<Course>>((ref) {
  final myCourses = ref.watch(myCoursesProvider);
  final courseProgress = ref.watch(courseProvider).courseProgress;

  return myCourses.map((course) {
    final progress = courseProgress[course.id];
    if (progress != null) {
      // Create a copy of course with progress data
      return course.copyWith();
    }
    return course;
  }).toList();
});

// Provider for user's course progress
final userCourseProgressProvider = Provider<Map<String, double>>((ref) {
  final courseProgress = ref.watch(courseProvider).courseProgress;
  final progressMap = <String, double>{};

  courseProgress.forEach((courseId, progress) {
    progressMap[courseId] = progress.progress;
  });

  return progressMap;
});

// Provider for completed courses count
final completedCoursesProvider = Provider<int>((ref) {
  final progress = ref.watch(userCourseProgressProvider);
  return progress.values.where((p) => p >= 0.95).length;
});

// Provider for total learning time
final totalLearningTimeProvider = Provider<String>((ref) {
  final myCourses = ref.watch(myCoursesProvider);
  final totalHours = myCourses.fold(0, (sum, course) => sum + course.duration);
  return '${totalHours}h';
});
