class UserModel {
  final String id;
  final String name;
  final String email;
  final String? foto;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.foto,
  });

  // Dari JSON ke Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['nama'] ?? '',
      email: json['email'] ?? '',
      foto: json['foto'],
    );
  }

  // Dari Object ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': name,
      'email': email,
      'foto': foto,
    };
  }
}