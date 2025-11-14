import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthCheckingToken extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String username;
  final String? photoUrl; 

  const AuthAuthenticated({
    required this.userId,
    required this.username,
    this.photoUrl, 
  });

  @override
  List<Object?> get props => [userId, username, photoUrl];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}