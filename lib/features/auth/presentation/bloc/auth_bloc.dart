import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/core/models/auth_response_model.dart';
import 'package:mintrix/core/utils/debug_helper.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiClient _apiClient;

  AuthBloc({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient(),
      super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent); // ✅ TAMBAHKAN INI
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

      emit(
        AuthAuthenticated(
          userId: authResponse.user.id,
          username: authResponse.user.name,
          photoUrl: authResponse.user.foto,
        ),
      );

      print('✅ Login Success: ${authResponse.message}');
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

      // Debug print untuk memverifikasi data sebelum kirim
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
        print('  - foto absolute path: ${event.foto!.absolute.path}');

        // Validasi file
        if (!fileExists) {
          emit(AuthError('File gambar tidak ditemukan'));
          return;
        }

        if (fileSize == 0) {
          emit(AuthError('File gambar kosong'));
          return;
        }

        if (fileSize > 5 * 1024 * 1024) {
          // 5MB limit
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

      // Log request details
      print('📤 Making multipart request to: ${ApiEndpoints.register}');
      print(
        '📤 Fields: nama=${event.username}, email=${event.email}, password=***',
      );
      print('📤 File field: foto, File: ${event.foto?.path ?? "none"}');

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

        emit(
          AuthAuthenticated(
            userId: authResponse.user.id,
            username: authResponse.user.name,
            photoUrl: authResponse.user.foto,
          ),
        );

        print('✅ Register Success: ${authResponse.message}');
        print('✅ User foto URL: ${authResponse.user.foto}');
      } catch (apiError) {
        print('❌ ApiClient failed: $apiError');
        print('🧪 Trying manual multipart upload for debugging...');

        // Test with manual multipart upload
        await DebugHelper.testMultipartUpload(
          endpoint: ApiEndpoints.register,
          fields: {
            'nama': event.username,
            'email': event.email,
            'password': event.password,
          },
          file: event.foto,
          fileField: 'foto',
        );

        // Re-throw the original error
        throw apiError;
      }
    } catch (e, stackTrace) {
      print('❌ Register Error Full: $e');
      print('❌ Stack trace: $stackTrace');

      // More specific error handling
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

  // ✅ TAMBAHKAN HANDLER INI
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

  // Handle Logout
  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _apiClient.clearToken();
      emit(AuthInitial());
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
    }
    return error;
  }

  @override
  Future<void> close() {
    _apiClient.dispose();
    return super.close();
  }
}
