import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _fotoKey = 'user_foto'; // ✅ TAMBAHKAN

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Helper to ensure _prefs is initialized
  Future<SharedPreferences> _getPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }

  // Save token and related data
  Future<bool> saveToken(
    String accessToken, {
    String? refreshToken,
    String? userId,
    String? username,
    String? foto, // ✅ TAMBAHKAN
    Duration? expiryDuration,
  }) async {
    try {
      final prefs = await _getPrefs();

      print('💾 Saving token for userId: $userId');

      // ✅ Check if userId is different from stored userId (BEFORE saving new data)
      final storedUserId = prefs.getString(_userIdKey);
      print('   Stored userId in prefs: $storedUserId');

      if (userId != null && storedUserId != null && storedUserId != userId) {
        print('🔄 New user detected! Clearing old game progress...');
        print('   Old user: $storedUserId');
        print('   New user: $userId');
        await clearGameProgress();
      } else if (userId != null && storedUserId == userId) {
        print('✅ Same user detected, keeping existing progress');
      } else {
        print('ℹ️ First time login or no stored userId');
      }

      await prefs.setString(_accessTokenKey, accessToken);

      if (refreshToken != null) {
        await prefs.setString(_refreshTokenKey, refreshToken);
      }

      if (userId != null) {
        await prefs.setString(_userIdKey, userId);
      }

      if (username != null) {
        await prefs.setString(_usernameKey, username);
      }

      if (foto != null) {
        // ✅ TAMBAHKAN
        await prefs.setString(_fotoKey, foto);
      }

      if (expiryDuration != null) {
        final expiryTime = DateTime.now()
            .add(expiryDuration)
            .millisecondsSinceEpoch;
        await prefs.setInt(_tokenExpiryKey, expiryTime);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get access token
  String? getAccessToken() {
    return _prefs?.getString(_accessTokenKey);
  }

  // Get refresh token
  String? getRefreshToken() {
    return _prefs?.getString(_refreshTokenKey);
  }

  // Get user ID
  String? getUserId() {
    return _prefs?.getString(_userIdKey);
  }

  // Get username
  String? getUsername() {
    return _prefs?.getString(_usernameKey);
  }

  // Get user photo ✅ TAMBAHKAN
  String? getFoto() {
    return _prefs?.getString(_fotoKey);
  }

  // Check if token exists and is valid
  bool hasValidToken() {
    final token = getAccessToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    final expiryTime = _prefs?.getInt(_tokenExpiryKey);
    if (expiryTime == null) {
      // If no expiry time is set, assume token is valid
      return true;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    return now < expiryTime;
  }

  // Check if token is expired
  bool isTokenExpired() {
    final expiryTime = _prefs?.getInt(_tokenExpiryKey);
    if (expiryTime == null) {
      return false;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    return now >= expiryTime;
  }

  // Clear all game progress data
  Future<bool> clearGameProgress() async {
    try {
      final prefs = await _getPrefs();
      final keys = prefs.getKeys();

      // Remove all keys related to game progress
      for (final key in keys) {
        // Platform status, lesson completion, section progress, first completion, streak
        if (key.contains('modul') ||
            key.contains('platform') ||
            key.contains('_progress') ||
            key.contains('first_completed') ||
            key.contains('last_streak_update')) {
          await prefs.remove(key);
          print('🗑️ Removed game progress key: $key');
        }
      }

      print('✅ All game progress cleared');
      return true;
    } catch (e) {
      print('❌ Failed to clear game progress: $e');
      return false;
    }
  }

  // Clear all tokens
  Future<bool> clearToken() async {
    try {
      final prefs = await _getPrefs();

      print('🔓 Starting logout process...');
      print('   Current userId before clear: ${prefs.getString(_userIdKey)}');

      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_tokenExpiryKey);
      // ✅ DON'T remove userId - keep it to detect user change on next login
      // await prefs.remove(_userIdKey);
      await prefs.remove(_usernameKey);
      await prefs.remove(_fotoKey);

      print('🗑️ Tokens cleared (userId kept for progress tracking)');

      // ❌ REMOVED: Don't clear game progress on logout
      // User might login again with same account
      // Progress will only be cleared when DIFFERENT user logs in

      print('✅ Logout complete - progress preserved for re-login');

      return true;
    } catch (e) {
      print('❌ Logout failed: $e');
      return false;
    }
  }

  // Get all user data
  Map<String, String?> getUserData() {
    return {
      'accessToken': getAccessToken(),
      'refreshToken': getRefreshToken(),
      'userId': getUserId(),
      'username': getUsername(),
      'foto': getFoto(), // ✅ TAMBAHKAN
    };
  }
}
