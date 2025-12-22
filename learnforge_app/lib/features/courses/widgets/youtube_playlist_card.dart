import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_morphic_card.dart';
import '../models/youtube_playlist_model.dart';

class YouTubePlaylistCard extends StatelessWidget {
  final YouTubePlaylist playlist;
  final VoidCallback onTap;

  const YouTubePlaylistCard({
    super.key,
    required this.playlist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassMorphicCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Stack(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(playlist.thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // YouTube badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
              // Video count
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${playlist.videoCount}+',
                    style: TextStyles.inter(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Category tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.neonPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.5)),
            ),
            child: Text(
              playlist.category,
              style: TextStyles.inter(
                fontSize: 10,
                color: AppColors.neonPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Playlist title
          Text(
            playlist.title,
            style: TextStyles.orbitron(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Channel name
          Text(
            playlist.channelTitle,
            style: TextStyles.inter(
              fontSize: 12,
              color: AppColors.grey400,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Progress indicator (if any progress)
          if (playlist.userProgress > 0) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: playlist.userProgress,
              backgroundColor: AppColors.dark700,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
            const SizedBox(height: 4),
            Text(
              '${(playlist.userProgress * 100).toInt()}% completed',
              style: TextStyles.inter(
                fontSize: 10,
                color: AppColors.neonCyan,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}