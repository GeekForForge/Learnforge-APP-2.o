// auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/user_model.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState.initial());

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      // Simulate login delay and user retrieval
      await Future.delayed(const Duration(seconds: 2));
      final user = UserModel(
        id: '1',
        name: 'John Developer',
        email: email,
        avatar: 'https://via.placeholder.com/100?text=User',
        createdAt: DateTime.now(),
        streakDays: 5,
        totalXP: 2650,
      );
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  void logout() {
    state = const AuthState.initial();
  }
}
