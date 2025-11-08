import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learnforge_app/features/notifications/screens/notification_screen.dart';

// Auth
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';

// Dashboard
import '../features/dashboard/screens/dashboard_screen.dart';

// Courses
import '../features/courses/screens/courses_screen.dart';
import '../features/courses/screens/course_detail_screen.dart';

// Arena
import '../features/arena/screens/arena_screen.dart';
import '../features/arena/screens/challenge_detail_screen.dart';

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
    // Auth Routes
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    // Main App Routes
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),

    // Courses Routes
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

    // Arena Routes
    GoRoute(path: '/arena', builder: (context, state) => const ArenaScreen()),
    GoRoute(
      path: '/challenge/:id',
      builder: (context, state) {
        final challengeId = state.pathParameters['id'] ?? '';
        return ChallengeDetailScreen(challengeId: challengeId);
      },
    ),

    // Other Feature Routes
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

    // Redirect route for old course-detail path (if needed)
    GoRoute(
      path: '/course-detail',
      redirect: (context, state) {
        // You can redirect to courses screen or handle this case
        return '/courses';
      },
    ),
  ],

  // Error handling
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
