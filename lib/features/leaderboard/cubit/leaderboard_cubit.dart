import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/core/models/leaderboard_models.dart';
import 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final ApiClient _apiClient;

  LeaderboardCubit({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(),
        super(LeaderboardInitial());

  // ✅ Fetch leaderboard data
  Future<void> loadLeaderboard() async {
    try {
      emit(LeaderboardLoading());

      final response = await _apiClient.get(
        ApiEndpoints.leaderboard,
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        final users = data.map((json) => LeaderboardUser.fromJson(json)).toList();

        // ✅ Optional: Cari ranking user yang login
        // Jika API mengembalikan info user, bisa ditambahkan logic di sini

        emit(LeaderboardLoaded(users: users));
        print('✅ Loaded ${users.length} leaderboard users');
      } else {
        emit(const LeaderboardError('Data leaderboard tidak tersedia'));
      }
    } catch (e) {
      emit(LeaderboardError('Gagal memuat leaderboard: ${e.toString()}'));
      print('❌ Error loading leaderboard: $e');
    }
  }

  // ✅ Refresh leaderboard
  Future<void> refreshLeaderboard() async {
    await loadLeaderboard();
  }

  @override
  Future<void> close() {
    _apiClient.dispose();
    return super.close();
  }
}