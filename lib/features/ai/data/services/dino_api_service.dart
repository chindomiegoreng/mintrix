import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mintrix/features/ai/data/models/chat_title_model.dart';

class DinoApiService {
  static const String baseUrl = 'https://mintrix.yogawanadityapratama.com/api/dino/llm';
  final String authToken;
  late final Dio _dio;

  DinoApiService({required this.authToken}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        return status! < 500; // ✅ Jangan throw error untuk status < 500
      },
    ));
    
    // ✅ Add interceptor untuk debug
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🚀 Request: ${options.method} ${options.path}');
        print('🔑 Headers: ${options.headers}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ Response: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('❌ Error: ${error.response?.statusCode} - ${error.message}');
        return handler.next(error);
      },
    ));
  }

  // Create new chat title
  Future<ChatTitleModel> createChatTitle(String title) async {
    try {
      final response = await _dio.post(
        '/title',
        data: {'title': title},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatTitleModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create chat title: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid atau kadaluarsa');
      }
      throw Exception('Failed to create chat title: ${e.message}');
    }
  }

  // Get list of chat titles
  Future<List<ChatTitleModel>> getChatTitles() async {
    try {
      final response = await _dio.get('/title');

      if (response.statusCode == 200) {
        final List<dynamic> titlesJson = response.data['data'];
        return titlesJson.map((json) => ChatTitleModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch chat titles: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid atau kadaluarsa');
      }
      throw Exception('Failed to fetch chat titles: ${e.message}');
    }
  }

  // Send message to AI
  Future<String> sendMessage(String titleId, String content) async {
    try {
      final response = await _dio.post(
        '/history/$titleId',
        data: {'content': content},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final messages = response.data['data']['messages'] as List;
        final lastMessage = messages.last;
        
        // Parse the reply from JSON string
        final replyContent = jsonDecode(lastMessage['content']);
        return replyContent['reply'];
      } else {
        throw Exception('Failed to send message: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid atau kadaluarsa');
      }
      throw Exception('Failed to send message: ${e.message}');
    }
  }

  // Get chat history
  Future<ChatHistoryModel> getChatHistory(String titleId) async {
    try {
      final response = await _dio.get('/history/$titleId');

      if (response.statusCode == 200) {
        return ChatHistoryModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to fetch chat history: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid atau kadaluarsa');
      }
      throw Exception('Failed to fetch chat history: ${e.message}');
    }
  }
}
