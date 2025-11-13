import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_endpoints.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  // Get token dari local storage
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Save token ke local storage
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Clear token (logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Buat headers dengan/tanpa auth
  Future<Map<String, String>> _getHeaders({
    bool requiresAuth = true,
    bool isMultipart = false,
  }) async {
    final headers = <String, String>{'Accept': 'application/json'};

    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }

    if (requiresAuth) {
      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // ✅ PERBAIKAN: Handle response dan error dengan benar
  Map<String, dynamic> _handleResponse(
    http.Response response, {
    bool requiresAuth = true,
  }) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }

      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('⚠️ Response bukan JSON valid: ${response.body}');
        return {'success': true, 'message': response.body};
      }
    } else if (statusCode == 400) {
      // Bad Request - email sudah terdaftar, dll
      try {
        final errorBody = jsonDecode(response.body);
        final message = errorBody['message'] ?? 'Request tidak valid';
        throw Exception(message);
      } catch (e) {
        if (e.toString().contains('Exception:')) {
          rethrow;
        }
        throw Exception('Request tidak valid');
      }
    } else if (statusCode == 401) {
      // ✅ Unauthorized - bisa password salah ATAU token expired
      try {
        final errorBody = jsonDecode(response.body);
        final message = errorBody['message'] ?? 'Unauthorized';

        // ✅ Jika request memerlukan auth, kemungkinan token expired
        // ✅ Jika tidak memerlukan auth (login), kemungkinan password salah
        if (requiresAuth) {
          throw Exception('Token expired. Please login again');
        } else {
          throw Exception(message); // ✅ Tampilkan pesan dari server
        }
      } catch (e) {
        if (e.toString().contains('Exception:')) {
          rethrow;
        }
        throw Exception('Unauthorized');
      }
    } else if (statusCode == 404) {
      throw Exception('Endpoint not found');
    } else if (statusCode >= 500) {
      throw Exception('Server error. Please try again later');
    } else {
      try {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Request failed');
      } catch (e) {
        if (e.toString().contains('Exception:')) {
          rethrow;
        }
        throw Exception('Request failed with status: $statusCode');
      }
    }
  }

  // GET Request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool useDinoBase = false,
    bool requiresAuth = true,
  }) async {
    try {
      final baseUrl = useDinoBase
          ? ApiEndpoints.dinoBaseUrl
          : ApiEndpoints.mintrixBaseUrl;
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      print('📡 GET: $url');
      final response = await _client.get(url, headers: headers);
      print('✅ Response: ${response.statusCode}');

      return _handleResponse(response, requiresAuth: requiresAuth);
    } catch (e) {
      print('❌ Error GET: $e');
      rethrow;
    }
  }

  // POST Request (JSON)
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool useDinoBase = false,
    bool requiresAuth = true,
  }) async {
    try {
      final baseUrl = useDinoBase
          ? ApiEndpoints.dinoBaseUrl
          : ApiEndpoints.mintrixBaseUrl;
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      print('📡 POST: $url');
      print('📦 Body: ${jsonEncode(body)}');

      final response = await _client.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print('✅ Response: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      final result = _handleResponse(response, requiresAuth: requiresAuth);

      // Auto save token jika login/register
      if (result['token'] != null) {
        await _saveToken(result['token']);
        print('🔑 Token saved: ${result['token'].substring(0, 20)}...');
      }

      return result;
    } catch (e) {
      print('❌ Error POST: $e');
      rethrow;
    }
  }

  // POST dengan Multipart (untuk upload foto)
  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    File? file,
    String fileField = 'foto',
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('${ApiEndpoints.mintrixBaseUrl}$endpoint');

      print('📡 POST Multipart: $url');
      print('📦 Fields: $fields');

      var request = http.MultipartRequest('POST', url);

      // Tambahkan headers
      if (requiresAuth) {
        final token = await _getToken();
        if (token != null && token.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $token';
        }
      }
      request.headers['Accept'] = 'application/json';

      // Tambahkan fields
      request.fields.addAll(fields);

      // Tambahkan file jika ada
      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(fileField, file.path),
        );
        print('📎 File attached: ${file.path}');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('✅ Response: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      final result = _handleResponse(response, requiresAuth: requiresAuth);

      // Auto save token jika register
      if (result['token'] != null) {
        await _saveToken(result['token']);
        print('🔑 Token saved: ${result['token'].substring(0, 20)}...');
      }

      return result;
    } catch (e) {
      print('❌ Error POST Multipart: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool useDinoBase = false,
    bool requiresAuth = true,
  }) async {
    try {
      final baseUrl = useDinoBase
          ? ApiEndpoints.dinoBaseUrl
          : ApiEndpoints.mintrixBaseUrl;
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      print('📡 PUT: $url');
      print('📦 Body: ${jsonEncode(body)}');

      final response = await _client.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print('✅ Response: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      return _handleResponse(response, requiresAuth: requiresAuth);
    } catch (e) {
      print('❌ Error PUT: $e');
      rethrow;
    }
  }

  // ✅ DELETE Request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool useDinoBase = false,
    bool requiresAuth = true,
  }) async {
    try {
      final baseUrl = useDinoBase
          ? ApiEndpoints.dinoBaseUrl
          : ApiEndpoints.mintrixBaseUrl;
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      print('📡 DELETE: $url');

      final response = await _client.delete(url, headers: headers);

      print('✅ Response: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      return _handleResponse(response, requiresAuth: requiresAuth);
    } catch (e) {
      print('❌ Error DELETE: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    required Map<String, dynamic> body,
    bool useDinoBase = false,
    bool requiresAuth = true,
  }) async {
    try {
      final baseUrl = useDinoBase
          ? ApiEndpoints.dinoBaseUrl
          : ApiEndpoints.mintrixBaseUrl;
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      print('📡 PATCH: $url');
      print('📦 Body: ${jsonEncode(body)}');
      print('🔑 Headers: $headers');

      final response = await _client.patch(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print('✅ Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      return _handleResponse(response, requiresAuth: requiresAuth);
    } catch (e) {
      print('❌ Error PATCH: $e');
      rethrow;
    }
  }

  void dispose() {
    _client.close();
  }
}
