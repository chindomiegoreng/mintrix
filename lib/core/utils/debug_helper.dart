import 'dart:io';
import 'package:http/http.dart' as http;

class DebugHelper {
  static Future<void> testMultipartUpload({
    required String endpoint,
    required Map<String, String> fields,
    required File? file,
    required String fileField,
  }) async {
    try {
      print('🧪 Testing multipart upload manually...');
      print('🧪 Endpoint: $endpoint');
      print('🧪 Fields: $fields');
      print('🧪 File: ${file?.path ?? "none"}');

      if (file != null && await file.exists()) {
        final fileSize = await file.length();
        final fileName = file.path.split('/').last;
        print('🧪 File size: $fileSize bytes');
        print('🧪 File name: $fileName');
      }

      var request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Add fields
      request.fields.addAll(fields);
      print('🧪 Added fields: ${request.fields}');

      // Add file if exists
      if (file != null && await file.exists()) {
        final multipartFile = await http.MultipartFile.fromPath(
          fileField,
          file.path,
        );
        request.files.add(multipartFile);
        print(
          '🧪 Added file: ${multipartFile.filename}, ${multipartFile.length} bytes',
        );
      }

      // Set headers
      request.headers.addAll({'Content-Type': 'multipart/form-data'});
      print('🧪 Headers: ${request.headers}');

      print('🧪 Sending request...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('🧪 Status Code: ${response.statusCode}');
      print('🧪 Response Headers: ${response.headers}');
      print('🧪 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Manual test SUCCESS!');
      } else {
        print('❌ Manual test FAILED with status ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('❌ Manual test ERROR: $e');
      print('❌ Stack trace: $stackTrace');
    }
  }
}
