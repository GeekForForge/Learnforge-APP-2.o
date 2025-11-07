class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final int points;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // 'live', 'upcoming', 'completed'
  final int participantCount;
  final String? userRank;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.points,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.participantCount = 0,
    this.userRank,
  });
}

class LeaderboardEntryModel {
  final int rank;
  final String userName;
  final String userAvatar;
  final int score;
  final int timeSpentSeconds;
  final bool isCurrentUser;

  LeaderboardEntryModel({
    required this.rank,
    required this.userName,
    required this.userAvatar,
    required this.score,
    required this.timeSpentSeconds,
    this.isCurrentUser = false,
  });
}
