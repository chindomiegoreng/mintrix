import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/core/models/auth_response_model.dart';

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      print('🔵 Starting Google Sign In...');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('⚠️ User cancelled Google Sign In');
        return null;
      }

      print('✅ Google user selected: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('✅ Got Google Auth tokens');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) throw Exception('Failed to get user from Firebase');

      print('✅ Firebase authentication successful');
      print('  - UID: ${user.uid}');
      print('  - Email: ${user.email}');
      print('  - Display Name: ${user.displayName}');
      print('  - Photo URL: ${user.photoURL}');

      return {
        'uid': user.uid,
        'email': user.email ?? '',
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL,
        'isNewUser': userCredential.additionalUserInfo?.isNewUser ?? false,
      };
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuth Error: ${e.code} - ${e.message}');
      throw Exception(_handleFirebaseAuthException(e));
    } catch (e) {
      print('❌ Google Sign In Error: $e');
      throw Exception('Gagal login dengan Google: $e');
    }
  }

  /// Register atau login user dari Google ke backend
  /// Foto diambil dari Firebase, tidak dikirim ke backend
  Future<AuthResponseModel> syncGoogleUserToBackend({
    required String firebaseUid,
    required String email,
    required String name,
    String? photoURL,
  }) async {
    try {
      print('🔄 Syncing Google user to backend...');
      print('  - Firebase UID: $firebaseUid');
      print('  - Email: $email');
      print('  - Name: $name');
      print('  - Photo URL: $photoURL (dari Firebase, tidak dikirim ke backend)');

      // Coba login dengan email terlebih dahulu
      try {
        print('🔍 Checking if user already registered...');
        
        // Generate password dummy dari firebase_uid (buat deterministik)
        final dummyPassword = 'google_$firebaseUid';

        final loginResponse = await _apiClient.post(
          ApiEndpoints.login,
          body: {
            'email': email,
            'password': dummyPassword,
          },
          requiresAuth: false,
        );

        print('✅ User already registered, logging in...');
        final authResponse = AuthResponseModel.fromJson(loginResponse);
        
        return authResponse;
      } catch (loginError) {
        print('⚠️ User not found, will register...');
        
        // Jika login gagal, daftar user baru
        return await _registerGoogleUser(
          email: email,
          name: name,
          firebaseUid: firebaseUid,
          photoURL: photoURL,
        );
      }
    } catch (e) {
      print('❌ Sync to backend failed: $e');
      rethrow;
    }
  }

  /// Daftar user baru dari Google
  /// Foto hanya disimpan dari Firebase, tidak dikirim ke backend
  Future<AuthResponseModel> _registerGoogleUser({
    required String email,
    required String name,
    required String firebaseUid,
    String? photoURL,
  }) async {
    try {
      print('📝 Registering new Google user to backend...');

      // Prepare data untuk register (tanpa mengirim foto)
      final registerData = {
        'nama': name,
        'email': email,
        'password': 'google_$firebaseUid', // Password dummy dari firebase_uid
      };

      final response = await _apiClient.post(
        ApiEndpoints.register,
        body: registerData,
        requiresAuth: false,
      );

      print('✅ Google user registered successfully');
      final authResponse = AuthResponseModel.fromJson(response);
      
      return authResponse;
    } catch (e) {
      print('❌ Unexpected registration error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      print('✅ Google Sign Out successful');
    } catch (e) {
      print('❌ Sign Out Error: $e');
      throw Exception('Gagal logout: $e');
    }
  }

  User? getCurrentUser() => _auth.currentUser;
  bool isSignedIn() => _auth.currentUser != null;

  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'Akun sudah terdaftar dengan metode login berbeda';
      case 'invalid-credential':
        return 'Kredensial tidak valid';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan';
      case 'user-disabled':
        return 'Akun pengguna dinonaktifkan';
      case 'user-not-found':
        return 'Pengguna tidak ditemukan';
      case 'wrong-password':
        return 'Password salah';
      case 'network-request-failed':
        return 'Gagal terhubung ke jaringan';
      default:
        return 'Terjadi kesalahan: ${e.message}';
    }
  }
}
