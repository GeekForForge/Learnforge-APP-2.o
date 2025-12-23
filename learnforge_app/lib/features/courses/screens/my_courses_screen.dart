import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/particle_background.dart';
import '../providers/course_provider.dart';
import '../widgets/playlist_carousel.dart';
import '../../../core/widgets/empty_state.dart';

class MyCoursesScreen extends ConsumerWidget {
  const MyCoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrolledPlaylists = ref.watch(myPlaylistsProvider);

    return ParticleBackground(
      particleCount: 25,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.dark900.withOpacity(0.95),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'My Courses',
            style: TextStyles.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: enrolledPlaylists.isEmpty
            ? EmptyState(
                title: 'No Enrolled Courses',
                subtitle: 'Start learning by enrolling in courses',
                actionLabel: 'Browse Courses',
                onActionPressed: () => Navigator.of(context).pop(),
                glowColor: AppColors.neonPurple,
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Continue your learning journey',
                            style: TextStyles.inter(
                              fontSize: 16,
                              color: AppColors.grey400,
                            ),
                          ).animate().fadeIn(duration: 600.ms),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: PlaylistCarousel(
                      title: 'Enrolled Courses',
                      emoji: '🔥',
                      playlists: enrolledPlaylists,
                      showProgress: true,
                      animationDelay: 200,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
      ),
    );
  }
}
