import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learnforge_app/core/widgets/glass_morphic_card.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';
import 'package:learnforge_app/core/theme/text_styles.dart';
import 'package:learnforge_app/features/courses/models/youtube_playlist_model.dart';

class YouTubePlaylistScreen extends StatefulWidget {
  final YouTubePlaylist playlist;

  const YouTubePlaylistScreen({super.key, required this.playlist});

  @override
  State<YouTubePlaylistScreen> createState() => _YouTubePlaylistScreenState();
}

class _YouTubePlaylistScreenState extends State<YouTubePlaylistScreen> {
  late YoutubePlayerController _controller;
  late String currentVideoId;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();

    currentVideoId = widget.playlist.videos.first.videoId;

    _controller = YoutubePlayerController(
      initialVideoId: currentVideoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  /// PLAY NEXT VIDEO FROM PLAYLIST
  void playVideo(String id) {
    setState(() {
      currentVideoId = id;
      _controller.load(id);
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.dispose();
    super.dispose();
  }

  // Unused _onWillPop removed

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isFullScreen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (isFullScreen) {
          _controller.toggleFullScreenMode();
        }
      },
      child: YoutubePlayerBuilder(
        onEnterFullScreen: () {
          setState(() => isFullScreen = true);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        },
        onExitFullScreen: () {
          setState(() => isFullScreen = false);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        },

        player: YoutubePlayer(
          controller: _controller,
          progressIndicatorColor: AppColors.neonBlue,
        ),

        builder: (context, player) {
          return Scaffold(
            backgroundColor: AppColors.dark700,
            appBar: isFullScreen
                ? null
                : AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      widget.playlist.title,
                      style: TextStyles.neon(
                        glowColor: AppColors.neonBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

            body: isFullScreen
                ? player
                : Column(
                    children: [
                      /// VIDEO PLAYER SECTION
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: player,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// PLAYLIST TITLE HEADER
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Playlist", style: TextStyles.titleLarge),
                            Text(
                              widget.playlist.channelTitle,
                              style: TextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// PLAYLIST VIDEOS
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: widget.playlist.videos.length,
                          itemBuilder: (context, index) {
                            final video = widget.playlist.videos[index];
                            final isPlaying = currentVideoId == video.videoId;

                            return GlassMorphicCard(
                              margin: const EdgeInsets.only(bottom: 14),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    video.thumbnail,
                                    width: 85,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                title: Text(
                                  "Lesson ${index + 1}",
                                  style: TextStyles.bodyLarge,
                                ),
                                subtitle: Text(
                                  video.title,
                                  style: TextStyles.bodyMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                trailing: Icon(
                                  isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_fill_rounded,
                                  size: 36,
                                  color: isPlaying
                                      ? AppColors.neonBlue
                                      : Colors.white,
                                ),

                                onTap: () => playVideo(video.videoId),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
