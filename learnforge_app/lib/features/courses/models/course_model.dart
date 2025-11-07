class CourseModel {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String thumbnail;
  final int totalChapters;
  final int completedChapters;
  final List<ChapterModel> chapters;
  final String difficulty;
  final int estimatedHours;
  final List<String> tags;
  final double rating;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.thumbnail,
    required this.totalChapters,
    this.completedChapters = 0,
    this.chapters = const [],
    this.difficulty = 'Beginner',
    this.estimatedHours = 10,
    this.tags = const [],
    this.rating = 4.5,
  });

  double get progress =>
      totalChapters > 0 ? completedChapters / totalChapters : 0;
}

class ChapterModel {
  final String id;
  final String title;
  final String videoUrl;
  final String description;
  final int durationMinutes;
  final bool isCompleted;
  final int videoProgress; // percentage

  ChapterModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.description,
    this.durationMinutes = 15,
    this.isCompleted = false,
    this.videoProgress = 0,
  });
}
