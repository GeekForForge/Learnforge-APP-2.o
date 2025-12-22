import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/youtube_playlist_model.dart';

class CourseState {
  final List<YouTubePlaylist> playlists;
  final List<YouTubePlaylist> featuredPlaylists;
  final List<YouTubePlaylist> myPlaylists;
  final Map<String, double> playlistProgress;
  final bool isLoading;
  final String? error;
  final String selectedCategory;

  const CourseState({
    this.playlists = const [],
    this.featuredPlaylists = const [],
    this.myPlaylists = const [],
    this.playlistProgress = const {},
    this.isLoading = false,
    this.error,
    this.selectedCategory = 'All',
  });

  CourseState copyWith({
    List<YouTubePlaylist>? playlists,
    List<YouTubePlaylist>? featuredPlaylists,
    List<YouTubePlaylist>? myPlaylists,
    Map<String, double>? playlistProgress,
    bool? isLoading,
    String? error,
    String? selectedCategory,
  }) {
    return CourseState(
      playlists: playlists ?? this.playlists,
      featuredPlaylists: featuredPlaylists ?? this.featuredPlaylists,
      myPlaylists: myPlaylists ?? this.myPlaylists,
      playlistProgress: playlistProgress ?? this.playlistProgress,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class CourseProvider extends Notifier<CourseState> {
  @override
  CourseState build() {
    // Load playlists when provider is created
    loadPlaylists();
    return const CourseState();
  }

  Future<void> loadPlaylists() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Use our YouTube playlists data
      final featuredPlaylists = youtubePlaylists
          .where(
            (playlist) => playlist.userProgress > 0.3,
          ) // Featured if some progress
          .toList();

      // For demo, mark first 2 playlists as "my playlists"
      final myPlaylists = youtubePlaylists.take(2).toList();

      state = state.copyWith(
        playlists: youtubePlaylists,
        featuredPlaylists: featuredPlaylists,
        myPlaylists: myPlaylists,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load playlists: $e',
        isLoading: false,
      );
    }
  }

  Future<void> loadMyPlaylists() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Simulate API call for user's playlists
      await Future.delayed(const Duration(seconds: 1));

      // For demo, take first 2 playlists as user's playlists
      final myPlaylists = youtubePlaylists.take(2).toList();

      state = state.copyWith(myPlaylists: myPlaylists, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load your playlists: $e',
        isLoading: false,
      );
    }
  }

  Future<void> addToMyPlaylists(String playlistId) async {
    try {
      final playlist = youtubePlaylists.firstWhere((p) => p.id == playlistId);
      final updatedMyPlaylists = [...state.myPlaylists, playlist];

      state = state.copyWith(myPlaylists: updatedMyPlaylists);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      state = state.copyWith(error: 'Failed to add playlist: $e');
    }
  }

  Future<void> updatePlaylistProgress(
    String playlistId,
    double progress,
  ) async {
    try {
      final updatedProgress = Map<String, double>.from(state.playlistProgress);
      updatedProgress[playlistId] = progress;

      state = state.copyWith(playlistProgress: updatedProgress);

      // Simulate API call to save progress
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      state = state.copyWith(error: 'Failed to update progress: $e');
    }
  }

  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  List<YouTubePlaylist> get filteredPlaylists {
    if (state.selectedCategory == 'All') {
      return state.playlists;
    }
    return state.playlists
        .where((playlist) => playlist.category == state.selectedCategory)
        .toList();
  }

  // Get progress for a specific playlist
  double getPlaylistProgress(String playlistId) {
    return state.playlistProgress[playlistId] ?? 0.0;
  }

  // Mark playlist as started (add some progress)
  Future<void> startPlaylist(String playlistId) async {
    await updatePlaylistProgress(playlistId, 0.1); // 10% when started
  }

  // Mark playlist as completed
  Future<void> completePlaylist(String playlistId) async {
    await updatePlaylistProgress(playlistId, 1.0); // 100% when completed
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Updated Providers
final courseProvider = NotifierProvider<CourseProvider, CourseState>(
  () => CourseProvider(),
);

final featuredPlaylistsProvider = Provider<List<YouTubePlaylist>>((ref) {
  return ref.watch(courseProvider).featuredPlaylists;
});

final myPlaylistsProvider = Provider<List<YouTubePlaylist>>((ref) {
  return ref.watch(courseProvider).myPlaylists;
});

final filteredPlaylistsProvider = Provider<List<YouTubePlaylist>>((ref) {
  final courseState = ref.watch(courseProvider);
  if (courseState.selectedCategory == 'All') {
    return courseState.playlists;
  }
  return courseState.playlists
      .where((playlist) => playlist.category == courseState.selectedCategory)
      .toList();
});

// Provider for YouTube playlists (direct access)
final youtubePlaylistsProvider = Provider<List<YouTubePlaylist>>((ref) {
  return youtubePlaylists;
});

// Provider for search functionality
final courseSearchProvider = StateProvider<String>((ref) => '');

// Provider for selected playlist
final selectedPlaylistProvider = StateProvider<YouTubePlaylist?>((ref) => null);
