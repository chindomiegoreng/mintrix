import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/core/models/cv_model.dart';

class CVService {
  final ApiClient _apiClient;

  CVService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Create a new CV/Resume
  Future<CVModel> createCV(CVModel cv) async {
    try {
      // Validate and format CV data before sending
      final validatedCV = _validateAndFormatCV(cv);

      final response = await _apiClient.post(
        ApiEndpoints.resume,
        body: validatedCV.toJson(),
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        return CVModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to create CV');
      }
    } catch (e) {
      throw Exception('Error creating CV: $e');
    }
  }

  /// Validate and format CV data before sending to backend
  CVModel _validateAndFormatCV(CVModel cv) {
    return CVModel(
      userId: cv.userId,
      kontak: cv.kontak,
      pengalaman: cv.pengalaman
          .map(
            (exp) => CVPengalaman(
              jabatan: exp.jabatan.trim().isEmpty
                  ? 'Not specified'
                  : exp.jabatan.trim(),
              perusahaan: exp.perusahaan.trim().isEmpty
                  ? 'Not specified'
                  : exp.perusahaan.trim(),
              lokasi: exp.lokasi.trim().isEmpty
                  ? 'Not specified'
                  : exp.lokasi.trim(),
              tanggalMulai: _formatDate(exp.tanggalMulai),
              tanggalSelesai: exp.tanggalSelesai?.isNotEmpty == true
                  ? _formatDate(exp.tanggalSelesai!)
                  : null,
              deskripsi: exp.deskripsi.trim().isEmpty
                  ? 'No description provided'
                  : exp.deskripsi.trim(),
            ),
          )
          .toList(),
      pendidikan: cv.pendidikan
          .map(
            (edu) => CVPendidikan(
              namaSekolah: edu.namaSekolah.trim().isEmpty
                  ? 'Not specified'
                  : edu.namaSekolah.trim(),
              lokasi: edu.lokasi.trim().isEmpty
                  ? 'Not specified'
                  : edu.lokasi.trim(),
              penjurusan: edu.penjurusan.trim().isEmpty
                  ? 'General'
                  : edu.penjurusan.trim(),
              tanggalMulai: _formatDate(edu.tanggalMulai),
              tanggalSelesai: edu.tanggalSelesai?.isNotEmpty == true
                  ? _formatDate(edu.tanggalSelesai!)
                  : null,
              deskripsi: edu.deskripsi.trim().isEmpty
                  ? 'No description provided'
                  : edu.deskripsi.trim(),
            ),
          )
          .toList(),
      keterampilan: cv.keterampilan,
      bahasa: cv.bahasa,
      sertifikasiDanLisensi: cv.sertifikasiDanLisensi,
      penghargaanDanApresiasi: cv.penghargaanDanApresiasi,
      situsWebDanMediaSosial: cv.situsWebDanMediaSosial,
      kustom: cv.kustom,
      ringkasan: cv.ringkasan.trim().isEmpty
          ? 'Professional summary not provided'
          : cv.ringkasan.trim(),
      resumeLink: cv.resumeLink,
    );
  }

  /// Format date string to ISO format (YYYY-MM-DDTHH:mm:ss.000Z)
  String _formatDate(String dateInput) {
    if (dateInput.trim().isEmpty) {
      return DateTime.now().toIso8601String();
    }

    // Handle various date formats
    try {
      // Remove any extra spaces
      String cleanDate = dateInput.trim();

      // If already in ISO format, return as is
      if (cleanDate.contains('T') && cleanDate.contains('Z')) {
        return cleanDate;
      }

      // Handle MM/YYYY format (like "06/2025")
      if (RegExp(r'^\d{1,2}\/\d{4}$').hasMatch(cleanDate)) {
        final parts = cleanDate.split('/');
        final month = int.parse(parts[0]).toString().padLeft(2, '0');
        final year = parts[1];
        return '$year-$month-01T00:00:00.000Z';
      }

      // Handle YYYY/MM format (like "2025/06")
      if (RegExp(r'^\d{4}\/\d{1,2}$').hasMatch(cleanDate)) {
        final parts = cleanDate.split('/');
        final year = parts[0];
        final month = int.parse(parts[1]).toString().padLeft(2, '0');
        return '$year-$month-01T00:00:00.000Z';
      }

      // Handle DD/MM/YYYY format
      if (RegExp(r'^\d{1,2}\/\d{1,2}\/\d{4}$').hasMatch(cleanDate)) {
        final parts = cleanDate.split('/');
        final day = int.parse(parts[0]).toString().padLeft(2, '0');
        final month = int.parse(parts[1]).toString().padLeft(2, '0');
        final year = parts[2];
        return '$year-$month-${day}T00:00:00.000Z';
      }

      // Handle YYYY-MM-DD format
      if (RegExp(r'^\d{4}-\d{1,2}-\d{1,2}$').hasMatch(cleanDate)) {
        final parts = cleanDate.split('-');
        final year = parts[0];
        final month = int.parse(parts[1]).toString().padLeft(2, '0');
        final day = int.parse(parts[2]).toString().padLeft(2, '0');
        return '$year-$month-${day}T00:00:00.000Z';
      }

      // Handle year only (like "2025")
      if (RegExp(r'^\d{4}$').hasMatch(cleanDate)) {
        return '$cleanDate-01-01T00:00:00.000Z';
      }

      // If all else fails, try to parse as DateTime
      final parsedDate = DateTime.tryParse(cleanDate);
      if (parsedDate != null) {
        return parsedDate.toIso8601String();
      }

      // Default to current date if parsing fails
      return DateTime.now().toIso8601String();
    } catch (e) {
      // Default to current date if any error occurs
      return DateTime.now().toIso8601String();
    }
  }

  /// Download CV by ID
  Future<String> downloadCV(String resumeId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.resumeById(resumeId),
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        final resumeLink = response['data']['resumeLink'];
        if (resumeLink != null && resumeLink.isNotEmpty) {
          return resumeLink;
        } else {
          throw Exception('Resume link not found');
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to get download link');
      }
    } catch (e) {
      throw Exception('Error downloading CV: $e');
    }
  }

  void dispose() {
    _apiClient.dispose();
  }
}
