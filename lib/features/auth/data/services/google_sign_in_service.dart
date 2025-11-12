import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

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
