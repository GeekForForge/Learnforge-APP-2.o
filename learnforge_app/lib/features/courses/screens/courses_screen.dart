import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';
import 'package:learnforge_app/core/widgets/gradient_button.dart';
import 'package:learnforge_app/features/courses/models/course_model.dart';
import 'package:learnforge_app/features/courses/providers/course_provider.dart';
import 'package:learnforge_app/features/courses/providers/selected_course_provider.dart';
import 'package:learnforge_app/features/courses/widgets/course_grid_card.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'Mobile Development',
    'Web Development',
    'Data Science',
    'AI & ML',
    'Design',
    'Business',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(courseProvider.notifier).loadCourses();
      ref.read(courseProvider.notifier).loadMyCourses();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToCourseDetail(String courseId) {
    final courses = ref.read(courseProvider).courses;
    final course = courses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => courses.first,
    );
    ref.read(selectedCourseProvider.notifier).state = course;
    // Navigate to course detail - you'll need to set up your router
    // context.push('/course/$courseId');
  }

  void _enrollInCourse(String courseId) {
    ref.read(courseProvider.notifier).enrollInCourse(courseId);
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseProvider);
    final featuredCourses = ref.watch(featuredCoursesProvider);
    final myCourses = ref.watch(myCoursesProvider);
    final filteredCourses = ref.watch(filteredCoursesProvider);

    return Scaffold(
      backgroundColor: AppColors.dark900,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: AppColors.dark900,
              elevation: 0,
              pinned: true,
              floating: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.neonPurple.withOpacity(0.1),
                        AppColors.neonCyan.withOpacity(0.05),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                title: const Text(
                  'Courses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),

            if (featuredCourses.isNotEmpty)
              SliverToBoxAdapter(child: _buildFeaturedSection(featuredCourses)),

            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                tabController: _tabController,
                categories: _categories,
                onCategorySelected: (category) {
                  ref
                      .read(courseProvider.notifier)
                      .setSelectedCategory(category);
                },
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAllCoursesTab(filteredCourses, courseState),
            _buildMyCoursesTab(myCourses, courseState),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(List<Course> featuredCourses) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Featured Courses',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: featuredCourses.length,
              itemBuilder: (context, index) {
                final course = featuredCourses[index];
                final isEnrolled = ref
                    .read(myCoursesProvider)
                    .any((c) => c.id == course.id);

                return SizedBox(
                  width: 300,
                  child: CourseGridCard(
                    courseId: course.id,
                    title: course.title,
                    instructor: course.instructor,
                    thumbnail: course.thumbnail,
                    rating: course.rating,
                    totalRatings: course.totalRatings,
                    enrolledCount: course.enrolledCount,
                    level: course.level,
                    isFree: course.isFree,
                    price: course.price,
                    totalLessons: course.totalLessons,
                    completedLessons: isEnrolled ? course.totalLessons ~/ 2 : 0,
                    isEnrolled: isEnrolled,
                    onTap: () => _navigateToCourseDetail(course.id),
                    onEnroll: () => _enrollInCourse(course.id),
                  ),
                );
              },
            ),
          ),
        ],
      ).animate().fadeIn(delay: 200.ms),
    );
  }

  Widget _buildAllCoursesTab(List<Course> courses, CourseState state) {
    if (state.isLoading) {
      return _buildLoadingState();
    }

    if (courses.isEmpty) {
      return _buildEmptyState('No courses found', 'Try changing your filters');
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildCategoryChips()),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final course = courses[index];
              final isEnrolled = ref
                  .read(myCoursesProvider)
                  .any((c) => c.id == course.id);

              return CourseGridCard(
                courseId: course.id,
                title: course.title,
                instructor: course.instructor,
                thumbnail: course.thumbnail,
                rating: course.rating,
                totalRatings: course.totalRatings,
                enrolledCount: course.enrolledCount,
                level: course.level,
                isFree: course.isFree,
                price: course.price,
                totalLessons: course.totalLessons,
                completedLessons: isEnrolled ? course.totalLessons ~/ 2 : 0,
                isEnrolled: isEnrolled,
                onTap: () => _navigateToCourseDetail(course.id),
                onEnroll: () => _enrollInCourse(course.id),
              );
            }, childCount: courses.length),
          ),
        ),
      ],
    );
  }

  Widget _buildMyCoursesTab(List<Course> myCourses, CourseState state) {
    if (state.isLoading) {
      return _buildLoadingState();
    }

    if (myCourses.isEmpty) {
      return _buildEmptyState(
        'No courses enrolled',
        'Explore our catalog and start learning today!',
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final course = myCourses[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildMyCourseItem(course),
              );
            }, childCount: myCourses.length),
          ),
        ),
      ],
    );
  }

  Widget _buildMyCourseItem(Course course) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dark800,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.dark700, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _navigateToCourseDetail(course.id),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(course.thumbnail),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${course.totalLessons} lessons • ${course.duration} hours',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.dark700,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Stack(
                          children: [
                            Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.neonCyan,
                                        AppColors.neonBlue,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                )
                                .animate(
                                  onPlay: (controller) => controller.repeat(),
                                )
                                .shimmer(
                                  duration: 2000.ms,
                                  color: AppColors.neonCyan.withOpacity(0.3),
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.neonCyan,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().slideX(begin: 0.5, end: 0, duration: 400.ms);
  }

  Widget _buildCategoryChips() {
    final selectedCategory = ref.watch(courseProvider).selectedCategory;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == selectedCategory;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              onSelected: (_) {
                ref.read(courseProvider.notifier).setSelectedCategory(category);
              },
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.7),
                  fontFamily: 'Inter',
                ),
              ),
              selectedColor: AppColors.neonPurple,
              backgroundColor: AppColors.dark700,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.neonCyan),
          const SizedBox(height: 16),
          Text(
            'Loading courses...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(
            text: 'Explore Courses',
            onPressed: () {
              _tabController.animateTo(0);
            },
            width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<String> categories;
  final Function(String) onCategorySelected;

  _TabBarDelegate({
    required this.tabController,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.dark900,
      child: Column(
        children: [
          TabBar(
            controller: tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.5),
            indicatorColor: AppColors.neonCyan,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
            tabs: const [
              Tab(text: 'All Courses'),
              Tab(text: 'My Courses'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
