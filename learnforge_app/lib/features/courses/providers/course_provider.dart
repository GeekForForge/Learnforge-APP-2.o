import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/constants/dummy_data.dart';
import '../models/course_model.dart';

final coursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return DummyData.getCourses();
});

// Simulated enrolled courses subset
final enrolledCoursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 800));
  final allCourses = DummyData.getCourses();
  return allCourses.take(3).toList(); // mock enrolled
});

// Track currently opened/selected course
final selectedCourseProvider = StateProvider<CourseModel?>((ref) => null);
