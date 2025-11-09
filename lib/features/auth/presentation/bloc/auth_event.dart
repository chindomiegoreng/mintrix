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
  final File? foto; // ✅ Tambahkan foto

  RegisterEvent({
    required this.username,
    required this.email,
    required this.password,
    this.foto,
  });
}

class LogoutEvent extends AuthEvent {}
