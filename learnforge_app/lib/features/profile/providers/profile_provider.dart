import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../auth/models/user_model.dart'; // ✅ your UserModel file

// --------------------
// USER PROFILE MODEL
// --------------------
class UserProfile {
  final String id;
  final String displayName;
  final String email;
  final String avatarUrl;
  final int level;
  final int experience;
  final int coins;
  final Map<String, dynamic> userData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    String? avatarUrl,
    this.level = 1,
    this.experience = 0,
    this.coins = 0,
    Map<String, dynamic>? userData,
    this.createdAt,
    this.updatedAt,
  }) : avatarUrl = avatarUrl ?? 'https://via.placeholder.com/150',
       userData = userData ?? {};

  UserProfile copyWith({
    String? id,
    String? displayName,
    String? email,
    String? avatarUrl,
    int? level,
    int? experience,
    int? coins,
    Map<String, dynamic>? userData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      coins: coins ?? this.coins,
      userData: userData ?? this.userData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// --------------------
// STATE CLASS
// --------------------
class UserProfileState {
  final UserProfile? profile;
  final bool isLoading;
  final String? error;

  const UserProfileState({this.profile, this.isLoading = false, this.error});

  UserProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? error,
  }) {
    return UserProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// --------------------
// STATE NOTIFIER
// --------------------
class UserProfileProvider extends StateNotifier<UserProfileState> {
  UserProfileProvider() : super(const UserProfileState());

  Future<void> loadUserProfile() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await Future.delayed(const Duration(seconds: 2));

      final mockProfile = UserProfile(
        id: 'U001',
        displayName: 'Narendra Patil',
        email: 'narendra@example.com',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        level: 3,
        experience: 1240,
        coins: 250,
        userData: {
          'streak': 5,
          'badges': ['Beginner', 'Fast Learner'],
        },
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(profile: mockProfile, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

// --------------------
// PROVIDERS
// --------------------
final userProfileProvider =
    StateNotifierProvider<UserProfileProvider, UserProfileState>(
      (ref) => UserProfileProvider(),
    );

// ✅ This is what your Dashboard should use
// It converts UserProfile → UserModel with your actual field names
final userProfileFutureProvider = FutureProvider<UserModel>((ref) async {
  final notifier = ref.read(userProfileProvider.notifier);

  if (notifier.state.profile == null) {
    await notifier.loadUserProfile();
  }

  final profile = notifier.state.profile!;

  return UserModel(
    id: profile.id,
    name: profile.displayName, // ✅ mapped correctly
    email: profile.email,
    avatar: profile.avatarUrl, // ✅ mapped correctly
    streakDays: profile.userData['streak'] ?? 0,
    totalXP: profile.experience,
    badges: List<String>.from(profile.userData['badges'] ?? []),
    createdAt: profile.createdAt ?? DateTime.now(),
  );
});
