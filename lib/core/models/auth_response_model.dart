import 'user_model.dart';

class AuthResponseModel {
  final String message;
  final String token;
  final UserModel user;
  String? firebasePhotoUrl; // Foto dari Firebase

  AuthResponseModel({
    required this.message,
    required this.token,
    required this.user,
    this.firebasePhotoUrl,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user']),
    );
  }

  // Method untuk set Firebase photo URL
  void setFirebasePhotoUrl(String? photoUrl) {
    firebasePhotoUrl = photoUrl;
    user.setPhotoUrl(photoUrl);
  }
}