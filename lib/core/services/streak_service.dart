import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';

class StreakService {
  final ApiClient _apiClient;

  StreakService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Update streak status setelah user menyelesaikan aktivitas (game/AI)
  Future<bool> updateStreak() async {
    try {
      print('🔥 Updating streak via API...');

      final response = await _apiClient.put(
        ApiEndpoints.stats,
        body: {"streakActive": true},
        requiresAuth: true,
      );

      print('✅ Streak API response: $response');
      return true;
    } catch (e) {
      print('❌ Failed to update streak: $e');
      return false;
    }
  }
}
