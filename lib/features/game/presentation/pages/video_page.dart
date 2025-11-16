import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/services/streak_service.dart';
import 'package:mintrix/features/game/presentation/pages/quiz/resume_page.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_event.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';

class VideoPage extends StatefulWidget {
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnail;
  final String? moduleId;
  final String? sectionId;
  final String? subSection;

  const VideoPage({
    super.key,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnail,
    this.moduleId,
    this.sectionId,
    this.subSection,
    required int xpReward,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool isWatched = false;
  bool isLoadingVideo = false;
  VideoPlayerController? _preloadedController;
  String? _errorMessage;
  final StreakService _streakService = StreakService();
  int _retryCount = 0;
  static const int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _preloadVideo();
  }

  /// ✅ Preload video langsung dari Cloudinary
  Future<void> _preloadVideo() async {
    if (_retryCount >= _maxRetries) {
      setState(() {
        _errorMessage = 'Gagal memuat video setelah $_maxRetries kali percobaan';
        isLoadingVideo = false;
      });
      return;
    }

    setState(() {
      isLoadingVideo = true;
      _errorMessage = null;
    });

    try {
      print('🎬 Loading video from Cloudinary... (attempt ${_retryCount + 1})');
      
      // ✅ Langsung gunakan URL Cloudinary tanpa konversi
      final cloudinaryUrl = widget.videoUrl;

      if (cloudinaryUrl.isEmpty) {
        throw Exception('URL video tidak valid');
      }

      if (!mounted) return;

      // ✅ Initialize controller dengan Cloudinary URL
      print('🎬 Initializing video controller...');
      _preloadedController = VideoPlayerController.networkUrl(
        Uri.parse(cloudinaryUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      // ✅ Initialize dengan timeout
      await _preloadedController!.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Timeout saat memuat video');
        },
      );

      if (!mounted) return;

      print('✅ Video ready to play');
      setState(() {
        isLoadingVideo = false;
        _retryCount = 0;
      });
    } catch (e) {
      print('❌ Error (attempt ${_retryCount + 1}): $e');
      _retryCount++;
      
      if (!mounted) return;

      // ✅ Auto-retry untuk network errors
      if (_retryCount < _maxRetries && 
          (e.toString().contains('Timeout') || 
           e.toString().contains('Network') ||
           e.toString().contains('Connection'))) {
        print('🔄 Auto-retrying in 2 seconds...');
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _preloadVideo();
        }
        return;
      }

      setState(() {
        isLoadingVideo = false;
        _errorMessage = _retryCount >= _maxRetries 
            ? 'Gagal memuat video setelah $_maxRetries percobaan'
            : 'Gagal memuat video: ${e.toString()}';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            duration: const Duration(seconds: 4),
            action: _retryCount < _maxRetries
                ? SnackBarAction(
                    label: 'Retry',
                    onPressed: () {
                      _retryCount = 0;
                      _preloadVideo();
                    },
                  )
                : null,
          ),
        );
      }
    }
  }

  void _openVideoPlayer() async {
    if (_preloadedController == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Video belum siap, coba lagi.'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              _retryCount = 0;
              _preloadVideo();
            },
          ),
        ),
      );
      return;
    }

    final watched = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerPage(
          videoController: _preloadedController!,
          onVideoComplete: onVideoComplete,
        ),
      ),
    );

    if (watched == true) {
      setState(() => isWatched = true);
    }
  }

  bool _isModule2Section1() {
    return widget.moduleId == "modul2" && widget.sectionId == "bagian1";
  }

  void _handleNext() {
    if (_isModule2Section1()) {
      Navigator.pushNamed(context, '/build-cv');
    } else if (widget.moduleId != null &&
        widget.sectionId != null &&
        widget.subSection != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResumePage(
            moduleId: widget.moduleId!,
            sectionId: widget.sectionId!,
            subSection: widget.subSection!,
          ),
        ),
      );
    } else {
      Navigator.pushNamed(context, '/quizPage');
    }
  }

  Future<void> onVideoComplete() async {
    print('✅ Video completed!');

    print('🎮 Video watched, updating streak...');
    final streakUpdated = await _streakService.updateStreak();

    if (streakUpdated && mounted) {
      context.read<ProfileBloc>().add(RefreshProfile());
      print('🔥 Streak updated after video completion!');
    }

    if (mounted) {
      setState(() => isWatched = true);
    }

    if (_isModule2Section1()) {
      if (mounted) Navigator.pushNamed(context, '/build-cv');
    } else if (widget.moduleId != null &&
        widget.sectionId != null &&
        widget.subSection != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResumePage(
              moduleId: widget.moduleId!,
              sectionId: widget.sectionId!,
              subSection: widget.subSection!,
            ),
          ),
        );
      }
    } else {
      if (mounted) Navigator.pushNamed(context, '/quizPage');
    }
  }

  @override
  void dispose() {
    _preloadedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: isLoadingVideo ? null : _openVideoPlayer,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.thumbnail,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isLoadingVideo)
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade700,
                      highlightColor: Colors.grey.shade500,
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(color: Colors.white),
                            const SizedBox(height: 12),
                            Text(
                              'Memuat video${_retryCount > 0 ? " (retry $_retryCount)" : ""}...',
                              style: whiteTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gagal memuat',
                            style: whiteTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: medium,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ElevatedButton(
                            onPressed: () {
                              _retryCount = 0;
                              _preloadVideo();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              'Coba Lagi',
                              style: secondaryTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: semiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style: secondaryTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.description,
                style: primaryTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: semiBold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: CustomFilledButton(
            title: "Selanjutnya",
            variant: isWatched
                ? ButtonColorVariant.blue
                : ButtonColorVariant.secondary,
            onPressed: isWatched ? _handleNext : null,
            withShadow: isWatched,
          ),
        ),
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final VideoPlayerController videoController;
  final VoidCallback onVideoComplete;

  const VideoPlayerPage({
    super.key,
    required this.videoController,
    required this.onVideoComplete,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late ChewieController _chewieController;
  double _sliderValue = 0.0;
  bool _isSliding = false;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
      aspectRatio: widget.videoController.value.aspectRatio,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error: $errorMessage',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCompletionDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: bluePrimaryColor,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  "Konfirmasi Pemahaman",
                  style: primaryTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Yakin telah paham dengan materi ini?",
                  style: secondaryTextStyle.copyWith(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: bluePrimaryColor,
                            width: 1.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Belum",
                          style: bluePrimaryTextStyle.copyWith(
                            fontSize: 15,
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bluePrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Yakin",
                          style: whiteTextStyle.copyWith(
                            fontSize: 15,
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      widget.videoController.pause();
      await _updateStreakOnly();
      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      setState(() {
        _sliderValue = 0.0;
        _isSliding = false;
      });
    }
  }

  Future<void> _updateStreakOnly() async {
    print('✅ Video completed!');
    print('🎮 Video watched, updating streak...');
    
    final streakService = StreakService();
    final streakUpdated = await streakService.updateStreak();

    if (streakUpdated && mounted) {
      context.read<ProfileBloc>().add(RefreshProfile());
      print('🔥 Streak updated after video completion!');
    }
  }

  void _onSlideUpdate(double value) {
    setState(() {
      _sliderValue = value;
      _isSliding = value > 0;
    });

    if (value >= 0.95) {
      _showCompletionDialog();
    }
  }

  @override
  void dispose() {
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          widget.videoController.pause();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              widget.videoController.pause();
              Navigator.pop(context, false);
            },
          ),
          title: const Text("Video", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const Spacer(flex: 1),
            Align(
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: widget.videoController.value.aspectRatio,
                child: Chewie(controller: _chewieController),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: _isSliding ? Colors.blue.shade400 : Colors.grey.shade600,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isSliding 
                            ? 'Geser ke kanan untuk selesai' 
                            : 'Sudah paham? Geser untuk selesai',
                        style: TextStyle(
                          color: _isSliding ? Colors.white : Colors.grey.shade400,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: 56,
                      width: MediaQuery.of(context).size.width * 0.88 * _sliderValue,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade700,
                            Colors.blue.shade400,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        final box = context.findRenderObject() as RenderBox;
                        final localPosition = box.globalToLocal(details.globalPosition);
                        final value = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
                        _onSlideUpdate(value);
                      },
                      onHorizontalDragEnd: (details) {
                        if (_sliderValue < 0.95) {
                          setState(() {
                            _sliderValue = 0.0;
                            _isSliding = false;
                          });
                        }
                      },
                      child: Container(
                        height: 56,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          left: (MediaQuery.of(context).size.width * 0.88 * _sliderValue)
                              .clamp(0.0, MediaQuery.of(context).size.width * 0.88 - 56),
                        ),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: _isSliding ? Colors.blue.shade700 : Colors.grey.shade600,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}