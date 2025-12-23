import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnforge_app/features/courses/data/repositories/course_repository.dart';
import '../models/course_model.dart';

class CourseState {
  final List<Course> courses;
  final bool isLoading;
  final String? error;
  final String selectedCategory;

  const CourseState({
    this.courses = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory = 'All',
  });

  CourseState copyWith({
    List<Course>? courses,
    bool? isLoading,
    String? error,
    String? selectedCategory,
  }) {
    return CourseState(
      courses: courses ?? this.courses,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class CourseProvider extends Notifier<CourseState> {
  late final CourseRepository _repository;

  @override
  CourseState build() {
    print('🏗️ CourseProvider: Initializing...');
    _repository = CourseRepository();
    print('🏗️ CourseProvider: Calling loadCourses...');
    loadCourses();
    print('🏗️ CourseProvider: Initialized with empty state');
    return const CourseState();
  }

  Future<void> loadCourses() async {
    print('📚 CourseProvider: loadCourses() started');
    try {
      print('📚 CourseProvider: Setting loading state to true');
      state = state.copyWith(isLoading: true, error: null);
      
      print('📚 CourseProvider: Calling repository.getAllCourses()');
      final courses = await _repository.getAllCourses();
      
      print('📚 CourseProvider: Received ${courses.length} courses from repository');
      state = state.copyWith(courses: courses, isLoading: false);
      print('✅ CourseProvider: State updated with courses');
    } catch (e) {
      print('❌ CourseProvider: Error occurred: $e');
      state = state.copyWith(error: 'Failed to load courses: $e', isLoading: false);
      print('❌ CourseProvider: Error state set: ${state.error}');
    }
  }

  void toggleLessonCompletion(String courseId, String lessonId) {
    final courseIndex = state.courses.indexWhere((c) => c.id == courseId);
    if (courseIndex == -1) return;

    final course = state.courses[courseIndex];

    // 1. Find and toggle lesson
    final lessonIndex = course.lessons.indexWhere((l) => l.id == lessonId);
    if (lessonIndex == -1) return;

    final lesson = course.lessons[lessonIndex];
    final newStatus = !lesson.isCompleted;

    final updatedLessons = List<Lesson>.from(course.lessons);
    updatedLessons[lessonIndex] = lesson.copyWith(isCompleted: newStatus);

    // 2. Update Chapter progress
    final updatedChapters = course.chapters.map((chapter) {
      if (chapter.lessonIds.contains(lessonId)) {
        // Recalculate completion count for this chapter
        int completedCount = updatedLessons
            .where((l) => chapter.lessonIds.contains(l.id) && l.isCompleted)
            .length;
        return chapter.copyWith(completedLessons: completedCount);
      }
      return chapter;
    }).toList();

    // 3. Create updated Course
    final updatedCourse = course.copyWith(
        lessons: updatedLessons,
        chapters: updatedChapters
    );

    // 4. Update State
    final updatedCourses = List<Course>.from(state.courses);
    updatedCourses[courseIndex] = updatedCourse;

    state = state.copyWith(courses: updatedCourses);
  }

  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }
}


// Updated Providers
final courseProvider = NotifierProvider<CourseProvider, CourseState>(
      () => CourseProvider(),
);

// Provider for search functionality
final courseSearchProvider = StateProvider<String>((ref) => '');

// Provider for filtered courses
final filteredCoursesProvider = Provider<List<Course>>((ref) {
  final courseState = ref.watch(courseProvider);
  final searchQuery = ref.watch(courseSearchProvider).toLowerCase();

  var courses = courseState.courses;

  if (courseState.selectedCategory != 'All') {
    courses = courses.where((c) => c.categories.contains(courseState.selectedCategory)).toList();
  }

  if (searchQuery.isNotEmpty) {
    courses = courses.where((c) => c.title.toLowerCase().contains(searchQuery)).toList();
  }

  return courses;
});
