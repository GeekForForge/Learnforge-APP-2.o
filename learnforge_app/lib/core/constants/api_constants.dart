class ApiConstants {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
  static const String baseUrl = 'http://10.0.2.2:8080/api'; 
  
  // Arena Endpoints
  static const String arenaStart = '/arena/start';
  static const String arenaSubmit = '/arena/submit';
  static const String arenaLeaderboard = '/arena/leaderboard'; // or /arena-result/leaderboard
  static const String arenaStats = '/arena/stats';
}
