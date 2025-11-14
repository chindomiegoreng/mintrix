import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageDownloader {
  /// Download gambar dari URL dan simpan sebagai temporary file
  /// Returns File object jika sukses, null jika gagal
  static Future<File?> downloadImage(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) {
      print('⚠️ Image URL is null or empty');
      return null;
    }

    try {
      print('📥 Downloading image from: $imageUrl');

      // Download image
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode != 200) {
        print('❌ Failed to download image: ${response.statusCode}');
        return null;
      }

      print('✅ Image downloaded, size: ${response.bodyBytes.length} bytes');

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();

      // Generate unique filename dengan timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = _getImageExtension(imageUrl, response.headers);
      final fileName = 'google_profile_$timestamp.$extension';
      final filePath = path.join(tempDir.path, fileName);

      // Save image to file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      print('💾 Image saved to: $filePath');
      print('📏 File size: ${await file.length()} bytes');

      // Verify file exists
      if (await file.exists()) {
        return file;
      } else {
        print('❌ File was not saved properly');
        return null;
      }
    } catch (e) {
      print('❌ Error downloading image: $e');
      return null;
    }
  }

  /// Determine image extension dari URL atau Content-Type header
  static String _getImageExtension(String url, Map<String, String> headers) {
    // Try dari Content-Type header
    final contentType = headers['content-type']?.toLowerCase();
    if (contentType != null) {
      if (contentType.contains('jpeg') || contentType.contains('jpg')) {
        return 'jpg';
      } else if (contentType.contains('png')) {
        return 'png';
      } else if (contentType.contains('gif')) {
        return 'gif';
      } else if (contentType.contains('webp')) {
        return 'webp';
      }
    }

    // Try dari URL extension
    final urlExtension = path.extension(url).toLowerCase();
    if (urlExtension.isNotEmpty) {
      return urlExtension.replaceFirst('.', '');
    }

    // Default to jpg
    return 'jpg';
  }

  /// Hapus file temporary jika tidak digunakan lagi
  static Future<void> deleteTemporaryImage(File? file) async {
    if (file != null && await file.exists()) {
      try {
        await file.delete();
        print('🗑️ Temporary image deleted: ${file.path}');
      } catch (e) {
        print('⚠️ Failed to delete temporary image: $e');
      }
    }
  }
}
