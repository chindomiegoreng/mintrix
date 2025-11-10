class ApiEndpoints {
  // Base URLs
  static const String mintrixBaseUrl = 'https://mintrix-api-service.vercel.app';
  static const String dinoBaseUrl = 'https://dino.yogawanadityapratama.com';

  // Auth Endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';

  // Personalization Endpoints
  static const String personalization = '/api/personalization';
  static const String getPersonalization = '/api/personalization';

  // Profile Endpoints
  static const String profile = '/api/profile';
  static const String profileShort = '/api/profile/short';
  static const String profileDetail = '/api/profile/detail';
  static const String updateProfile = '/api/profile/update';
  static const String generateQRCode =
      '/api/profile/generate/qrcode';

  // Game/Module Endpoints
  static const String modules = '/api/modules';
  static const String lessons = '/api/lessons';
  static const String progress = '/api/progress';

  // AI Chat Endpoints (Dino)
  static const String chat = '/api/chat';
  static const String chatHistory = '/api/chat/history';

  static const String dailyNotes = '/api/notes';
  static String dailyNoteById(String id) => '/api/notes/$id';

  static const String leaderboard = '/api/leaderboard';

  static const String mission = '/api/mission';
}
