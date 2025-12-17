// lib/features/courses/models/chapter_model.dart

class ChapterModel {
  final String id;
  final String title;
  final String description;
  final int orderIndex;
  final int totalLessons;
  final int completedLessons;
  final int estimatedMinutes;
  final bool isLocked;
  final List<String> lessonIds;

  const ChapterModel({
    required this.id,
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.totalLessons,
    this.completedLessons = 0,
    required this.estimatedMinutes,
    this.isLocked = false,
    this.lessonIds = const [],
  });

  /// Convert from JSON map into model
  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      orderIndex: json['orderIndex'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
      completedLessons: json['completedLessons'] ?? 0,
      estimatedMinutes: json['estimatedMinutes'] ?? 0,
      isLocked: json['isLocked'] ?? false,
      lessonIds: List<String>.from(json['lessonIds'] ?? []),
    );
  }

  /// Convert model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'orderIndex': orderIndex,
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'estimatedMinutes': estimatedMinutes,
      'isLocked': isLocked,
      'lessonIds': lessonIds,
    };
  }

  /// Calculate chapter completion percentage
  double get progress {
    if (totalLessons == 0) return 0.0;
    return completedLessons / totalLessons;
  }

  /// Whether the chapter is fully completed
  bool get isCompleted => completedLessons >= totalLessons;

  /// Convert estimated minutes → formatted duration
  String get formattedDuration {
    final hours = estimatedMinutes ~/ 60;
    final minutes = estimatedMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Text UI helper
  String get lessonsText {
    if (totalLessons == 1) return '1 lesson';
    return '$totalLessons lessons';
  }

  /// Completed lessons text
  String get completionText => '$completedLessons/$totalLessons completed';

  /// Copy model with updated fields
  ChapterModel copyWith({
    String? id,
    String? title,
    String? description,
    int? orderIndex,
    int? totalLessons,
    int? completedLessons,
    int? estimatedMinutes,
    bool? isLocked,
    List<String>? lessonIds,
  }) {
    return ChapterModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      orderIndex: orderIndex ?? this.orderIndex,
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isLocked: isLocked ?? this.isLocked,
      lessonIds: lessonIds ?? this.lessonIds,
    );
  }

  /// Mark a lesson as completed (increment count)
  ChapterModel markLessonComplete(String lessonId) {
    if (!lessonIds.contains(lessonId)) return this;

    return copyWith(completedLessons: completedLessons + 1);
  }

  /// Unlock chapter
  ChapterModel unlock() {
    return copyWith(isLocked: false);
  }

  @override
  String toString() {
    return 'ChapterModel(id: $id, title: $title, progress: ${(progress * 100).toStringAsFixed(1)}%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChapterModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.orderIndex == orderIndex &&
        other.totalLessons == totalLessons &&
        other.completedLessons == completedLessons &&
        other.estimatedMinutes == estimatedMinutes &&
        other.isLocked == isLocked;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        orderIndex.hashCode ^
        totalLessons.hashCode ^
        completedLessons.hashCode ^
        estimatedMinutes.hashCode ^
        isLocked.hashCode;
  }
}
