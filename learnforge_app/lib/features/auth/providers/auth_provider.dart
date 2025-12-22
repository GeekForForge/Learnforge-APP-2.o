// auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/user_model.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState.initial());

  // TODO: REMOVE THIS - Temporary bypass for development
  void skipAuthForDev() {
    final mockUser = UserModel(
      id: 'dev_user_123',
      name: 'Dev User',
      email: 'dev@learnforge.com',
      avatar: 'assets/images/avatar_default.png',
      createdAt: DateTime.now(),
      streakDays: 5,
      totalXP: 1250,
    );
    state = AuthState.authenticated(mockUser);
  }

  Future<void> signInWithGitHub() async {
    state = const AuthState.loading();
    try {
      // Create a GitHub provider
      final provider = GithubAuthProvider();
      
      // Sign in with Firebase
      final userCredential = await FirebaseAuth.instance.signInWithProvider(provider);
      final user = userCredential.user;

      if (user != null) {
        // Map Firebase User to App User Model
        // Note: Streak and XP would typically come from a database (Firestore)
        final appUser = UserModel(
          id: user.uid,
          name: user.displayName ?? 'Learner',
          email: user.email ?? '',
          avatar: user.photoURL ?? 'assets/images/avatar_default.png',
          createdAt: user.metadata.creationTime ?? DateTime.now(),
          streakDays: 0, // Default for new login
          totalXP: 0,    // Default for new login
        );
        state = AuthState.authenticated(appUser);
      } else {
        state = const AuthState.error("Sign in cancelled");
      }
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(e.message ?? "Authentication failed");
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  void logout() {
    state = const AuthState.initial();
  }

  void updateAvatar(String newAvatarUrl) {
    if (state is Authenticated) {
      final currentUser = (state as Authenticated).user;
      final updatedUser = currentUser.copyWith(avatar: newAvatarUrl);
      state = AuthState.authenticated(updatedUser);
    }
  }
}

