import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<LogoutEvent>(_onLogoutEvent);
  }

  Future<void> _onLoginEvent(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      // Add your authentication logic here
      // For demonstration, we'll just simulate a successful login
      await Future.delayed(const Duration(seconds: 1));
      
      emit(AuthAuthenticated(
        userId: 'user_123',
        username: event.username,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterEvent(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      // Add your registration logic here
      // For demonstration, we'll just simulate a successful registration
      await Future.delayed(const Duration(seconds: 1));
      
      emit(AuthAuthenticated(
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        username: event.username,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      // Add your logout logic here
      await Future.delayed(const Duration(seconds: 1));
      
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}