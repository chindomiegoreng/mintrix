import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:mintrix/features/game/presentation/pages/quiz/resume_page.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/features/game/data/services/youtube_services.dart';
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
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool isWatched = false;
  bool isLoadingVideo = false;
  String? directVideoUrl;

  @override
  void initState() {
    super.initState();
    _preloadVideo();
  }

  /// ✅ Preload video agar manifest sudah siap sebelum ditekan
  Future<void> _preloadVideo() async {
    setState(() => isLoadingVideo = true);
    final url = await getYoutubeDirectUrl(widget.videoUrl);
    if (!mounted) return;
    setState(() {
      directVideoUrl = url;
      isLoadingVideo = false;
    });
  }

  void _openVideoPlayer() async {
    if (directVideoUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video belum siap, coba lagi.')),
      );
      return;
    }

    final watched = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerPage(videoUrl: directVideoUrl!),
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
  final String videoUrl;

  const VideoPlayerPage({super.key, required this.videoUrl});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    await _videoController.initialize();
    if (!mounted) return;

    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        aspectRatio: _videoController.value.aspectRatio,
      );
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: const Text("Video", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.white),
            onPressed:
                _isInitialized ? () => Navigator.pop(context, true) : null,
          ),
        ],
      ),
      body: Align(
        alignment: const Alignment(0, -0.3),
        child: _isInitialized
            ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Chewie(controller: _chewieController!),
              )
            : const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
