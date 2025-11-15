import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/core/services/streak_service.dart';
import 'package:mintrix/features/game/bloc/build_cv_bloc.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_event.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CVResult extends StatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback onDownload;
  final VoidCallback onBack;

  const CVResult({
    super.key,
    required this.onComplete,
    required this.onDownload,
    required this.onBack,
  });

  @override
  State<CVResult> createState() => _CVResultState();
}

class _CVResultState extends State<CVResult> {
  String? resumeId;
  String? resumeLink;
  bool isGenerating = false;
  bool isDownloading = false;
  String? localPdfPath;
  bool isPdfLoading = false;
  final ApiClient _apiClient = ApiClient();
  final StreakService _streakService = StreakService();
  bool _isSubmittingXP = false;
  bool _xpSubmitted = false;
  final int xpReward = 80;

  @override
  void initState() {
    super.initState();
    _checkExistingState();
  }

  void _checkExistingState() {
    final state = context.read<BuildCVBloc>().state;
    if (state is CVSubmitSuccess) {
      setState(() {
        resumeId = state.cvModel.id;
        resumeLink = state.cvModel.resumeLink;
      });

      if (resumeLink != null && resumeLink!.isNotEmpty) {
        _downloadPdfForPreview(resumeLink!);
      }

      // ✅ Submit XP when CV is successfully created
      if (!_xpSubmitted) {
        _submitXPToBackend();
      }
    } else if (state is CVSubmitting) {
      setState(() {
        isGenerating = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BuildCVBloc, BuildCVState>(
      listener: (context, state) {
        if (state is CVSubmitSuccess) {
          setState(() {
            resumeId = state.cvModel.id;
            resumeLink = state.cvModel.resumeLink;
            isGenerating = false;
          });

          if (resumeLink != null && resumeLink!.isNotEmpty) {
            _downloadPdfForPreview(resumeLink!);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Resume berhasil dibuat!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // ✅ Submit XP when CV is successfully created
          if (!_xpSubmitted) {
            _submitXPToBackend();
            _updateStreak();
          }
        } else if (state is CVSubmitError) {
          setState(() {
            isGenerating = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Error: ${state.error}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Tutup',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        } else if (state is CVSubmitting) {
          setState(() {
            isGenerating = true;
          });
        } else if (state is CVDownloadSuccess) {
          setState(() {
            isDownloading = false;
          });

          _downloadAndSavePDF(state.downloadUrl);
        } else if (state is CVDownloadError) {
          setState(() {
            isDownloading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Download error: ${state.error}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is CVDownloading) {
          setState(() {
            isDownloading = true;
          });
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: isGenerating ? _buildLoadingView() : _buildSuccessView(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: isGenerating ? null : _buildBottomBar(),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: bluePrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(bluePrimaryColor),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '🤖 AI sedang membuat CV kamu...',
            style: primaryTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semiBold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Proses ini memakan waktu beberapa detik',
            style: secondaryTextStyle.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: LinearProgressIndicator(
              backgroundColor: thirdColor,
              valueColor: AlwaysStoppedAnimation<Color>(bluePrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            resumeId != null
                ? "🎉 Yeay, CV Kamu Sudah Jadi!"
                : "⏳ Menunggu CV dibuat...",
            style: primaryTextStyle.copyWith(fontSize: 22, fontWeight: bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            resumeId != null
                ? "CV kamu sudah siap! Download sekarang dan mulai melamar pekerjaan impianmu."
                : "Tunggu sebentar ya, AI sedang membuat CV terbaikmu.",
            style: secondaryTextStyle.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          Expanded(child: _buildCVPreviewCard()),
        ],
      ),
    );
  }

  Widget _buildCVPreviewCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: thirdColor, width: 2),
          color: Colors.white,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // PDF Preview or Placeholder
            if (resumeLink != null && resumeLink!.isNotEmpty)
              _buildPDFPreview(resumeLink!)
            else
              _buildPlaceholder(),

            // Loading Overlay
            if (resumeId == null || isGenerating || isPdfLoading)
              _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFPreview(String pdfUrl) {
    if (localPdfPath != null && File(localPdfPath!).existsSync()) {
      return PDFView(
        filePath: localPdfPath!,
        enableSwipe: false,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: false,
        pageSnap: false,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        onError: (error) {
          debugPrint('PDF Error: $error');
        },
        onPageError: (page, error) {
          debugPrint('Page $page Error: $error');
        },
      );
    }

    return GestureDetector(
      onTap: () => _launchURL(pdfUrl),
      child: Container(
        color: const Color(0xFFF5F5F5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Tap untuk melihat CV',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'PDF Preview',
              style: secondaryTextStyle.copyWith(fontSize: 14),
            ),
          ],
        ),
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
              isPdfLoading ? 'Memuat preview...' : 'Membuat CV...',
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

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5FD),
          border: Border(top: BorderSide(color: thirdColor, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              resumeId != null
                  ? "🎉 Wow, kamu super duper kece! +$xpReward XP"
                  : "⏳ Tunggu sebentar ya...",
              style: primaryTextStyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomFilledButton(
                    title: isDownloading ? "Downloading..." : "Download CV",
                    variant: ButtonColorVariant.white,
                    onPressed:
                        (isGenerating || isDownloading || resumeId == null)
                        ? null
                        : _handleDownload,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomFilledButton(
                    title: "Selanjutnya",
                    variant: ButtonColorVariant.blue,
                    onPressed: isGenerating
                        ? null
                        : () {
                            Navigator.pop(context, true);
                          },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Submit XP to backend
  Future<void> _submitXPToBackend() async {
    if (_isSubmittingXP || _xpSubmitted) return;

    setState(() {
      _isSubmittingXP = true;
    });

    try {
      print('📤 Mengirim XP: $xpReward untuk Build CV');

      final response = await _apiClient.patch(
        ApiEndpoints.stats,
        body: {'xp': xpReward},
        requiresAuth: true,
      );

      print('📥 Response: $response');

      if (response['success'] == true) {
        final updatedXP = response['stats']?['xp'] ?? response['data']?['xp'];
        print('✅ XP berhasil ditambahkan: $xpReward (Total: $updatedXP)');

        setState(() {
          _xpSubmitted = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('XP +$xpReward berhasil ditambahkan! 🎉'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Gagal menambah XP: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingXP = false;
        });
      }
    }
  }

  // ✅ Update streak after completing CV
  Future<void> _updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';
    final lastStreakUpdateKey = 'last_streak_update_date';

    final lastUpdateDate = prefs.getString(lastStreakUpdateKey);

    print('🔥 Checking streak: Today=$todayKey, Last=$lastUpdateDate');

    if (lastUpdateDate != todayKey) {
      print('✅ First game completion today, updating streak...');

      final streakUpdated = await _streakService.updateStreak();

      if (streakUpdated && mounted) {
        context.read<ProfileBloc>().add(RefreshProfile());
        await prefs.setString(lastStreakUpdateKey, todayKey);
        print('🎉 Streak updated!');
      }
    }
  }

  void _handleDownload() {
    if (resumeLink != null && resumeLink!.isNotEmpty) {
      _downloadAndSavePDF(resumeLink!);
      widget.onDownload();
    } else if (resumeId != null) {
      context.read<BuildCVBloc>().add(DownloadCV(resumeId!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Resume ID tidak ditemukan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadAndSavePDF(String url) async {
    try {
      setState(() {
        isDownloading = true;
      });

      debugPrint('📥 Downloading PDF from: $url');
      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw 'Download timeout';
            },
          );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // ✅ Simpan di direktori aplikasi (aman tanpa izin)
        final dir = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'CV_Resume_$timestamp.pdf';
        final filePath = '${dir.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(bytes, flush: true);

        debugPrint('✅ PDF saved to: $filePath');

        if (mounted) {
          setState(() {
            isDownloading = false;
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
          isDownloading = false;
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

  Future<void> _downloadPdfForPreview(String url) async {
    if (!mounted) return;

    setState(() {
      isPdfLoading = true;
    });

    try {
      debugPrint('📥 Downloading PDF for preview from: $url');

      final response = await http
          .get(Uri.parse(url))
          .timeout(
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
            localPdfPath = file.path;
            isPdfLoading = false;
          });
          debugPrint('✅ PDF downloaded successfully: ${file.path}');
        }
      } else {
        throw 'HTTP ${response.statusCode}';
      }
    } catch (e) {
      debugPrint('❌ Error downloading PDF for preview: $e');
      if (mounted) {
        setState(() {
          isPdfLoading = false;
        });
      }
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        debugPrint('✅ Launched URL: $url');
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('❌ Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Tidak dapat membuka link: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _apiClient.dispose();
    if (localPdfPath != null) {
      try {
        final file = File(localPdfPath!);
        if (file.existsSync()) {
          file.deleteSync();
          debugPrint('🗑️ Temporary PDF deleted');
        }
      } catch (e) {
        debugPrint('⚠️ Error deleting temporary PDF: $e');
      }
    }
    super.dispose();
  }
}
