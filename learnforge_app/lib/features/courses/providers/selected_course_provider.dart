import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/course_model.dart'; // <-- IMPORTANT FIX

final selectedCourseProvider = StateProvider<Course?>((ref) => null);

final currentSelectedCourseProvider = Provider<Course?>((ref) {
  return ref.watch(selectedCourseProvider);
});

class SelectedCourseNotifier extends StateNotifier<Course?> {
  SelectedCourseNotifier() : super(null);

  void setSelectedCourse(Course course) {
    state = course;
  }

  void clearSelectedCourse() {
    state = null;
  }
}

final selectedCourseNotifierProvider =
    StateNotifierProvider<SelectedCourseNotifier, Course?>(
      (ref) => SelectedCourseNotifier(),
    );

// Helper function to set course by ID
void selectCourseById(WidgetRef ref, String courseId, List<Course> courses) {
  final course = courses.firstWhere(
    (c) => c.id == courseId,
    orElse: () => throw Exception("Course not found: $courseId"),
  );

  ref.read(selectedCourseNotifierProvider.notifier).setSelectedCourse(course);
}

final selectedCourseDataProvider = Provider<Course?>((ref) {
  return ref.watch(selectedCourseNotifierProvider);
});
