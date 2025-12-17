class YouTubePlaylist {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelTitle;
  final int videoCount;
  final String playlistUrl;
  final double userProgress;
  final String category;

  final List<YouTubeVideo> videos; // NEW FIELD

  YouTubePlaylist({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.videoCount,
    required this.playlistUrl,
    required this.category,
    required this.videos,
    this.userProgress = 0.0,
  });
}

class YouTubeVideo {
  final String videoId;
  final String title;
  final String thumbnail;

  YouTubeVideo({
    required this.videoId,
    required this.title,
    required this.thumbnail,
  });
}

// Hardcoded YouTube playlists from your links
final youtubePlaylists = [
  // ----------------------------------
  // Your DSA Playlist With Videos
  // ----------------------------------
  YouTubePlaylist(
    id: '5',
    title: 'DSA Complete Course',
    description: 'Data Structures and Algorithms complete course',
    thumbnailUrl: 'https://img.youtube.com/vi/z9bZufPHFLU/maxresdefault.jpg',
    channelTitle: 'Love Babbar',
    videoCount: 6,
    playlistUrl:
        'https://www.youtube.com/playlist?list=PLDzeHZWIZsTryvtXdMr6rPh4IDexB5NIA',
    category: 'dsa',
    userProgress: 0.5,

    videos: [
      YouTubeVideo(
        videoId: 'yjdQHb2elqI',
        title: 'Lesson 1 — DSA Introduction',
        thumbnail: 'https://img.youtube.com/vi/yjdQHb2elqI/hqdefault.jpg',
      ),
      YouTubeVideo(
        videoId: 'uULy2rc6YDc',
        title: 'Lesson 2 — Time Complexity Basics',
        thumbnail: 'https://img.youtube.com/vi/uULy2rc6YDc/hqdefault.jpg',
      ),
      YouTubeVideo(
        videoId: 'uNZwUdfU43Q',
        title: 'Lesson 3 — Space Complexity & Analysis',
        thumbnail: 'https://img.youtube.com/vi/uNZwUdfU43Q/hqdefault.jpg',
      ),
      YouTubeVideo(
        videoId: 'V0IgCltYgg4',
        title: 'Lesson 4 — Recursion Explained',
        thumbnail: 'https://img.youtube.com/vi/V0IgCltYgg4/hqdefault.jpg',
      ),
      YouTubeVideo(
        videoId: 'gLptmcuCx6Q',
        title: 'Lesson 5 — Arrays in DSA',
        thumbnail: 'https://img.youtube.com/vi/gLptmcuCx6Q/hqdefault.jpg',
      ),
      YouTubeVideo(
        videoId: 'GqtyVD-x_jY',
        title: 'Lesson 6 — Searching Algorithms',
        thumbnail: 'https://img.youtube.com/vi/GqtyVD-x_jY/hqdefault.jpg',
      ),
    ],
  ),

  // ----------------------------------
  // Other playlists — must include videos: []
  // ----------------------------------
  YouTubePlaylist(
    id: '1',
    title: 'C++ Placement Course',
    description: 'Complete C++ programming course for placements',
    thumbnailUrl: 'https://img.youtube.com/vi/z9bZufPHFLU/maxresdefault.jpg',
    channelTitle: 'Apna College',
    videoCount: 50,
    playlistUrl:
        'https://www.youtube.com/playlist?list=PLfqMhTWNBTe0gqgFk-CUE-ktO5Cek1GdP',
    category: 'placements',
    userProgress: 0.3,
    videos: [], // REQUIRED
  ),

  // Add your others like this…
];
