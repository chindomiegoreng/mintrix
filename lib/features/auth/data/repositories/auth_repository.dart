import 'package:mintrix/core/services/token_storage_service.dart';

class AuthRepository {
  final TokenStorageService _tokenStorageService;

  AuthRepository({required TokenStorageService tokenStorageService})
      : _tokenStorageService = tokenStorageService;

  // Save login data
  Future<bool> saveLoginData({
    required String accessToken,
    String? refreshToken,
    String? userId,
    String? username,
    String? foto, // ✅ TAMBAHKAN
    Duration? expiryDuration,
  }) async {
    return await _tokenStorageService.saveToken(
      accessToken,
      refreshToken: refreshToken,
      userId: userId,
      username: username,
      foto: foto, // ✅ TAMBAHKAN
      expiryDuration: expiryDuration,
    );
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _tokenStorageService.hasValidToken();
  }

  // Check if token is expired
  bool isTokenExpired() {
    return _tokenStorageService.isTokenExpired();
  }

  // Get user data
  Map<String, String?> getUserData() {
    return _tokenStorageService.getUserData();
  }

  // Get access token
  String? getAccessToken() {
    return _tokenStorageService.getAccessToken();
  }

  // Logout
  Future<bool> logout() async {
    return await _tokenStorageService.clearToken();
  }
}