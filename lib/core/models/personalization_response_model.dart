import 'package:mintrix/core/models/personalization_model.dart';

class PersonalizationResponseModel {
  final String message;
  final PersonalizationModel data;

  PersonalizationResponseModel({required this.message, required this.data});

  factory PersonalizationResponseModel.fromJson(Map<String, dynamic> json) {
    return PersonalizationResponseModel(
      message: json['message'] ?? '',
      data: PersonalizationModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data.toJson()};
  }
}
