import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/core/models/profile_model.dart';
import 'package:mintrix/core/models/profile_stats_model.dart';
import 'package:mintrix/core/models/profile_detail_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ApiClient _apiClient;

  ProfileBloc({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient(),
      super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<RefreshProfile>(_onRefreshProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateStreak>(_onUpdateStreak);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());

      print('📡 Loading profile...');

      // 1. Load basic profile data
      final profileResponse = await _apiClient.get(
        ApiEndpoints.profile,
        requiresAuth: true,
      );

      print('✅ Profile response: $profileResponse');

      final profileData = profileResponse['data'] ?? profileResponse;
      final profile = ProfileModel.fromJson(profileData);

      // 2. Load profile stats (liga, xp, streak) - ✅ XP akan otomatis terupdate
      print('📡 Loading profile stats...');

      final statsResponse = await _apiClient.get(
        ApiEndpoints.profileShort,
        requiresAuth: true,
      );

      print('✅ Stats response: $statsResponse');

      final statsData = statsResponse['data']['stats'] ?? {};
      final stats = ProfileStatsModel.fromJson(statsData);

      // ✅ 3. Load profile detail (untuk personality/radar chart)
      print('📡 Loading profile detail for radar chart...');

      final detailResponse = await _apiClient.get(
        ApiEndpoints.profileDetail,
        requiresAuth: true,
      );

      print('✅ Detail response: $detailResponse');

      final detailData = detailResponse['data'] ?? {};
      final profileDetail = ProfileDetailModel.fromJson(detailData);

      emit(
        ProfileLoaded(
          id: profile.id,
          name: profile.name,
          email: profile.email,
          foto: profile.foto,
          liga: stats.liga,
          xp: stats.xp, // ✅ XP terbaru dari database
          streakCount: stats.streakCount,
          point: stats.point,
          streakActive: stats.streakActive,
          personality: profileDetail.personality,
        ),
      );

      print('🎉 Profile loaded: ${profile.name}');
      print(
        '📊 Stats: Liga=${stats.liga}, XP=${stats.xp}, Streak=${stats.streakCount}',
      );
    } catch (e) {
      print('❌ Profile error: $e');
      emit(ProfileError(_parseError(e.toString())));
    }
  }

  Future<void> _onRefreshProfile(
    RefreshProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final profileResponse = await _apiClient.get(
        ApiEndpoints.profile,
        requiresAuth: true,
      );

      final profileData = profileResponse['data'] ?? profileResponse;
      final profile = ProfileModel.fromJson(profileData);

      final statsResponse = await _apiClient.get(
        ApiEndpoints.profileShort,
        requiresAuth: true,
      );

      final statsData = statsResponse['data']['stats'] ?? {};
      final stats = ProfileStatsModel.fromJson(statsData);

      // ✅ Load detail for personality
      final detailResponse = await _apiClient.get(
        ApiEndpoints.profileDetail,
        requiresAuth: true,
      );

      final detailData = detailResponse['data'] ?? {};
      final profileDetail = ProfileDetailModel.fromJson(detailData);

      emit(
        ProfileLoaded(
          id: profile.id,
          name: profile.name,
          email: profile.email,
          foto: profile.foto,
          liga: stats.liga,
          xp: stats.xp,
          streakCount: stats.streakCount,
          point: stats.point,
          streakActive: stats.streakActive,
          personality: profileDetail.personality, // ✅ Add personality
        ),
      );
    } catch (e) {
      print('❌ Refresh profile error: $e');
      // Keep current state on error
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is! ProfileLoaded) return;

      emit(ProfileLoading());

      final response = await _apiClient.post(
        ApiEndpoints.updateProfile,
        body: {'nama': event.name, if (event.foto != null) 'foto': event.foto},
        requiresAuth: true,
      );

      final profileData = response['data'] ?? response;
      final profile = ProfileModel.fromJson(profileData);

      // Reload stats
      final statsResponse = await _apiClient.get(
        ApiEndpoints.profileShort,
        requiresAuth: true,
      );

      final statsData = statsResponse['data']['stats'] ?? {};
      final stats = ProfileStatsModel.fromJson(statsData);

      // ✅ Reload detail
      final detailResponse = await _apiClient.get(
        ApiEndpoints.profileDetail,
        requiresAuth: true,
      );

      final detailData = detailResponse['data'] ?? {};
      final profileDetail = ProfileDetailModel.fromJson(detailData);

      emit(
        ProfileLoaded(
          id: profile.id,
          name: profile.name,
          email: profile.email,
          foto: profile.foto,
          liga: stats.liga,
          xp: stats.xp,
          streakCount: stats.streakCount,
          point: stats.point,
          streakActive: stats.streakActive,
          personality: profileDetail.personality, // ✅ Add personality
        ),
      );

      print('✅ Profile updated successfully');
    } catch (e) {
      print('❌ Update profile error: $e');
      emit(ProfileError(_parseError(e.toString())));
    }
  }

  String _parseError(String error) {
    if (error.contains('Network error')) {
      return 'Koneksi internet bermasalah';
    } else if (error.contains('Token expired')) {
      return 'Sesi berakhir, silakan login kembali';
    } else if (error.contains('Exception:')) {
      return error.replaceAll('Exception:', '').trim();
    }
    return error;
  }

  Future<void> _onUpdateStreak(
    UpdateStreak event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      print('📡 Updating streak...');

      // Call PATCH /api/stats to update streak
      final response = await _apiClient.patch(
        ApiEndpoints.stats,
        body: {
          "streakCount": 1, // Increment streak by 1
          "streakActive": true, // Activate streak for today
        },
        requiresAuth: true,
      );

      print('✅ Streak update response: $response');

      // Refresh profile to get updated stats
      add(RefreshProfile());

      print('🔥 Streak updated successfully');
    } catch (e) {
      print('❌ Update streak error: $e');
      // Don't emit error, just log it
    }
  }
}
