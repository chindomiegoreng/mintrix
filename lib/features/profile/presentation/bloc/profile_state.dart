import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String id;
  final String name;
  final String email;
  final String? foto;
  // ✅ Stats dari endpoint /api/profile/short
  final String liga;
  final int xp;
  final int streakCount;
  final int point;
  final bool streakActive;

  const ProfileLoaded({
    required this.id,
    required this.name,
    required this.email,
    this.foto,
    required this.liga,
    required this.xp,
    required this.streakCount,
    required this.point,
    required this.streakActive,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    foto,
    liga,
    xp,
    streakCount,
    point,
    streakActive,
  ];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
