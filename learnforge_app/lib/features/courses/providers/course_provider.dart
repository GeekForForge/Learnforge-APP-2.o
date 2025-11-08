import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:learnforge_app/features/courses/models/course_model.dart';

class CourseState {
  final List<Course> courses;
  final List<Course> featuredCourses;
  final List<Course> myCourses;
  final Map<String, CourseProgress> courseProgress;
  final bool isLoading;
  final String? error;
  final String selectedCategory;

  const CourseState({
    this.courses = const [],
    this.featuredCourses = const [],
    this.myCourses = const [],
    this.courseProgress = const {},
    this.isLoading = false,
    this.error,
    this.selectedCategory = 'All',
  });

  CourseState copyWith({
    List<Course>? courses,
    List<Course>? featuredCourses,
    List<Course>? myCourses,
    Map<String, CourseProgress>? courseProgress,
    bool? isLoading,
    String? error,
    String? selectedCategory,
  }) {
    return CourseState(
      courses: courses ?? this.courses,
      featuredCourses: featuredCourses ?? this.featuredCourses,
      myCourses: myCourses ?? this.myCourses,
      courseProgress: courseProgress ?? this.courseProgress,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class CourseProvider extends StateNotifier<CourseState> {
  CourseProvider() : super(const CourseState());

  // Mock data - Replace with actual API calls
  final List<Course> _mockCourses = [
    Course(
      id: '1',
      title: 'Advanced Flutter Development',
      description:
          'Master advanced Flutter concepts including state management, animations, and performance optimization.',
      instructor: 'Sarah Johnson',
      instructorImage:
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
      thumbnail:
          'https://images.unsplash.com/photo-1555099962-4199c345e5dd?w=400',
      rating: 4.8,
      totalRatings: 1247,
      enrolledCount: 15420,
      level: 'Advanced',
      duration: 28,
      totalLessons: 45,
      price: 2999,
      isFree: false,
      isFeatured: true,
      categories: ['Mobile Development', 'Flutter', 'Dart'],
      learningObjectives: [
        'Master advanced state management techniques',
        'Build complex animations and custom widgets',
        'Optimize app performance',
        'Implement advanced architecture patterns',
      ],
      lessons: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Course(
      id: '2',
      title: 'Machine Learning Fundamentals',
      description:
          'Learn the basics of machine learning with Python and TensorFlow.',
      instructor: 'Dr. Alex Chen',
      instructorImage:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      thumbnail:
          'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=400',
      rating: 4.6,
      totalRatings: 892,
      enrolledCount: 10250,
      level: 'Intermediate',
      duration: 35,
      totalLessons: 52,
      price: 0,
      isFree: true,
      isFeatured: true,
      categories: ['Data Science', 'Python', 'AI'],
      learningObjectives: [
        'Understand ML algorithms',
        'Build and train models',
        'Evaluate model performance',
      ],
      lessons: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Course(
      id: '3',
      title: 'Web Development with React & Node',
      description: 'Full-stack web development using modern technologies.',
      instructor: 'Mike Thompson',
      instructorImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      thumbnail:
          'https://images.unsplash.com/photo-1627398242454-45a1465c2479?w=400',
      rating: 4.7,
      totalRatings: 1563,
      enrolledCount: 18700,
      level: 'Beginner',
      duration: 42,
      totalLessons: 68,
      price: 2499,
      isFree: false,
      isFeatured: false,
      categories: ['Web Development', 'React', 'Node.js'],
      learningObjectives: [
        'Build responsive web applications',
        'Create RESTful APIs',
        'Deploy applications to cloud',
      ],
      lessons: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  Future<void> loadCourses() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final featuredCourses = _mockCourses
          .where((course) => course.isFeatured)
          .toList();

      state = state.copyWith(
        courses: _mockCourses,
        featuredCourses: featuredCourses,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load courses: $e',
        isLoading: false,
      );
    }
  }

  Future<void> loadMyCourses() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Simulate API call for user's enrolled courses
      await Future.delayed(const Duration(seconds: 1));

      // For demo, take first 2 courses as enrolled
      final myCourses = _mockCourses.take(2).toList();

      state = state.copyWith(myCourses: myCourses, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load your courses: $e',
        isLoading: false,
      );
    }
  }

  Future<void> enrollInCourse(String courseId) async {
    try {
      final course = _mockCourses.firstWhere((c) => c.id == courseId);
      final updatedMyCourses = [...state.myCourses, course];

      state = state.copyWith(myCourses: updatedMyCourses);

      // Simulate API call for enrollment
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      state = state.copyWith(error: 'Failed to enroll in course: $e');
    }
  }

  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  List<Course> get filteredCourses {
    if (state.selectedCategory == 'All') {
      return state.courses;
    }
    return state.courses
        .where((course) => course.categories.contains(state.selectedCategory))
        .toList();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final courseProvider = StateNotifierProvider<CourseProvider, CourseState>(
  (ref) => CourseProvider(),
);

final featuredCoursesProvider = Provider<List<Course>>((ref) {
  return ref.watch(courseProvider).featuredCourses;
});

final myCoursesProvider = Provider<List<Course>>((ref) {
  return ref.watch(courseProvider).myCourses;
});

final filteredCoursesProvider = Provider<List<Course>>((ref) {
  final courseState = ref.watch(courseProvider);
  if (courseState.selectedCategory == 'All') {
    return courseState.courses;
  }
  return courseState.courses
      .where(
        (course) => course.categories.contains(courseState.selectedCategory),
      )
      .toList();
});
