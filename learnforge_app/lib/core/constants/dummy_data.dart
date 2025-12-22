import 'package:uuid/uuid.dart';
import '../../features/arena/models/challenge_model.dart';
import '../../features/chat/models/message_model.dart';
import '../../features/todo/models/todo_model.dart';
import '../../features/notifications/models/notification_model.dart';
import '../../features/courses/models/course_model.dart';
import '../../features/courses/models/chapter_model.dart';

const uuid = Uuid();

class DummyData {
  // ---------------------------------------------------
  // COURSES (WITH CHAPTERS + LESSONS)
  // ---------------------------------------------------

  static List<Course> getCourses() {
    return [
      Course(
        id: uuid.v4(),
        title: 'Flutter Masterclass',
        description: 'Learn Flutter from scratch and build production apps.',
        instructor: 'Sarah Chen',
        instructorImage: 'https://via.placeholder.com/40?text=SC',
        thumbnail: 'https://via.placeholder.com/300x200?text=Flutter',
        rating: 4.8,
        totalRatings: 1250,
        enrolledCount: 5420,
        level: 'Intermediate',
        duration: 40,
        totalLessons: 3,
        price: 2999.0,
        isFree: false,
        isFeatured: true,
        categories: ['Flutter', 'Mobile', 'Dart'],
        learningObjectives: [
          'Build production-ready Flutter apps.',
          'Master state management.',
          'Understand Flutter architecture.',
        ],
        lessons: getFlutterLessons(),
        chapters: getFlutterChapters(),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        language: 'English',
        subtitle: 'Complete Flutter development course',
        prerequisites: ['Basic programming knowledge'],
      ),

      Course(
        id: uuid.v4(),
        title: 'Web Development Bootcamp',
        description: 'Master modern web development with React and Node.js.',
        instructor: 'Alex Kumar',
        instructorImage: 'https://via.placeholder.com/40?text=AK',
        thumbnail: 'https://via.placeholder.com/300x200?text=Web+Dev',
        rating: 4.6,
        totalRatings: 980,
        enrolledCount: 3890,
        level: 'Beginner',
        duration: 50,
        totalLessons: 3,
        price: 0.0,
        isFree: true,
        isFeatured: true,
        categories: ['React', 'JavaScript', 'Web'],
        learningObjectives: [
          'Build modern web applications.',
          'Learn React and Node.js.',
          'Deploy full-stack apps.',
        ],
        lessons: getWebLessons(),
        chapters: getWebChapters(),
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now(),
        language: 'English',
      ),

      Course(
        id: uuid.v4(),
        title: 'Data Science Essentials',
        description: 'Python, ML, and data analysis for beginners.',
        instructor: 'Dr. Priya Patel',
        instructorImage: 'https://via.placeholder.com/40?text=PP',
        thumbnail: 'https://via.placeholder.com/300x200?text=Data+Science',
        rating: 4.7,
        totalRatings: 1150,
        enrolledCount: 4230,
        level: 'Advanced',
        duration: 35,
        totalLessons: 3,
        price: 3999.0,
        isFree: false,
        isFeatured: false,
        categories: ['Python', 'ML', 'Data'],
        learningObjectives: [
          'Master Python for data science.',
          'Learn machine learning basics.',
          'Analyze real-world datasets.',
        ],
        lessons: getDataLessons(),
        chapters: getDataChapters(),
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now(),
        language: 'English',
        prerequisites: ['Basic Python knowledge'],
      ),
    ];
  }

  // ---------------------------------------------------
  // FLUTTER COURSE — CHAPTERS + LESSONS
  // ---------------------------------------------------

  static List<ChapterModel> getFlutterChapters() {
    return [
      ChapterModel(
        id: 'chapter_1',
        title: 'Introduction to Flutter',
        description: 'Setup and overview.',
        orderIndex: 1,
        totalLessons: 2,
        completedLessons: 2,
        estimatedMinutes: 60,
        isLocked: false,
        lessonIds: ['flutter_l1', 'flutter_l2'],
      ),
      ChapterModel(
        id: 'chapter_2',
        title: 'Flutter Basics',
        description: 'Widgets and layouts.',
        orderIndex: 2,
        totalLessons: 1,
        completedLessons: 0,
        estimatedMinutes: 40,
        isLocked: false,
        lessonIds: ['flutter_l3'],
      ),
    ];
  }

  static List<Lesson> getFlutterLessons() {
    return [
      Lesson(
        id: 'flutter_l1',
        title: 'Getting Started with Flutter',
        description: 'Intro, setup, tools.',
        videoUrl: 'https://www.youtube.com/watch?v=1xipg02wu8s',
        thumbnail: 'https://via.placeholder.com/200x120?text=Flutter+1',
        duration: 25,
        isPreview: true,
        isCompleted: true,
        resources: ['Setup Guide'],
        chapterId: 'chapter_1',
      ),
      Lesson(
        id: 'flutter_l2',
        title: 'Widgets & Layouts',
        description: 'Understanding core widgets.',
        videoUrl: 'https://www.youtube.com/watch?v=1xipg02wu8s',
        thumbnail: 'https://via.placeholder.com/200x120?text=Flutter+2',
        duration: 35,
        isPreview: true,
        isCompleted: true,
        resources: ['Widget Cheat Sheet'],
        chapterId: 'chapter_1',
      ),
      Lesson(
        id: 'flutter_l3',
        title: 'State Management Basics',
        description: 'Provider, setState, BLoC.',
        videoUrl: 'https://www.youtube.com/watch?v=1xipg02wu8s',
        thumbnail: 'https://via.placeholder.com/200x120?text=Flutter+3',
        duration: 40,
        isPreview: false,
        isCompleted: false,
        resources: ['State Mgmt Guide'],
        chapterId: 'chapter_2',
      ),
    ];
  }

  // ---------------------------------------------------
  // WEB DEVELOPMENT — CHAPTERS + LESSONS
  // ---------------------------------------------------

  static List<ChapterModel> getWebChapters() {
    return [
      ChapterModel(
        id: 'web_c1',
        title: 'HTML & CSS Basics',
        description: 'Learn structure and styling.',
        orderIndex: 1,
        totalLessons: 1,
        completedLessons: 1,
        estimatedMinutes: 30,
        isLocked: false,
        lessonIds: ['web_l1'],
      ),
      ChapterModel(
        id: 'web_c2',
        title: 'JavaScript Essentials',
        description: 'Variables, loops & functions.',
        orderIndex: 2,
        totalLessons: 1,
        completedLessons: 0,
        estimatedMinutes: 35,
        isLocked: false,
        lessonIds: ['web_l2'],
      ),
      ChapterModel(
        id: 'web_c3',
        title: 'React Basics',
        description: 'Component-based UI.',
        orderIndex: 3,
        totalLessons: 1,
        completedLessons: 0,
        estimatedMinutes: 40,
        isLocked: false,
        lessonIds: ['web_l3'],
      ),
    ];
  }

  static List<Lesson> getWebLessons() {
    return [
      Lesson(
        id: 'web_l1',
        title: 'HTML & CSS Crash Course',
        description: 'Learn basic web page building.',
        videoUrl: 'https://www.youtube.com/watch?v=1Rs2ND1ryYc',
        thumbnail: 'https://via.placeholder.com/200x120?text=Web+1',
        duration: 30,
        isPreview: true,
        isCompleted: true,
        resources: ['HTML Guide'],
        chapterId: 'web_c1',
      ),
      Lesson(
        id: 'web_l2',
        title: 'JavaScript Tutorial',
        description: 'Learn JS from scratch.',
        videoUrl: 'https://www.youtube.com/watch?v=PkZNo7MFNFg',
        thumbnail: 'https://via.placeholder.com/200x120?text=Web+2',
        duration: 40,
        isPreview: false,
        isCompleted: false,
        resources: ['JS Basics'],
        chapterId: 'web_c2',
      ),
      Lesson(
        id: 'web_l3',
        title: 'React Basics',
        description: 'Intro to React components.',
        videoUrl: 'https://www.youtube.com/watch?v=bMknfKXIFA8',
        thumbnail: 'https://via.placeholder.com/200x120?text=Web+3',
        duration: 50,
        isPreview: false,
        isCompleted: false,
        resources: ['React Docs'],
        chapterId: 'web_c3',
      ),
    ];
  }

  // ---------------------------------------------------
  // DATA SCIENCE — CHAPTERS + LESSONS
  // ---------------------------------------------------

  static List<ChapterModel> getDataChapters() {
    return [
      ChapterModel(
        id: 'data_c1',
        title: 'Python Fundamentals',
        description: 'Variables, loops & basics.',
        orderIndex: 1,
        totalLessons: 1,
        completedLessons: 0,
        estimatedMinutes: 25,
        lessonIds: ['data_l1'],
      ),
      ChapterModel(
        id: 'data_c2',
        title: 'Data Analysis with Pandas',
        description: 'DataFrames & operations.',
        orderIndex: 2,
        totalLessons: 1,
        completedLessons: 0,
        estimatedMinutes: 35,
        lessonIds: ['data_l2'],
      ),
      ChapterModel(
        id: 'data_c3',
        title: 'Machine Learning Basics',
        description: 'Regression & classification.',
        orderIndex: 3,
        totalLessons: 1,
        completedLessons: 0,
        estimatedMinutes: 45,
        lessonIds: ['data_l3'],
      ),
    ];
  }

  static List<Lesson> getDataLessons() {
    return [
      Lesson(
        id: 'data_l1',
        title: 'Python Basics',
        description: 'Learn syntax & structures.',
        videoUrl: 'https://www.youtube.com/watch?v=kqtD5dpn9C8',
        thumbnail: 'https://via.placeholder.com/200x120?text=Data+1',
        duration: 30,
        isPreview: true,
        isCompleted: false,
        resources: ['Python Guide'],
        chapterId: 'data_c1',
      ),
      Lesson(
        id: 'data_l2',
        title: 'Pandas Tutorial',
        description: 'Analyze datasets.',
        videoUrl: 'https://www.youtube.com/watch?v=vYX1SFDp3_o',
        thumbnail: 'https://via.placeholder.com/200x120?text=Data+2',
        duration: 40,
        isPreview: false,
        isCompleted: false,
        resources: ['Pandas Notebook'],
        chapterId: 'data_c2',
      ),
      Lesson(
        id: 'data_l3',
        title: 'Machine Learning Overview',
        description: 'ML algorithms intro.',
        videoUrl: 'https://www.youtube.com/watch?v=uwizYVeG6MI',
        thumbnail: 'https://via.placeholder.com/200x120?text=Data+3',
        duration: 45,
        isPreview: false,
        isCompleted: false,
        resources: ['ML Cheat Sheet'],
        chapterId: 'data_c3',
      ),
    ];
  }

  // ---------------------------------------------------
  // ARENA CHALLENGES
  // ---------------------------------------------------

  static List<ChallengeModel> getChallenges() {
    final now = DateTime.now();

    return [
      ChallengeModel(
        id: uuid.v4(),
        title: 'Quick Sort Challenge',
        description: 'Implement quick sort in 30 minutes.',
        difficulty: 'Medium',
        points: 100,
        startTime: now,
        endTime: now.add(const Duration(hours: 1)),
        endDate: now.add(const Duration(hours: 1)),
        status: 'live',
        participantCount: 245,
        userRank: '12',
      ),
      ChallengeModel(
        id: uuid.v4(),
        title: 'React Component Marathon',
        description: 'Build 5 complex components.',
        difficulty: 'Hard',
        points: 200,
        startTime: now.add(const Duration(days: 1)),
        endTime: now.add(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 2)),
        status: 'upcoming',
        participantCount: 189,
      ),
      ChallengeModel(
        id: uuid.v4(),
        title: 'Python Data Analysis Sprint',
        description: 'Solve Pandas data tasks.',
        difficulty: 'Easy',
        points: 50,
        startTime: now.subtract(const Duration(days: 1)),
        endTime: now.subtract(const Duration(hours: 6)),
        endDate: now.subtract(const Duration(hours: 6)),
        status: 'completed',
        participantCount: 312,
        userRank: '35',
      ),
    ];
  }

  // ---------------------------------------------------
  // LEADERBOARD
  // ---------------------------------------------------

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
        userAvatar: 'https://via.placeholder.com/40?text=YOU',
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

  // ---------------------------------------------------
  // CHAT MESSAGES
  // ---------------------------------------------------

  static List<MessageModel> getChatMessages() {
    final now = DateTime.now();

    return [
      MessageModel(
        id: uuid.v4(),
        senderId: 'mentor_1',
        senderName: 'Your Mentor',
        senderAvatar: 'https://via.placeholder.com/40?text=M',
        content: 'Hey! How’s your progress?',
        timestamp: now.subtract(const Duration(minutes: 10)),
        isUser: false,
      ),
      MessageModel(
        id: uuid.v4(),
        senderId: 'user_1',
        senderName: 'You',
        senderAvatar: 'https://via.placeholder.com/40?text=Y',
        content: 'I completed the Flutter chapter!',
        timestamp: now.subtract(const Duration(minutes: 9)),
        isUser: true,
      ),
      MessageModel(
        id: uuid.v4(),
        senderId: 'mentor_1',
        senderName: 'Your Mentor',
        senderAvatar: 'https://via.placeholder.com/40?text=M',
        content: 'Awesome! Keep it up 🔥',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isUser: false,
      ),
    ];
  }

  // ---------------------------------------------------
  // TODOS
  // ---------------------------------------------------

  static List<TodoModel> getTodos() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      TodoModel(
        id: uuid.v4(),
        title: 'Complete Flutter Chapter 5',
        description: 'Finish state management basics.',
        dueDate: today,
        priority: 'high',
        category: 'learning',
        createdAt: now.subtract(const Duration(days: 3)),
        isCompleted: false,
      ),
      TodoModel(
        id: uuid.v4(),
        title: 'Join Arena Challenge',
        description: 'Participate in Quick Sort challenge.',
        dueDate: today,
        priority: 'medium',
        category: 'practice',
        createdAt: now.subtract(const Duration(days: 1)),
        isCompleted: false,
      ),
      TodoModel(
        id: uuid.v4(),
        title: 'Review Previous Lessons',
        description: 'Go over widgets and layouts.',
        dueDate: today.add(const Duration(days: 1)),
        priority: 'medium',
        category: 'review',
        createdAt: now.subtract(const Duration(days: 2)),
        isCompleted: true,
      ),
    ];
  }

  // ---------------------------------------------------
  // NOTIFICATIONS
  // ---------------------------------------------------

  static List<NotificationModel> getNotifications() {
    final now = DateTime.now();

    return [
      NotificationModel(
        id: uuid.v4(),
        title: '🔥 Streak Extended!',
        message: 'You maintained a 5-day learning streak!',
        type: 'achievement',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: uuid.v4(),
        title: '📚 Course Update',
        message: 'New chapter added to Flutter Masterclass.',
        type: 'course',
        timestamp: now.subtract(const Duration(hours: 5)),
      ),
      NotificationModel(
        id: uuid.v4(),
        title: '⚔️ New Challenge',
        message: 'React Component Marathon starts tomorrow!',
        type: 'arena',
        timestamp: now.subtract(const Duration(hours: 12)),
      ),
      NotificationModel(
        id: uuid.v4(),
        title: '⏰ Reminder',
        message: 'Complete your daily learning goal.',
        type: 'reminder',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];
  }

  // ---------------------------------------------------
  // MOTIVATIONAL QUOTES
  // ---------------------------------------------------

  static final List<String> motivationalQuotes = [
    '🚀 Every expert was once a beginner!',
    '💪 Consistency is your superpower.',
    '🔥 Progress > Perfection.',
    '🎯 Stay focused on your goals.',
    '⚡ Learn something new today!',
    '🌟 You’re doing amazing!',
    '🏆 Keep crushing your tasks!',
    '📈 Your growth is limitless.',
  ];
}
