import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/core/models/auth_response_model.dart';
import 'package:mintrix/core/services/token_storage_service.dart';
import 'package:mintrix/features/auth/data/repositories/auth_repository.dart';
import 'package:mintrix/features/auth/data/services/google_sign_in_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiClient _apiClient;
  final GoogleSignInService _googleSignInService;
  final AuthRepository _authRepository;

  AuthBloc({
    ApiClient? apiClient,
    GoogleSignInService? googleSignInService,
    TokenStorageService? tokenStorageService,
    AuthRepository? authRepository,
  })  : _apiClient = apiClient ?? ApiClient(),
        _googleSignInService = googleSignInService ?? GoogleSignInService(),
        _authRepository = authRepository ?? AuthRepository(
          tokenStorageService: tokenStorageService ?? TokenStorageService(),
        ),
        super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<GoogleSignInEvent>(_onGoogleSignInEvent); // ✅ TAMBAHKAN
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckTokenEvent>(_onCheckTokenEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
  }

  // Handle Login
  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      final response = await _apiClient.post(
        ApiEndpoints.login,
        body: {'email': event.username, 'password': event.password},
        requiresAuth: false,
      );

      final authResponse = AuthResponseModel.fromJson(response);

      // ✅ Save token to local storage
      print('💾 Saving token...');
      print('  - Token: ${authResponse.token.substring(0, 20)}...');
      print('  - User ID: ${authResponse.user.id}');
      print('  - Username: ${authResponse.user.name}');
      
      final saveSuccess = await _authRepository.saveLoginData(
        accessToken: authResponse.token,
        userId: authResponse.user.id,
        username: authResponse.user.name,
        foto: authResponse.user.foto, // ✅ TAMBAHKAN
        expiryDuration: const Duration(hours: 24),
      );
      
      print('💾 Token saved: $saveSuccess');

      emit(
        AuthAuthenticated(
          userId: authResponse.user.id,
          username: authResponse.user.name,
          photoUrl: authResponse.user.foto,
        ),
      );

      print('✅ Login Success: ${authResponse.message}');
      print('✅ Token saved to local storage');
    } catch (e) {
      emit(AuthError(_parseError(e.toString())));
      print('❌ Login Error: $e');
    }
  }

  // Handle Register dengan Foto
  Future<void> _onRegisterEvent(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      if (event.username.isEmpty ||
          event.email.isEmpty ||
          event.password.isEmpty) {
        emit(AuthError('Semua field harus diisi'));
        return;
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(event.email)) {
        emit(AuthError('Format email tidak valid'));
        return;
      }

      if (event.password.length < 6) {
        emit(AuthError('Password minimal 6 karakter'));
        return;
      }

      print('🚀 Sending register request:');
      print('  - nama: ${event.username}');
      print('  - email: ${event.email}');
      print('  - password: ${event.password.isNotEmpty ? "***" : "empty"}');
      print('  - foto: ${event.foto?.path ?? "null"}');

      if (event.foto != null) {
        final fileExists = await event.foto!.exists();
        final fileSize = fileExists ? await event.foto!.length() : 0;
        final fileName = event.foto!.path.split('/').last;
        final fileExtension = fileName.split('.').last.toLowerCase();

        print('  - foto exists: $fileExists');
        print('  - foto size: $fileSize bytes');
        print('  - foto name: $fileName');
        print('  - foto extension: $fileExtension');

        if (!fileExists) {
          emit(AuthError('File gambar tidak ditemukan'));
          return;
        }

        if (fileSize == 0) {
          emit(AuthError('File gambar kosong'));
          return;
        }

        if (fileSize > 5 * 1024 * 1024) {
          emit(AuthError('Ukuran file terlalu besar (max 5MB)'));
          return;
        }

        if (!['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileExtension)) {
          emit(
            AuthError('Format file tidak didukung. Gunakan JPG, PNG, atau GIF'),
          );
          return;
        }
      }

      try {
        final response = await _apiClient.postMultipart(
          ApiEndpoints.register,
          fields: {
            'nama': event.username,
            'email': event.email,
            'password': event.password,
          },
          file: event.foto,
          fileField: 'foto',
          requiresAuth: false,
        );

        print('📦 Raw API Response: $response');

        final authResponse = AuthResponseModel.fromJson(response);

        // ✅ Save token to local storage
        await _authRepository.saveLoginData(
          accessToken: authResponse.token,
          userId: authResponse.user.id,
          username: authResponse.user.name,
          expiryDuration: const Duration(hours: 24),
        );

        emit(
          AuthAuthenticated(
            userId: authResponse.user.id,
            username: authResponse.user.name,
            photoUrl: authResponse.user.foto,
          ),
        );

        print('✅ Register Success: ${authResponse.message}');
        print('✅ Token saved to local storage');
        print('✅ User foto URL: ${authResponse.user.foto}');
      } catch (apiError) {
        print('❌ ApiClient failed: $apiError');
        throw apiError;
      }
    } catch (e, stackTrace) {
      print('❌ Register Error Full: $e');
      print('❌ Stack trace: $stackTrace');

      String errorMessage = e.toString();
      if (errorMessage.contains('Connection refused') ||
          errorMessage.contains('Failed host lookup')) {
        errorMessage =
            'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
      } else if (errorMessage.contains('Request timeout')) {
        errorMessage = 'Permintaan timeout. Coba lagi dalam beberapa saat.';
      } else if (errorMessage.contains('File upload failed')) {
        errorMessage = 'Upload foto gagal. Periksa ukuran dan format file.';
      }

      emit(AuthError(_parseError(errorMessage)));
    }
  }

  // ✅ HANDLER GOOGLE SIGN IN
  Future<void> _onGoogleSignInEvent(
    GoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      print('🔵 Starting Google Sign In process...');

      // Sign in with Google
      final googleUserData = await _googleSignInService.signInWithGoogle();

      if (googleUserData == null) {
        emit(AuthInitial());
        print('⚠️ Google Sign In cancelled by user');
        return;
      }

      print('✅ Google Sign In successful');
      print('  - Email: ${googleUserData['email']}');
      print('  - Name: ${googleUserData['displayName']}');
      print('  - Photo: ${googleUserData['photoURL']}');

      // Sinkronisasi dengan backend (register jika user baru, login jika sudah ada)
      try {
        final authResponse = await _googleSignInService.syncGoogleUserToBackend(
          firebaseUid: googleUserData['uid'],
          email: googleUserData['email'],
          name: googleUserData['displayName'],
          photoURL: googleUserData['photoURL'],
        );

        print('💾 Saving token to local storage...');
        
        // Ambil photo URL dari Firebase, bukan dari backend
        final firebasePhotoUrl = googleUserData['photoURL'];
        
        final saveSuccess = await _authRepository.saveLoginData(
          accessToken: authResponse.token,
          userId: authResponse.user.id,
          username: authResponse.user.name,
          foto: firebasePhotoUrl, // ✅ Gunakan foto dari Firebase
          expiryDuration: const Duration(hours: 24),
        );

        print('💾 Token saved: $saveSuccess');
        print('📸 Photo URL from Firebase: $firebasePhotoUrl');

        emit(
          AuthAuthenticated(
            userId: authResponse.user.id,
            username: authResponse.user.name,
            photoUrl: firebasePhotoUrl, // ✅ Gunakan foto dari Firebase
          ),
        );

        print('✅ Google Sign In complete with backend sync');
      } catch (backendError) {
        print('❌ Backend sync failed: $backendError');
        emit(AuthError(_parseError(backendError.toString())));
      }
    } catch (e) {
      print('❌ Google Sign In Error: $e');
      emit(AuthError(_parseError(e.toString())));
    }
  }

  // Handle Update Profile
  Future<void> _onUpdateProfileEvent(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      AuthAuthenticated(
        userId: event.userId,
        username: event.username,
        photoUrl: event.photoUrl,
      ),
    );
    print(
      '✅ Profile Updated in AuthBloc: ${event.username}, Photo: ${event.photoUrl}',
    );
  }

  // Handle Check Token
  Future<void> _onCheckTokenEvent(
    CheckTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthCheckingToken());
      print('🔍 Checking token...');

      // Check if token exists and is valid
      if (_authRepository.isLoggedIn()) {
        print('✅ Token found in storage');
        // Check if token is expired
        if (_authRepository.isTokenExpired()) {
          // Token expired, logout
          print('⚠️ Token expired, clearing storage');
          await _authRepository.logout();
          emit(AuthUnauthenticated());
          print('⚠️ Token expired, user logged out');
        } else {
          // Token is still valid, restore user data
          final userData = _authRepository.getUserData();
          print('✅ Token is valid');
          print('📦 User data: $userData');
          emit(
            AuthAuthenticated(
              userId: userData['userId'] ?? '',
              username: userData['username'] ?? '',
              photoUrl: userData['foto'], // ✅ TAMBAHKAN
            ),
          );
          print('✅ Token is valid, user restored');
        }
      } else {
        // No token found
        print('ℹ️ No valid token found in storage');
        emit(AuthUnauthenticated());
        print('ℹ️ No valid token found');
      }
    } catch (e, stackTrace) {
      print('❌ Token check error: $e');
      print('❌ Stack trace: $stackTrace');
      emit(AuthUnauthenticated());
    }
  }

  // Handle Logout
  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _apiClient.clearToken();
      await _authRepository.logout();
      await _googleSignInService.signOut(); // ✅ Logout dari Google juga
      emit(AuthUnauthenticated());
      print('✅ Logout Success');
    } catch (e) {
      emit(AuthError(e.toString()));
      print('❌ Logout Error: $e');
    }
  }

  // Helper untuk parse error message
  String _parseError(String error) {
    if (error.contains('Network error')) {
      return 'Koneksi internet bermasalah';
    } else if (error.contains('Token expired')) {
      return 'Sesi berakhir, silakan login kembali';
    } else if (error.contains('Unauthorized')) {
      return 'Email atau password salah';
    } else if (error.contains('Server error')) {
      return 'Server sedang bermasalah, coba lagi nanti';
    } else if (error.contains('Exception:')) {
      return error.replaceAll('Exception:', '').trim();
    } else if (error.contains('Gagal login dengan Google')) {
      return 'Gagal login dengan Google. Silakan coba lagi';
    }
    return error;
  }

  @override
  Future<void> close() {
    _apiClient.dispose();
    return super.close();
  }
}