import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../models/youtube_playlist_model.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../../../core/widgets/gradient_button.dart';

class PlaylistCarousel extends StatelessWidget {
  final String title;
  final String emoji;
  final List<YouTubePlaylist> playlists;
  final VoidCallback? onSeeAll;
  final bool showProgress;
  final int animationDelay;

  const PlaylistCarousel({
    Key? key,
    required this.title,
    required this.emoji,
    required this.playlists,
    this.onSeeAll,
    this.showProgress = true,
    this.animationDelay = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (playlists.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyles.orbitron(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'See All',
                        style: TextStyles.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neonCyan,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.neonCyan,
                        size: 12,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ).animate().fadeIn(
              delay: animationDelay.ms,
              duration: 400.ms,
            ),

        const SizedBox(height: 12),

        // Horizontal Scrolling List
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: playlists.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildPlaylistCard(context, playlist),
              )
                  .animate()
                  .fadeIn(
                    delay: (animationDelay + (index * 100)).ms,
                    duration: 400.ms,
                  )
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.0, 1.0),
                    delay: (animationDelay + (index * 100)).ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  );
            },
          ),
        ).animate().slideX(
              begin: 0.05,
              end: 0,
              delay: animationDelay.ms,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),
      ],
    );
  }

  Widget _buildPlaylistCard(BuildContext context, YouTubePlaylist playlist) {
    return GlassMorphicCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push('/playlist/${playlist.id}'),
      child: SizedBox(
        width: 260,
        height: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(playlist.thumbnailUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.45),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // XP badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neonCyan,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "+50 XP",
                        style: TextStyles.inter(
                          fontSize: 11,
                          color: AppColors.dark900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playlist.title,
                          style: TextStyles.orbitron(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        if (showProgress && playlist.userProgress > 0) ...[
                          LinearProgressIndicator(
                            value: playlist.userProgress,
                            backgroundColor: AppColors.dark700,
                            valueColor: AlwaysStoppedAnimation(
                              AppColors.neonBlue,
                            ),
                            minHeight: 6,
                          ),
                          const SizedBox(height: 8),
                        ] else
                          const SizedBox(height: 8),
                      ],
                    ),

                    // Button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GradientButton(
                          text: playlist.userProgress > 0
                              ? "Continue"
                              : "Start Learning",
                          onPressed: () =>
                              context.push('/playlist/${playlist.id}'),
                          height: 42,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
