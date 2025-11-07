import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../providers/course_provider.dart';
import '../widgets/course_grid_card.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      backgroundColor: AppColors.dark900, // Fixed: darkBg → dark900
      appBar: AppBar(
        title: const Text('Courses', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.dark800, // Fixed: darkBgSecondary → dark800
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: coursesAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
          ),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: AppColors.neonPurple, size: 64),
              const SizedBox(height: 16),
              Text(
                'Failed to load courses',
                style: TextStyle(fontSize: 18, color: AppColors.white),
              ),
              const SizedBox(height: 8),
              Text(
                err.toString(),
                style: TextStyle(fontSize: 14, color: AppColors.grey400),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (courses) {
          if (courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, color: AppColors.neonCyan, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No Courses Found',
                    style: TextStyle(fontSize: 18, color: AppColors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore our course catalog to get started',
                    style: TextStyle(fontSize: 14, color: AppColors.grey400),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to course catalog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonPurple,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Browse Catalog'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                GlassMorphicCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: AppColors.grey400,
                      ), // Fixed: textMuted → grey400
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search courses...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: AppColors.grey400,
                            ), // Fixed: textMuted → grey400
                          ),
                          style: TextStyle(
                            color: AppColors.white,
                          ), // Fixed: textLight → white
                        ),
                      ),
                    ],
                  ),
                ).animate().slideY(duration: 400.ms, curve: Curves.easeOut),
                const SizedBox(height: 20),

                // Section Title
                Text(
                  'Enrolled Courses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white, // Fixed: textLight → white
                  ),
                ),
                const SizedBox(height: 16),

                // Grid of Courses
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return GestureDetector(
                      onTap: () {
                        ref.read(selectedCourseProvider.notifier).state =
                            course;
                        context.push('/course-detail');
                      },
                      child:
                          GlassMorphicCard(
                            // Replaced Card with GlassMorphicCard for consistency
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Course thumbnail
                                  Container(
                                    height: 100,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: course.thumbnail != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                course.thumbnail!,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                      color: course.thumbnail == null
                                          ? AppColors.dark700
                                          : Colors.transparent,
                                    ),
                                    child: course.thumbnail == null
                                        ? Icon(
                                            Icons.school,
                                            color: AppColors.grey400,
                                            size: 40,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(height: 8),

                                  // Course title
                                  Text(
                                    course.title ?? 'Untitled Course',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 4),

                                  // Course instructor
                                  Text(
                                    course.instructor ?? 'Unknown Instructor',
                                    style: TextStyle(
                                      color: AppColors.grey400,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const Spacer(),

                                  // Progress indicator
                                  LinearProgressIndicator(
                                    value: course.progress ?? 0.0,
                                    backgroundColor: AppColors.dark700,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.neonCyan,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),

                                  const SizedBox(height: 4),

                                  // Progress text
                                  Text(
                                    '${((course.progress ?? 0.0) * 100).toStringAsFixed(0)}% complete',
                                    style: TextStyle(
                                      color: AppColors.grey400,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().slideY(
                            duration: (300 + index * 100).ms,
                            curve: Curves.easeOut,
                          ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
