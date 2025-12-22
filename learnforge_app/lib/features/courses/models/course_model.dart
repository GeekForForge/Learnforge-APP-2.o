// lib/features/courses/models/course_model.dart

import 'package:learnforge_app/features/courses/models/chapter_model.dart';

/// Lesson model (self-contained here; if you already have lesson_model.dart,
/// you can remove this class and import it instead)
class Lesson {
  final String id;
  final String title;
  final String description;
  final String videoUrl; // YouTube URL or direct video link
  final String thumbnail;
  final int duration; // minutes
  final bool isPreview;
  final bool isCompleted;
  final List<String> resources;
  final String? chapterId;
  final int? orderIndex;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnail,
    required this.duration,
    required this.isPreview,
    required this.isCompleted,
    required this.resources,
    this.chapterId,
    this.orderIndex,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      duration: (json['duration'] ?? 0) as int,
      isPreview: json['isPreview'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      resources: List<String>.from(json['resources'] ?? []),
      chapterId: json['chapterId'],
      orderIndex: json['orderIndex'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'duration': duration,
      'isPreview': isPreview,
      'isCompleted': isCompleted,
      'resources': resources,
      if (chapterId != null) 'chapterId': chapterId,
      if (orderIndex != null) 'orderIndex': orderIndex,
    };
  }
}

class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String instructorImage;
  final String thumbnail;
  final double rating;
  final int totalRatings;
  final int enrolledCount;
  final String level;
  final int duration; // in hours
  final int totalLessons;
  final double price;
  final bool isFree;
  final bool isFeatured;
  final List<String> categories;
  final List<String> learningObjectives;
  final List<Lesson> lessons;
  final List<ChapterModel> chapters; // ADDED chapters
  final DateTime createdAt;
  final DateTime updatedAt;

  // Optional / new fields
  final String? language;
  final String? subtitle;
  final List<String>? prerequisites;
  final String? youtubePlaylistUrl;
  final String? firstVideoId;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.instructorImage,
    required this.thumbnail,
    required this.rating,
    required this.totalRatings,
    required this.enrolledCount,
    required this.level,
    required this.duration,
    required this.totalLessons,
    required this.price,
    required this.isFree,
    required this.isFeatured,
    required this.categories,
    required this.learningObjectives,
    required this.lessons,
    required this.chapters,
    required this.createdAt,
    required this.updatedAt,
    this.language,
    this.subtitle,
    this.prerequisites,
    this.youtubePlaylistUrl,
    this.firstVideoId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructor: json['instructor'] ?? '',
      instructorImage: json['instructorImage'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalRatings: json['totalRatings'] ?? 0,
      enrolledCount: json['enrolledCount'] ?? 0,
      level: json['level'] ?? 'Beginner',
      duration: json['duration'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      isFree: json['isFree'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      categories: List<String>.from(json['categories'] ?? []),
      learningObjectives: List<String>.from(json['learningObjectives'] ?? []),

      // parse lessons
      lessons: (json['lessons'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((lesson) => Lesson.fromJson(lesson))
          .toList(),

      // parse chapters
      chapters: (json['chapters'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((c) => ChapterModel.fromJson(c))
          .toList(),

      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),

      language: json['language'],
      subtitle: json['subtitle'],
      prerequisites: json['prerequisites'] != null
          ? List<String>.from(json['prerequisites'])
          : null,
      youtubePlaylistUrl: json['youtubePlaylistUrl'],
      firstVideoId: json['firstVideoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'instructorImage': instructorImage,
      'thumbnail': thumbnail,
      'rating': rating,
      'totalRatings': totalRatings,
      'enrolledCount': enrolledCount,
      'level': level,
      'duration': duration,
      'totalLessons': totalLessons,
      'price': price,
      'isFree': isFree,
      'isFeatured': isFeatured,
      'categories': categories,
      'learningObjectives': learningObjectives,

      // lessons and chapters (non-nullable lists)
      'lessons': lessons.map((l) => l.toJson()).toList(),
      'chapters': chapters.map((c) => c.toJson()).toList(),

      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),

      if (language != null) 'language': language,
      if (subtitle != null) 'subtitle': subtitle,
      if (prerequisites != null) 'prerequisites': prerequisites,
      if (youtubePlaylistUrl != null) 'youtubePlaylistUrl': youtubePlaylistUrl,
      if (firstVideoId != null) 'firstVideoId': firstVideoId,
    };
  }
}
