class ApiConstants {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
  static const String baseUrl = 'http://10.0.2.2:8080/api'; 
  
  // Arena Endpoints
  static const String arenaStart = '/arena/start';
  static const String arenaSubmit = '/arena/submit';
  static const String arenaLeaderboard = '/arena/leaderboard';
  static const String arenaStats = '/arena/stats';
  
  // Course Endpoints
  static const String courses = '/courses';
  static const String courseById = '/courses'; // Will append /{id}
  static const String courseSearch = '/courses/search';
}
