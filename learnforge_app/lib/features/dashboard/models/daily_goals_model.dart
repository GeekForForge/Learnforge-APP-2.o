class DailyGoals {
  final int watchTimeMinutes;
  final int questionCount;
  final bool quizEnabled;

  const DailyGoals({
    required this.watchTimeMinutes,
    required this.questionCount,
    required this.quizEnabled,
  });

  // Default goals
  factory DailyGoals.defaultGoals() {
    return const DailyGoals(
      watchTimeMinutes: 30,
      questionCount: 10,
      quizEnabled: false,
    );
  }

  DailyGoals copyWith({
    int? watchTimeMinutes,
    int? questionCount,
    bool? quizEnabled,
  }) {
    return DailyGoals(
      watchTimeMinutes: watchTimeMinutes ?? this.watchTimeMinutes,
      questionCount: questionCount ?? this.questionCount,
      quizEnabled: quizEnabled ?? this.quizEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'watchTimeMinutes': watchTimeMinutes,
      'questionCount': questionCount,
      'quizEnabled': quizEnabled,
    };
  }

  factory DailyGoals.fromJson(Map<String, dynamic> json) {
    return DailyGoals(
      watchTimeMinutes: json['watchTimeMinutes'] as int,
      questionCount: json['questionCount'] as int,
      quizEnabled: json['quizEnabled'] as bool,
    );
  }
}
