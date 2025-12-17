import 'package:flutter/material.dart';
import 'package:learnforge_app/core/theme/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? videoTitle;
  final bool isYouTube;
  final bool autoPlay;

  const CourseVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.videoTitle,
    this.isYouTube = false,
    this.autoPlay = false,
  }) : super(key: key);

  @override
  State<CourseVideoPlayer> createState() => _CourseVideoPlayerState();
}

class _CourseVideoPlayerState extends State<CourseVideoPlayer> {
  late YoutubePlayerController _youtubeController;
  late VideoPlayerController _videoController;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _showControls = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    try {
      if (widget.isYouTube) {
        await _initializeYouTubePlayer();
      } else {
        await _initializeVideoPlayer();
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeYouTubePlayer() async {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId == null) throw Exception('Invalid YouTube URL');
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        mute: false,
        enableCaption: true,
        captionLanguage: 'en',
        forceHD: true,
        hideControls: false,
        controlsVisibleAtStart: true,
        useHybridComposition: true,
      ),
    );
    _youtubeController.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _youtubeController.value.isPlaying;
        });
      }
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _initializeVideoPlayer() async {
    _videoController = VideoPlayerController.network(widget.videoUrl);
    await _videoController.initialize();
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (widget.autoPlay) {
          _videoController.play();
          _isPlaying = true;
        }
      });
    }
    _videoController.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _videoController.value.isPlaying;
        });
      }
    });
  }

  void _togglePlayPause() {
    try {
      if (widget.isYouTube) {
        _isPlaying ? _youtubeController.pause() : _youtubeController.play();
      } else {
        _isPlaying ? _videoController.pause() : _videoController.play();
      }
      setState(() => _isPlaying = !_isPlaying);
    } catch (e) {
      debugPrint('Error toggling play/pause: $e');
    }
  }

  void _toggleControls() => setState(() => _showControls = !_showControls);

  void _retryLoading() {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _initializePlayer();
  }

  void _showFullScreenDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: CourseVideoPlayer(
            videoUrl: widget.videoUrl,
            videoTitle: widget.videoTitle,
            isYouTube: widget.isYouTube,
            autoPlay: true,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.isYouTube) {
      _youtubeController.dispose();
    } else {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          _buildPlayerContent(),
          if (_isLoading && !_hasError) _buildLoadingIndicator(),
          if (_hasError) _buildErrorState(),
          if (_showControls && !_isLoading && !_hasError)
            _buildControlsOverlay(),
          if (!_isLoading && !_hasError)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleControls,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildPlayerContent() {
    if (_hasError) {
      return Container(color: AppColors.dark800, child: const Center());
    }
    if (widget.isYouTube) {
      return YoutubePlayer(
        controller: _youtubeController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.neonCyan,
        progressColors: ProgressBarColors(
          playedColor: AppColors.neonCyan,
          handleColor: AppColors.neonPurple,
          bufferedColor: AppColors.neonPurple.withOpacity(0.3),
          backgroundColor: Colors.white24,
        ),
        onReady: () => setState(() => _isLoading = false),
        onEnded: (error) => setState(() {
          _hasError = true;
          _isLoading = false;
        }),
      );
    } else {
      return _videoController.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            )
          : Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.neonCyan),
              ),
            );
    }
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.neonCyan),
            const SizedBox(height: 16),
            Text(
              widget.isYouTube
                  ? 'Loading YouTube video...'
                  : 'Loading video...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: AppColors.dark800,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: AppColors.neonPink),
              const SizedBox(height: 16),
              Text(
                'Failed to load video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your connection and try again',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.neonPurple, AppColors.neonPink],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  child: InkWell(
                    onTap: _retryLoading,
                    borderRadius: BorderRadius.circular(22),
                    child: const Center(
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Top Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.isYouTube
                            ? Icons.play_circle_filled
                            : Icons.videocam,
                        color: AppColors.neonCyan,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.isYouTube ? 'YouTube' : 'Video',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.fullscreen, color: Colors.white),
                  onPressed: _showFullScreenDialog,
                ),
              ],
            ),
          ),

          const Spacer(),

          // Bottom Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (widget.videoTitle != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      widget.videoTitle!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Row(
                  children: [
                    // Play/Pause Button
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.neonPurple.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonPurple.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Progress and Time (for non-YouTube videos)
                    if (!widget.isYouTube &&
                        _videoController.value.isInitialized)
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              _formatDuration(_videoController.value.position),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Expanded(
                              child: VideoProgressIndicator(
                                _videoController,
                                allowScrubbing: true,
                                colors: const VideoProgressColors(
                                  playedColor: AppColors.neonCyan,
                                  bufferedColor: AppColors.neonPurple,
                                  backgroundColor: Colors.white24,
                                ),
                              ),
                            ),
                            Text(
                              _formatDuration(_videoController.value.duration),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }
}
