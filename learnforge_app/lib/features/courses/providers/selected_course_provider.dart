import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/course_model.dart';

// Provider to manage the currently selected course
final selectedCourseProvider = StateProvider<Course?>((ref) => null);

// Provider to get the selected course with null safety
final currentSelectedCourseProvider = Provider<Course>((ref) {
  final selectedCourse = ref.watch(selectedCourseProvider);
  if (selectedCourse == null) {
    throw Exception('No course selected');
  }
  return selectedCourse;
});

// Provider for selected course state (loading, error, data)
class SelectedCourseState {
  final Course? course;
  final bool isLoading;
  final String? error;

  const SelectedCourseState({this.course, this.isLoading = false, this.error});

  SelectedCourseState copyWith({
    Course? course,
    bool? isLoading,
    String? error,
  }) {
    return SelectedCourseState(
      course: course ?? this.course,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SelectedCourseNotifier extends StateNotifier<SelectedCourseState> {
  SelectedCourseNotifier() : super(const SelectedCourseState());

  // Set the selected course
  void setSelectedCourse(Course course) {
    state = state.copyWith(course: course, isLoading: false, error: null);
  }

  // Clear the selected course
  void clearSelectedCourse() {
    state = const SelectedCourseState();
  }

  // Set loading state
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  // Set error state
  void setError(String error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  // Update course progress (if you have progress tracking)
  void updateCourseProgress(double progress) {
    if (state.course != null) {
      // Note: Since Course is immutable, you might need to create a new instance
      // or add progress tracking separately
      state = state.copyWith();
    }
  }

  // Check if a course is selected
  bool get hasSelectedCourse => state.course != null;
}

// StateNotifierProvider for selected course management
final selectedCourseNotifierProvider =
    StateNotifierProvider<SelectedCourseNotifier, SelectedCourseState>(
      (ref) => SelectedCourseNotifier(),
    );

// Convenience providers
final selectedCourseDataProvider = Provider<Course?>((ref) {
  return ref.watch(selectedCourseNotifierProvider).course;
});

final selectedCourseLoadingProvider = Provider<bool>((ref) {
  return ref.watch(selectedCourseNotifierProvider).isLoading;
});

final selectedCourseErrorProvider = Provider<String?>((ref) {
  return ref.watch(selectedCourseNotifierProvider).error;
});

// Utility function to select a course by ID
void selectCourseById(WidgetRef ref, String courseId, List<Course> courses) {
  try {
    final course = courses.firstWhere((c) => c.id == courseId);
    ref.read(selectedCourseNotifierProvider.notifier).setSelectedCourse(course);
  } catch (e) {
    ref
        .read(selectedCourseNotifierProvider.notifier)
        .setError('Course not found: $courseId');
  }
}

// Example usage in widgets:
/*
// To set a selected course:
ref.read(selectedCourseNotifierProvider.notifier).setSelectedCourse(course);

// To get the selected course:
final selectedCourse = ref.watch(selectedCourseDataProvider);

// To check if loading:
final isLoading = ref.watch(selectedCourseLoadingProvider);

// To clear selection:
ref.read(selectedCourseNotifierProvider.notifier).clearSelectedCourse();
*/
