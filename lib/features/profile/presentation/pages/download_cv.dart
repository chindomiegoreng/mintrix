import 'package:flutter/material.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/core/models/cv_model.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class DownloadCv extends StatefulWidget {
  const DownloadCv({super.key});

  @override
  State<DownloadCv> createState() => _DownloadCvState();
}

class _DownloadCvState extends State<DownloadCv> {
  final ApiClient _apiClient = ApiClient();
  
  CVModel? _latestCV;
  bool _isLoading = true;
  bool _isDownloading = false;
  String? _error;
  String? _localPdfPath;
  bool _isPdfLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLatestCV();
  }

  Future<void> _fetchLatestCV() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      debugPrint('📡 Fetching latest CV...');
      
      // GET /api/resume untuk mendapatkan semua CV
      final response = await _apiClient.get(
        ApiEndpoints.resume,
        requiresAuth: true,
      );

      debugPrint('✅ Response: $response');

      // Ambil CV terakhir dari array
      if (response['data'] != null && response['data'] is List) {
        final cvList = response['data'] as List;
        
        if (cvList.isNotEmpty) {
          // Ambil CV terakhir (index terakhir)
          final latestCvData = cvList.last;
          final cv = CVModel.fromJson(latestCvData);
          
          setState(() {
            _latestCV = cv;
            _isLoading = false;
          });

          // Download PDF untuk preview jika ada resumeLink
          if (cv.resumeLink != null && cv.resumeLink!.isNotEmpty) {
            _downloadPdfForPreview(cv.resumeLink!);
          }
          
          debugPrint('✅ Latest CV loaded: ${cv.id}');
        } else {
          setState(() {
            _error = 'Belum ada CV yang dibuat';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Format response tidak valid';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error fetching CV: $e');
      setState(() {
        _error = 'Gagal memuat CV: ${e.toString().replaceAll('Exception: ', '')}';
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadPdfForPreview(String url) async {
    if (!mounted) return;

    setState(() {
      _isPdfLoading = true;
    });

    try {
      debugPrint('📥 Downloading PDF for preview from: $url');

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw 'Download timeout';
        },
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        final file = File(
          '${dir.path}/preview_cv_${DateTime.now().millisecondsSinceEpoch}.pdf',
        );
        await file.writeAsBytes(bytes, flush: true);

        if (mounted) {
          setState(() {
            _localPdfPath = file.path;
            _isPdfLoading = false;
          });
          debugPrint('✅ PDF downloaded for preview: ${file.path}');
        }
      } else {
        throw 'HTTP ${response.statusCode}';
      }
    } catch (e) {
      debugPrint('❌ Error downloading PDF for preview: $e');
      if (mounted) {
        setState(() {
          _isPdfLoading = false;
        });
      }
    }
  }

  Future<void> _downloadAndSavePDF() async {
    if (_latestCV?.resumeLink == null || _latestCV!.resumeLink!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Link CV tidak tersedia'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isDownloading = true;
      });

      final url = _latestCV!.resumeLink!;
      debugPrint('📥 Downloading PDF from: $url');

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw 'Download timeout';
        },
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Simpan di direktori aplikasi
        final dir = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'CV_Resume_$timestamp.pdf';
        final filePath = '${dir.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(bytes, flush: true);

        debugPrint('✅ PDF saved to: $filePath');

        if (mounted) {
          setState(() {
            _isDownloading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ CV berhasil didownload!\n$fileName'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Buka',
                textColor: Colors.white,
                onPressed: () async {
                  final result = await OpenFilex.open(filePath);
                  debugPrint('📄 OpenFile result: ${result.message}');
                },
              ),
            ),
          );
        }
      } else {
        throw 'HTTP ${response.statusCode}';
      }
    } catch (e) {
      debugPrint('❌ Error downloading PDF: $e');
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal download CV: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: lightBackgoundColor,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Download CV",
          style: primaryTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(bluePrimaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Memuat CV...',
              style: primaryTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomFilledButton(
                title: 'Coba Lagi',
                variant: ButtonColorVariant.blue,
                onPressed: _fetchLatestCV,
              ),
            ],
          ),
        ),
      );
    }

    if (_latestCV == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.description_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Belum ada CV yang dibuat',
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Buat CV terlebih dahulu untuk bisa mendownload',
                style: secondaryTextStyle.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            children: [
              _buildCVPreviewCard(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: CustomFilledButton(
            title: _isDownloading ? 'Downloading...' : 'Download CV',
            width: double.infinity,
            variant: ButtonColorVariant.blue,
            onPressed: _isDownloading ? null : _downloadAndSavePDF,
          ),
        ),
        SizedBox(height: 24)
      ],
    );
  }

  Widget _buildCVPreviewCard() {
    return Container(
      height: 530,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: thirdColor, width: 1.5),
          color: Colors.white,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // PDF Preview
            if (_latestCV?.resumeLink != null && _latestCV!.resumeLink!.isNotEmpty)
              _buildPDFPreview()
            else
              _buildPlaceholder(),

            // Loading Overlay
            if (_isPdfLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFPreview() {
    if (_localPdfPath != null && File(_localPdfPath!).existsSync()) {
      return PDFView(
        filePath: _localPdfPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: false,
        pageSnap: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.WIDTH,
        onError: (error) {
          debugPrint('PDF Error: $error');
        },
        onPageError: (page, error) {
          debugPrint('Page $page Error: $error');
        },
      );
    }

    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.picture_as_pdf, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            'Preview CV',
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'CV Preview',
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.white.withOpacity(0.95),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(bluePrimaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Memuat preview...',
              style: primaryTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // Hapus temporary PDF file
    if (_localPdfPath != null) {
      try {
        final file = File(_localPdfPath!);
        if (file.existsSync()) {
          file.deleteSync();
          debugPrint('🗑️ Temporary PDF deleted');
        }
      } catch (e) {
        debugPrint('⚠️ Error deleting temporary PDF: $e');
      }
    }
    _apiClient.dispose();
    super.dispose();
  }
}