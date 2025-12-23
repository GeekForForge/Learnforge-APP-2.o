import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Courses
import 'package:learnforge_app/features/courses/screens/course_detail_screen.dart';
import 'package:learnforge_app/features/courses/screens/courses_screen.dart';
import 'package:learnforge_app/features/notifications/screens/notification_screen.dart';

// Auth
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/onboarding/screens/set_goal_screen.dart'; // Added import

// Dashboard
import '../features/home/screens/main_screen.dart';

// Arena
import '../features/arena/screens/arena_screen.dart';
import '../features/arena/screens/challenge_detail_screen.dart';
import '../features/arena/screens/quiz_screen.dart';
import '../features/arena/screens/practice_arena_screen.dart';

// Chat
import '../features/chat/screens/chat_screen.dart';

// Todo
import '../features/todo/screens/todo_screen.dart';

// Profile
import '../features/profile/screens/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/splash',
  routes: [
    // -------------------- AUTH ROUTES --------------------
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/set-goal',
      builder: (context, state) => const SetGoalScreen(),
    ), // Added Route

    // -------------------- DASHBOARD --------------------
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const MainScreen(),
    ),

    // -------------------- COURSES --------------------
    GoRoute(
      path: '/courses',
      builder: (context, state) => const CoursesScreen(),
    ),
    GoRoute(
      path: '/course/:id',
      builder: (context, state) {
        final courseId = state.pathParameters['id'] ?? '';
        return CourseDetailScreen(courseId: courseId);
      },
    ),

    // -------------------- ARENA --------------------
    GoRoute(path: '/arena', builder: (context, state) => const ArenaScreen()),
    GoRoute(
      path: '/arena/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/arena/practice',
      builder: (context, state) => const PracticeArenaScreen(),
    ),
    GoRoute(
      path: '/challenge/:id',
      builder: (context, state) {
        final challengeId = state.pathParameters['id'] ?? '';
        return ChallengeDetailScreen(challengeId: challengeId);
      },
    ),

    // -------------------- OTHER FEATURES --------------------
    GoRoute(path: '/chat', builder: (context, state) => const ChatScreen()),
    GoRoute(path: '/todo', builder: (context, state) => const TodoScreen()),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    // DEPRECATED: Old playlist route - use /courses/:id instead
    // GoRoute(
    //   path: '/playlist/:id',
    //   builder: (context, state) {
    //     final playlistId = state.pathParameters['id'] ?? '';
    //     final playlist = youtubePlaylists.firstWhere(
    //       (p) => p.id == playlistId,
    //       orElse: () => youtubePlaylists.first,
    //     );
    //     return YouTubePlaylistScreen(playlist: playlist);
    //   },
    // ),

    // -------------------- OPTIONAL REDIRECT --------------------
    GoRoute(path: '/course-detail', redirect: (context, state) => '/courses'),
  ],

  // -------------------- ERROR HANDLING --------------------
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Page Not Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'The page you are looking for doesn\'t exist.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/dashboard'),
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    ),
  ),
);
