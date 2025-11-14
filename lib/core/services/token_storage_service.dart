import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _fotoKey = 'user_foto'; // ✅ TAMBAHKAN

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
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
      // ✅ Check if userId is different from stored userId
      final storedUserId = getUserId();
      if (userId != null && storedUserId != null && storedUserId != userId) {
        print('🔄 New user detected! Clearing old game progress...');
        print('   Old user: $storedUserId');
        print('   New user: $userId');
        await clearGameProgress();
      }

      await _prefs.setString(_accessTokenKey, accessToken);

      if (refreshToken != null) {
        await _prefs.setString(_refreshTokenKey, refreshToken);
      }

      if (userId != null) {
        await _prefs.setString(_userIdKey, userId);
      }

      if (username != null) {
        await _prefs.setString(_usernameKey, username);
      }

      if (foto != null) {
        // ✅ TAMBAHKAN
        await _prefs.setString(_fotoKey, foto);
      }

      if (expiryDuration != null) {
        final expiryTime = DateTime.now()
            .add(expiryDuration)
            .millisecondsSinceEpoch;
        await _prefs.setInt(_tokenExpiryKey, expiryTime);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get access token
  String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }

  // Get refresh token
  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  // Get user ID
  String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  // Get username
  String? getUsername() {
    return _prefs.getString(_usernameKey);
  }

  // Get user photo ✅ TAMBAHKAN
  String? getFoto() {
    return _prefs.getString(_fotoKey);
  }

  // Check if token exists and is valid
  bool hasValidToken() {
    final token = getAccessToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    final expiryTime = _prefs.getInt(_tokenExpiryKey);
    if (expiryTime == null) {
      // If no expiry time is set, assume token is valid
      return true;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    return now < expiryTime;
  }

  // Check if token is expired
  bool isTokenExpired() {
    final expiryTime = _prefs.getInt(_tokenExpiryKey);
    if (expiryTime == null) {
      return false;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    return now >= expiryTime;
  }

  // Clear all game progress data
  Future<bool> clearGameProgress() async {
    try {
      final keys = _prefs.getKeys();

      // Remove all keys related to game progress
      for (final key in keys) {
        // Platform status, lesson completion, section progress, first completion, streak
        if (key.contains('modul') ||
            key.contains('platform') ||
            key.contains('_progress') ||
            key.contains('first_completed') ||
            key.contains('last_streak_update')) {
          await _prefs.remove(key);
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
      await _prefs.remove(_accessTokenKey);
      await _prefs.remove(_refreshTokenKey);
      await _prefs.remove(_tokenExpiryKey);
      await _prefs.remove(_userIdKey);
      await _prefs.remove(_usernameKey);
      await _prefs.remove(_fotoKey); // ✅ TAMBAHKAN

      // ✅ Clear game progress when logging out
      await clearGameProgress();

      return true;
    } catch (e) {
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
