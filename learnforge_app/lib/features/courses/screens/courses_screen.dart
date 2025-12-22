import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_provider.dart';
import '../../../core/widgets/particle_background.dart';
import '../widgets/hero_course_banner.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/course_carousel.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  String _selectedCategory = 'All';
  
  final List<String> _categories = [
    'All',
    'Flutter',
    'Web',
    'Python',
    'Java',
    'DSA',
    'ML',
  ];

  @override
  Widget build(BuildContext context) {
    // Get courses from provider
    final courseState = ref.watch(courseProvider);
    final allCourses = courseState.courses;
    
    if (courseState.isLoading) {
      return const Scaffold(backgroundColor: Colors.transparent, body: Center(child: CircularProgressIndicator()));
    }
    
    if (courseState.error != null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: Text('Error: ${courseState.error}', style: const TextStyle(color: Colors.white))),
      );
    }
    
    // Check if courses are empty
    if (allCourses.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(Icons.school_outlined, size: 100, color: Colors.white.withValues(alpha: 0.3)),
              const SizedBox(height: 20),
              const Text(
                'No courses available',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Courses will appear here once loaded',
                style: TextStyle(fontSize: 14, color: Colors.white54),
              ),
            ],
          ),
        ),
      );
    }
    
    // Filter courses by category
    final filteredCourses = _selectedCategory == 'All'
        ? allCourses
        : allCourses.where((course) {
            return course.categories.any((cat) =>
                cat.toLowerCase().contains(_selectedCategory.toLowerCase()));
          }).toList();

    // Categorize courses for different carousels
    final continueLearningCourses = filteredCourses.where((course) {
      return course.lessons.any((lesson) => lesson.isCompleted);
    }).toList();

    final trendingCourses = filteredCourses.where((course) {
      return course.enrolledCount > 4000;
    }).toList();

    final recommendedCourses = filteredCourses.where((course) {
      return course.rating >= 4.7;
    }).toList();

    final newCourses = filteredCourses.where((course) {
      final daysSinceCreated =
          DateTime.now().difference(course.createdAt).inDays;
      return daysSinceCreated <= 45;
    }).toList();

    final freeCourses = filteredCourses.where((course) {
      return course.isFree;
    }).toList();

    // Featured course for hero banner - safely handle empty lists
    final featuredCourse = allCourses.isNotEmpty
        ? (allCourses.firstWhere(
            (course) => course.isFeatured,
            orElse: () => allCourses.first,
          ))
        : null;

    return ParticleBackground(
      particleCount: 25,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            // Hero Course Banner - only show if we have a featured course
            if (featuredCourse != null)
              SliverToBoxAdapter(
                child: HeroCourseBanner(
                  course: featuredCourse,
                  onContinue: () {
                    // Navigate to course detail
                    debugPrint('Continue course: ${featuredCourse.id}');
                  },
                  onBookmark: () {
                    // Toggle bookmark
                    debugPrint('Bookmark course: ${featuredCourse.id}');
                  },
                  isBookmarked: false,
                ),
              ),

            // Category Filter Chips
            SliverToBoxAdapter(
              child: CategoryFilterChips(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Continue Learning Carousel
            if (continueLearningCourses.isNotEmpty)
              SliverToBoxAdapter(
                child: CourseCarousel(
                  title: 'Continue Learning',
                  emoji: '🔥',
                  courses: continueLearningCourses,
                  showProgress: true,
                  animationDelay: 200,
                  onSeeAll: () {
                    debugPrint('See all continue learning courses');
                  },
                ),
              ),

            if (continueLearningCourses.isNotEmpty)
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Trending Now Carousel
            if (trendingCourses.isNotEmpty)
              SliverToBoxAdapter(
                child: CourseCarousel(
                  title: 'Trending Now',
                  emoji: '⚡',
                  courses: trendingCourses,
                  showProgress: false,
                  animationDelay: 400,
                  onSeeAll: () {
                    debugPrint('See all trending courses');
                  },
                ),
              ),

            if (trendingCourses.isNotEmpty)
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Recommended For You Carousel
            if (recommendedCourses.isNotEmpty)
              SliverToBoxAdapter(
                child: CourseCarousel(
                  title: 'Recommended For You',
                  emoji: '📚',
                  courses: recommendedCourses,
                  showProgress: false,
                  animationDelay: 600,
                  onSeeAll: () {
                    debugPrint('See all recommended courses');
                  },
                ),
              ),

            if (recommendedCourses.isNotEmpty)
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // New Courses Carousel
            if (newCourses.isNotEmpty)
              SliverToBoxAdapter(
                child: CourseCarousel(
                  title: 'New Courses',
                  emoji: '🎯',
                  courses: newCourses,
                  showProgress: false,
                  animationDelay: 800,
                  onSeeAll: () {
                    debugPrint('See all new courses');
                  },
                ),
              ),

            if (newCourses.isNotEmpty)
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Free Courses Carousel
            if (freeCourses.isNotEmpty)
              SliverToBoxAdapter(
                child: CourseCarousel(
                  title: 'Free Courses',
                  emoji: '🌟',
                  courses: freeCourses,
                  showProgress: false,
                  animationDelay: 1000,
                  onSeeAll: () {
                    debugPrint('See all free courses');
                  },
                ),
              ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
