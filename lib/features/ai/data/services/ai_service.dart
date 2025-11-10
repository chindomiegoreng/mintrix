import 'package:dio/dio.dart';

class AIService {
  static const String baseUrl = 'https://dino.yogawanadityapratama.com/api';
  final Dio _dio = Dio();

  AIService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<String> sendMessage(List<Map<String, String>> messages) async {
    try {
      final response = await _dio.post(
        '/llm/dino/chat',
        data: {'messages': messages},
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['reply'] ??
            'Maaf, saya tidak bisa memahami pesan kamu.';
      } else {
        throw Exception('Failed to get response from server');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server took too long to respond.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
