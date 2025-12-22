class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final int streakDays;
  final int totalXP;
  final List<String> badges;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.streakDays = 0,
    this.totalXP = 0,
    this.badges = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'streakDays': streakDays,
      'totalXP': totalXP,
      'badges': badges,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String? ?? '',
      streakDays: json['streakDays'] as int? ?? 0,
      totalXP: json['totalXP'] as int? ?? 0,
      badges: List<String>.from(json['badges'] as List? ?? []),
      createdAt: DateTime.parse(
        json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    int? streakDays,
    int? totalXP,
    List<String>? badges,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      streakDays: streakDays ?? this.streakDays,
      totalXP: totalXP ?? this.totalXP,
      badges: badges ?? this.badges,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

