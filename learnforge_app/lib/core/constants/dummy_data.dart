import 'package:uuid/uuid.dart';
import '../../features/courses/models/course_model.dart';
import '../../features/arena/models/challenge_model.dart';
import '../../features/arena/models/leaderboard_model.dart';
import '../../features/chat/models/message_model.dart';
import '../../features/todo/models/todo_model.dart';
import '../../features/notifications/models/notification_model.dart';

const uuid = Uuid();

class DummyData {
  // Courses
  static List<CourseModel> getCourses() {
    return [
      CourseModel(
        id: uuid.v4(),
        title: 'Flutter Masterclass',
        description:
            'Learn Flutter from scratch and build production-ready apps',
        instructor: 'Sarah Chen',
        thumbnail: 'https://via.placeholder.com/300x200?text=Flutter',
        totalChapters: 12,
        completedChapters: 5,
        difficulty: 'Intermediate',
        estimatedHours: 40,
        tags: ['Flutter', 'Mobile', 'Dart'],
        rating: 4.8,
        chapters: getDummyChapters(),
      ),
      CourseModel(
        id: uuid.v4(),
        title: 'Web Development Bootcamp',
        description: 'Master modern web development with React and Node.js',
        instructor: 'Alex Kumar',
        thumbnail: 'https://via.placeholder.com/300x200?text=Web+Dev',
        totalChapters: 15,
        completedChapters: 8,
        difficulty: 'Beginner',
        estimatedHours: 50,
        tags: ['React', 'JavaScript', 'Web'],
        rating: 4.6,
      ),
      CourseModel(
        id: uuid.v4(),
        title: 'Data Science Essentials',
        description: 'Python, ML, and data analysis for beginners',
        instructor: 'Dr. Priya Patel',
        thumbnail: 'https://via.placeholder.com/300x200?text=Data+Science',
        totalChapters: 10,
        completedChapters: 3,
        difficulty: 'Advanced',
        estimatedHours: 35,
        tags: ['Python', 'ML', 'Data'],
        rating: 4.7,
      ),
    ];
  }

  static List<ChapterModel> getDummyChapters() {
    return [
      ChapterModel(
        id: uuid.v4(),
        title: 'Getting Started with Flutter',
        videoUrl: 'https://www.youtube.com/embed/1xipg02wu8s',
        description: 'Introduction to Flutter and setting up your environment',
        durationMinutes: 25,
        isCompleted: true,
        videoProgress: 100,
      ),
      ChapterModel(
        id: uuid.v4(),
        title: 'Widgets and Layouts',
        videoUrl: 'https://www.youtube.com/embed/1xipg02wu8s',
        description: 'Understanding Flutter widgets and layout systems',
        durationMinutes: 35,
        isCompleted: true,
        videoProgress: 100,
      ),
      ChapterModel(
        id: uuid.v4(),
        title: 'State Management Basics',
        videoUrl: 'https://www.youtube.com/embed/1xipg02wu8s',
        description: 'Introduction to state management patterns',
        durationMinutes: 40,
        isCompleted: false,
        videoProgress: 45,
      ),
    ];
  }

  // Arena Challenges
  static List<ChallengeModel> getChallenges() {
    final now = DateTime.now();
    return [
      ChallengeModel(
        id: uuid.v4(),
        title: 'Quick Sort Challenge',
        description: 'Implement quick sort algorithm in 30 minutes',
        difficulty: 'Medium',
        points: 100,
        startTime: now,
        endTime: now.add(const Duration(hours: 1)),
        status: 'live',
        participantCount: 245,
        userRank: '12',
      ),
      ChallengeModel(
        id: uuid.v4(),
        title: 'React Component Marathon',
        description: 'Build 5 complex React components',
        difficulty: 'Hard',
        points: 200,
        startTime: now.add(const Duration(days: 1)),
        endTime: now.add(const Duration(days: 2)),
        status: 'upcoming',
        participantCount: 189,
      ),
      ChallengeModel(
        id: uuid.v4(),
        title: 'Python Data Analysis Sprint',
        description: 'Complete data analysis tasks with Pandas',
        difficulty: 'Easy',
        points: 50,
        startTime: now.subtract(const Duration(days: 1)),
        endTime: now.subtract(const Duration(hours: 6)),
        status: 'completed',
        participantCount: 312,
        userRank: '35',
      ),
    ];
  }

  static List<LeaderboardEntryModel> getLeaderboard() {
    return [
      LeaderboardEntryModel(
        rank: 1,
        userName: 'CodeMaster',
        userAvatar: 'https://via.placeholder.com/40?text=CM',
        score: 2850,
        timeSpentSeconds: 1200,
      ),
      LeaderboardEntryModel(
        rank: 2,
        userName: 'You',
        userAvatar: 'https://via.placeholder.com/40?text=You',
        score: 2650,
        timeSpentSeconds: 1450,
        isCurrentUser: true,
      ),
      LeaderboardEntryModel(
        rank: 3,
        userName: 'FlutterDev',
        userAvatar: 'https://via.placeholder.com/40?text=FD',
        score: 2420,
        timeSpentSeconds: 1680,
      ),
      LeaderboardEntryModel(
        rank: 4,
        userName: 'DataWizard',
        userAvatar: 'https://via.placeholder.com/40?text=DW',
        score: 2310,
        timeSpentSeconds: 1920,
      ),
      LeaderboardEntryModel(
        rank: 5,
        userName: 'WebNinja',
        userAvatar: 'https://via.placeholder.com/40?text=WN',
        score: 2105,
        timeSpentSeconds: 2100,
      ),
    ];
  }

  // Chat Messages
  static List<MessageModel> getChatMessages() {
    final now = DateTime.now();
    return [
      MessageModel(
        id: uuid.v4(),
        senderId: 'mentor_1',
        senderName: 'Your Mentor',
        senderAvatar: 'https://via.placeholder.com/40?text=Mentor',
        content: 'Hey! How\'s your progress on the Flutter course?',
        timestamp: now.subtract(const Duration(minutes: 10)),
        isUser: false,
      ),
      MessageModel(
        id: uuid.v4(),
        senderId: 'user_1',
        senderName: 'You',
        senderAvatar: 'https://via.placeholder.com/40?text=You',
        content:
            'I\'m doing great! Just completed the state management chapter.',
        timestamp: now.subtract(const Duration(minutes: 9)),
        isUser: true,
      ),
      MessageModel(
        id: uuid.v4(),
        senderId: 'mentor_1',
        senderName: 'Your Mentor',
        senderAvatar: 'https://via.placeholder.com/40?text=Mentor',
        content: 'Excellent! 🔥 State management is crucial. Keep it up!',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isUser: false,
      ),
    ];
  }

  // To-Dos
  static List<TodoModel> getTodos() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [
      TodoModel(
        id: uuid.v4(),
        title: 'Complete Flutter Course Chapter 5',
        description: 'Finish state management basics',
        dueDate: today,
        priority: 'high',
        category: 'learning',
        createdAt: now.subtract(const Duration(days: 3)),
        isCompleted: false,
      ),
      TodoModel(
        id: uuid.v4(),
        title: 'Join Arena Challenge',
        description: 'Participate in Quick Sort Challenge',
        dueDate: today,
        priority: 'medium',
        category: 'practice',
        createdAt: now.subtract(const Duration(days: 1)),
        isCompleted: false,
      ),
      TodoModel(
        id: uuid.v4(),
        title: 'Review Previous Lessons',
        description: 'Go over widgets and layouts',
        dueDate: today.add(const Duration(days: 1)),
        priority: 'medium',
        category: 'review',
        createdAt: now.subtract(const Duration(days: 2)),
        isCompleted: true,
      ),
      TodoModel(
        id: uuid.v4(),
        title: 'Build Mini Project',
        description: 'Create a weather app with Flutter',
        dueDate: today.add(const Duration(days: 3)),
        priority: 'high',
        category: 'practice',
        createdAt: now.subtract(const Duration(days: 5)),
        isCompleted: false,
      ),
    ];
  }

  // Notifications
  static List<NotificationModel> getNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: uuid.v4(),
        title: '🔥 Streak Extended!',
        message: 'You\'ve maintained a 5-day learning streak!',
        type: 'achievement',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: uuid.v4(),
        title: '📚 Course Update',
        message: 'New chapter added to Flutter Masterclass',
        type: 'course',
        timestamp: now.subtract(const Duration(hours: 5)),
      ),
      NotificationModel(
        id: uuid.v4(),
        title: '⚔️ Challenge Available',
        message: 'Join the new React Component Marathon',
        type: 'arena',
        timestamp: now.subtract(const Duration(hours: 12)),
      ),
      NotificationModel(
        id: uuid.v4(),
        title: '⏰ Reminder',
        message: 'Complete your daily learning goal',
        type: 'reminder',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];
  }

  static final List<String> motivationalQuotes = [
    '🚀 Every expert was once a beginner!',
    '💪 Your consistency is your superpower.',
    '🔥 Progress, not perfection.',
    '🎯 Stay focused on your goals.',
    '⚡ Learn something new today!',
    '🌟 You\'re doing amazing!',
    '🏆 Keep crushing those goals!',
    '📈 Your growth is limitless.',
  ];
}
