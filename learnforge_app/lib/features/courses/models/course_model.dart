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

  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnail,
    int? duration,
    bool? isPreview,
    bool? isCompleted,
    List<String>? resources,
    String? chapterId,
    int? orderIndex,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnail: thumbnail ?? this.thumbnail,
      duration: duration ?? this.duration,
      isPreview: isPreview ?? this.isPreview,
      isCompleted: isCompleted ?? this.isCompleted,
      resources: resources ?? this.resources,
      chapterId: chapterId ?? this.chapterId,
      orderIndex: orderIndex ?? this.orderIndex,
    );
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
      id: (json['courseId'] ?? json['id'] ?? '').toString(),
      title: json['courseTitle'] ?? json['title'] ?? '',
      description: json['courseDescription'] ?? json['description'] ?? '',
      instructor: json['instructor'] ?? 'LearnForge Instructor',
      instructorImage: json['instructorImage'] ?? '',
      thumbnail: json['courseThumbnail'] ?? json['thumbnail'] ?? 'https://via.placeholder.com/300x200?text=Course',
      rating: (json['rating'] ?? 0).toDouble(),
      totalRatings: json['totalRatings'] ?? 0,
      enrolledCount: json['enrolledCount'] ?? 0,
      level: json['level'] ?? 'Beginner',
      duration: json['duration'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
      price: (json['coursePrice'] ?? json['price'] ?? 0).toDouble(),
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



  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? instructor,
    String? instructorImage,
    String? thumbnail,
    double? rating,
    int? totalRatings,
    int? enrolledCount,
    String? level,
    int? duration,
    int? totalLessons,
    double? price,
    bool? isFree,
    bool? isFeatured,
    List<String>? categories,
    List<String>? learningObjectives,
    List<Lesson>? lessons,
    List<ChapterModel>? chapters,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? language,
    String? subtitle,
    List<String>? prerequisites,
    String? youtubePlaylistUrl,
    String? firstVideoId,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      instructorImage: instructorImage ?? this.instructorImage,
      thumbnail: thumbnail ?? this.thumbnail,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      enrolledCount: enrolledCount ?? this.enrolledCount,
      level: level ?? this.level,
      duration: duration ?? this.duration,
      totalLessons: totalLessons ?? this.totalLessons,
      price: price ?? this.price,
      isFree: isFree ?? this.isFree,
      isFeatured: isFeatured ?? this.isFeatured,
      categories: categories ?? this.categories,
      learningObjectives: learningObjectives ?? this.learningObjectives,
      lessons: lessons ?? this.lessons,
      chapters: chapters ?? this.chapters,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      language: language ?? this.language,
      subtitle: subtitle ?? this.subtitle,
      prerequisites: prerequisites ?? this.prerequisites,
      youtubePlaylistUrl: youtubePlaylistUrl ?? this.youtubePlaylistUrl,
      firstVideoId: firstVideoId ?? this.firstVideoId,
    );
  }
}
