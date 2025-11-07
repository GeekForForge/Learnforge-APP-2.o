import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/constants/dummy_data.dart';

final challengesProvider = FutureProvider((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return DummyData.getChallenges();
});

final leaderboardProvider = FutureProvider((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return DummyData.getLeaderboard();
});

final selectedTabProvider = StateProvider<String>((ref) => 'live');

// 🔥 New: Only active/live challenges
final activeChallengesProvider = FutureProvider((ref) async {
  await Future.delayed(const Duration(milliseconds: 800));
  final allChallenges = DummyData.getChallenges();
  return allChallenges.where((c) => c.status.toLowerCase() == 'live').toList();
});
