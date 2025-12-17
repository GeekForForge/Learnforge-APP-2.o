import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/youtube_playlist_model.dart';
import 'course_provider.dart';

// Provider for user's playlists with progress
final enrolledPlaylistsProvider = Provider<List<YouTubePlaylist>>((ref) {
  final myPlaylists = ref.watch(myPlaylistsProvider);
  final playlistProgress = ref.watch(courseProvider).playlistProgress;

  return myPlaylists.map((playlist) {
    final progress = playlistProgress[playlist.id] ?? playlist.userProgress;
    return YouTubePlaylist(
      id: playlist.id,
      title: playlist.title,
      description: playlist.description,
      thumbnailUrl: playlist.thumbnailUrl,
      channelTitle: playlist.channelTitle,
      videoCount: playlist.videoCount,
      playlistUrl: playlist.playlistUrl,
      userProgress: progress,
      category: playlist.category,
      videos: playlist.videos,
    );
  }).toList();
});

// Provider for user's playlist progress
final userPlaylistProgressProvider = Provider<Map<String, double>>((ref) {
  return ref.watch(courseProvider).playlistProgress;
});

// Provider for completed playlists count
final completedPlaylistsProvider = Provider<int>((ref) {
  final progress = ref.watch(userPlaylistProgressProvider);
  return progress.values.where((p) => p >= 0.95).length;
});

// Provider for estimated total learning time (based on video count)
final totalLearningTimeProvider = Provider<String>((ref) {
  final myPlaylists = ref.watch(myPlaylistsProvider);

  // Estimate: average 10 minutes per video
  const averageMinutesPerVideo = 10;
  final totalMinutes = myPlaylists.fold(
    0,
    (sum, playlist) => sum + (playlist.videoCount * averageMinutesPerVideo),
  );

  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else {
    return '${minutes}m';
  }
});

// Provider for in-progress playlists (started but not completed)
final inProgressPlaylistsProvider = Provider<List<YouTubePlaylist>>((ref) {
  final enrolled = ref.watch(enrolledPlaylistsProvider);
  return enrolled
      .where(
        (playlist) => playlist.userProgress > 0 && playlist.userProgress < 0.95,
      )
      .toList();
});

// Provider for recently started playlists
final recentPlaylistsProvider = Provider<List<YouTubePlaylist>>((ref) {
  final enrolled = ref.watch(enrolledPlaylistsProvider);
  return enrolled
      .where((playlist) => playlist.userProgress > 0)
      .toList()
      .reversed
      .take(3)
      .toList();
});

// Provider for learning statistics
final learningStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final totalPlaylists = ref.watch(myPlaylistsProvider).length;
  final completed = ref.watch(completedPlaylistsProvider);
  final inProgress = ref.watch(inProgressPlaylistsProvider).length;
  final totalTime = ref.watch(totalLearningTimeProvider);

  return {
    'totalPlaylists': totalPlaylists,
    'completed': completed,
    'inProgress': inProgress,
    'completionRate': totalPlaylists > 0
        ? (completed / totalPlaylists) * 100
        : 0,
    'totalTime': totalTime,
  };
});
