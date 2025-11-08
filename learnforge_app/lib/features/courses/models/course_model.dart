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
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? language; // Added: Course language
  final String? subtitle; // Added: Course subtitle/tagline
  final List<String>?
  prerequisites; // Added: What you should know before taking

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
    required this.createdAt,
    required this.updatedAt,
    this.language,
    this.subtitle,
    this.prerequisites,
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
      lessons: (json['lessons'] as List? ?? [])
          .whereType<Map<String, dynamic>>() // Added safety check
          .map((lesson) => Lesson.fromJson(lesson))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      language: json['language'],
      subtitle: json['subtitle'],
      prerequisites: json['prerequisites'] != null
          ? List<String>.from(json['prerequisites'])
          : null,
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
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (language != null) 'language': language,
      if (subtitle != null) 'subtitle': subtitle,
      if (prerequisites != null) 'prerequisites': prerequisites,
    };
  }

  // Helper methods
  String get formattedPrice => isFree ? 'Free' : '₹$price';

  String get durationText {
    if (duration < 1) return 'Less than 1 hour';
    if (duration == 1) return '1 hour';
    return '$duration hours';
  }

  String get lessonsText {
    if (totalLessons == 1) return '1 lesson';
    return '$totalLessons lessons';
  }

  // Progress calculation helper
  double calculateProgress(int completedLessons) {
    if (totalLessons == 0) return 0.0;
    return completedLessons / totalLessons;
  }

  // Check if user can access course (for premium courses)
  bool canAccess(bool hasSubscription, bool isEnrolled) {
    if (isFree) return true;
    return hasSubscription || isEnrolled;
  }

  // Copy with method for immutable updates
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
    DateTime? createdAt,
    DateTime? updatedAt,
    String? language,
    String? subtitle,
    List<String>? prerequisites,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      language: language ?? this.language,
      subtitle: subtitle ?? this.subtitle,
      prerequisites: prerequisites ?? this.prerequisites,
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnail;
  final int duration; // in minutes
  final bool isPreview;
  final bool isCompleted;
  final List<String> resources;
  final String? chapterId; // Added: Group lessons by chapters
  final int? orderIndex; // Added: Lesson order in course

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
      duration: json['duration'] ?? 0,
      isPreview: json['isPreview'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      resources: List<String>.from(json['resources'] ?? []),
      chapterId: json['chapterId'],
      orderIndex: json['orderIndex'],
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

  // Helper methods
  String get formattedDuration {
    final hours = duration ~/ 60;
    final minutes = duration % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
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

class CourseProgress {
  final String courseId;
  final int completedLessons;
  final int totalLessons;
  final double progress;
  final DateTime lastAccessed;
  final String currentLessonId;
  final Duration? currentVideoPosition; // Added: Resume video from position
  final Map<String, bool>
  completedLessonsMap; // Added: Track individual lessons

  const CourseProgress({
    required this.courseId,
    required this.completedLessons,
    required this.totalLessons,
    required this.progress,
    required this.lastAccessed,
    required this.currentLessonId,
    this.currentVideoPosition,
    this.completedLessonsMap = const {},
  });

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      courseId: json['courseId'] ?? '',
      completedLessons: json['completedLessons'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
      progress: (json['progress'] ?? 0).toDouble(),
      lastAccessed:
          DateTime.tryParse(json['lastAccessed'] ?? '') ?? DateTime.now(),
      currentLessonId: json['currentLessonId'] ?? '',
      currentVideoPosition: json['currentVideoPosition'] != null
          ? Duration(milliseconds: json['currentVideoPosition'])
          : null,
      completedLessonsMap: json['completedLessonsMap'] != null
          ? Map<String, bool>.from(json['completedLessonsMap'])
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'progress': progress,
      'lastAccessed': lastAccessed.toIso8601String(),
      'currentLessonId': currentLessonId,
      if (currentVideoPosition != null)
        'currentVideoPosition': currentVideoPosition!.inMilliseconds,
      'completedLessonsMap': completedLessonsMap,
    };
  }

  // Helper methods
  CourseProgress markLessonComplete(String lessonId) {
    final newCompletedMap = Map<String, bool>.from(completedLessonsMap);
    newCompletedMap[lessonId] = true;

    return copyWith(
      completedLessons: completedLessons + 1,
      progress: (completedLessons + 1) / totalLessons,
      completedLessonsMap: newCompletedMap,
    );
  }

  CourseProgress updateVideoPosition(Duration position) {
    return copyWith(currentVideoPosition: position);
  }

  bool isLessonCompleted(String lessonId) {
    return completedLessonsMap[lessonId] ?? false;
  }

  CourseProgress copyWith({
    String? courseId,
    int? completedLessons,
    int? totalLessons,
    double? progress,
    DateTime? lastAccessed,
    String? currentLessonId,
    Duration? currentVideoPosition,
    Map<String, bool>? completedLessonsMap,
  }) {
    return CourseProgress(
      courseId: courseId ?? this.courseId,
      completedLessons: completedLessons ?? this.completedLessons,
      totalLessons: totalLessons ?? this.totalLessons,
      progress: progress ?? this.progress,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      currentLessonId: currentLessonId ?? this.currentLessonId,
      currentVideoPosition: currentVideoPosition ?? this.currentVideoPosition,
      completedLessonsMap: completedLessonsMap ?? this.completedLessonsMap,
    );
  }
}
