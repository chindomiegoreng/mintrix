import 'dart:io';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent({required this.username, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final File? foto;

  RegisterEvent({
    required this.username,
    required this.email,
    required this.password,
    this.foto,
  });
}

// ✅ TAMBAHKAN EVENT BARU
class GoogleSignInEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class UpdateProfileEvent extends AuthEvent {
  final String userId;
  final String username;
  final String? photoUrl;

  UpdateProfileEvent({
    required this.userId,
    required this.username,
    this.photoUrl,
  });
}