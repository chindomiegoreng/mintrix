abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class RefreshProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String? foto;

  UpdateProfile({required this.name, this.foto});
}

class UpdateStreak extends ProfileEvent {
  UpdateStreak();
}
