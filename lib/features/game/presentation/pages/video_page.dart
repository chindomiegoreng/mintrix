import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:mintrix/features/game/presentation/pages/quiz/resume_page.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/features/game/data/services/youtube_services.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';

// ✅ Global cache untuk menyimpan URL yang sudah di-fetch
class VideoUrlCache {
  static final Map<String, String> _cache = {};
  
  static String? get(String youtubeUrl) => _cache[youtubeUrl];
  
  static void set(String youtubeUrl, String directUrl) {
    _cache[youtubeUrl] = directUrl;
  }
  
  static void clear() => _cache.clear();
}

class VideoPage extends StatefulWidget {
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnail;
  final String moduleId;
  final String sectionId;
  final String subSection;
  final int xpReward; // ✅ Add XP reward parameter

  const VideoPage({
    super.key,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnail,
    required this.moduleId,
    required this.sectionId,
    required this.subSection,
    this.xpReward = 80, // ✅ Default 80 XP
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool isWatched = false;
  bool isLoadingVideo = false;
  String? directVideoUrl;
  VideoPlayerController? _preloadedController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _preloadVideo();
  }

  /// ✅ Preload video dengan caching mechanism
  Future<void> _preloadVideo() async {
    setState(() {
      isLoadingVideo = true;
      _errorMessage = null;
    });
    
    try {
      String? url;
      
      // Cek cache terlebih dahulu
      url = VideoUrlCache.get(widget.videoUrl);
      
      if (url == null) {
        // Jika tidak ada di cache, fetch dari YouTube
        print('🔄 Fetching YouTube URL...');
        url = await getYoutubeDirectUrl(widget.videoUrl);
        
        if (url != null && url.isNotEmpty) {
          // Simpan ke cache
          VideoUrlCache.set(widget.videoUrl, url);
          print('✅ URL cached successfully');
        }
      } else {
        print('⚡ URL loaded from cache');
      }
      
      if (!mounted) return;
      
      // Validasi URL
      if (url == null || url.isEmpty) {
        throw Exception('URL video tidak valid');
      }
      
      // Initialize video controller di background
      print('🎬 Initializing video controller...');
      _preloadedController = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );
      
      // Initialize controller dengan timeout
      await _preloadedController!.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Timeout saat memuat video');
        },
      );
      
      if (!mounted) return;
      
      print('✅ Video ready to play');
      setState(() {
        directVideoUrl = url;
        isLoadingVideo = false;
      });
    } catch (e) {
      print('❌ Error: $e');
      if (!mounted) return;
      setState(() {
        isLoadingVideo = false;
        _errorMessage = 'Gagal memuat video: ${e.toString()}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat video: $e'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _preloadVideo,
          ),
        ),
      );
    }
  }

  void _openVideoPlayer() async {
    if (_preloadedController == null || directVideoUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Video belum siap, coba lagi.'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _preloadVideo,
          ),
        ),
      );
      return;
    }

    // Pass controller yang sudah diinisialisasi
    final watched = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerPage(
          videoController: _preloadedController!,
          videoUrl: directVideoUrl!,
        ),
      ),
    );

    // Jika video ditonton sampai selesai
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
    } else {
      _navigateToResume();
    }
  }

  void _navigateToResume() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResumePage(
          moduleId: widget.moduleId,
          sectionId: widget.sectionId,
          subSection: widget.subSection,
          xpReward: widget.xpReward,
        ),
      ),
    );
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
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
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
                          const Text(
                            'Gagal memuat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ElevatedButton(
                            onPressed: _preloadVideo,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(
                              'Coba Lagi',
                              style: TextStyle(fontSize: 12),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.description,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
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
  final String videoUrl;

  const VideoPlayerPage({
    super.key,
    required this.videoController,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late ChewieController _chewieController;

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
        if (didPop) widget.videoController.pause();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: const Text("Video", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.white),
            onPressed: _isInitialized
                ? () => Navigator.pop(context, true)
                : null,
          ),
          title: const Text("Video", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.white),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
        body: Column(
          children: [
            const Spacer(flex: 1), // sedikit ruang di atas
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
      ),
    );
  }
}