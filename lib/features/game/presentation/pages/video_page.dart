import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoPage extends StatefulWidget {
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnail;
  final String? moduleId; // Tambahkan parameter ini
  final String? sectionId; // Tambahkan parameter ini

  const VideoPage({
    super.key,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnail,
    this.moduleId, // Optional
    this.sectionId, // Optional
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool isWatched = false;
  bool isLoadingVideo = false;
  String? directVideoUrl;
  final YoutubeExplode _yt = YoutubeExplode();

  String extractYoutubeId(String url) {
    Uri uri = Uri.parse(url);
    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    }
    return uri.pathSegments.last.split('?').first;
  }

  Future<void> _prepareVideo() async {
    setState(() {
      isLoadingVideo = true;
    });

    try {
      final videoId = extractYoutubeId(widget.videoUrl);
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final streamInfo = manifest.muxed.bestQuality;

      if (!mounted) return;

      setState(() {
        directVideoUrl = streamInfo.url.toString();
        isLoadingVideo = false;
      });

      // Langsung buka video player
      _openVideoPlayer();
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        isLoadingVideo = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat video: $e')),
      );
    }
  }

  void _openVideoPlayer() async {
    if (directVideoUrl == null) return;

    final watched = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerPage(videoUrl: directVideoUrl!),
      ),
    );

    if (watched == true) {
      setState(() {
        isWatched = true;
      });
    }
  }

  // Cek apakah ini modul 2 bagian 1
  bool _isModule2Section1() {
    return widget.moduleId == "modul2" && widget.sectionId == "bagian1";
  }

  void _handleNext() {
    if (_isModule2Section1()) {
      // Arahkan ke BuildCVPage
      Navigator.pushNamed(context, '/buildCV');
    } else {
      // Arahkan ke QuizPage seperti biasa
      Navigator.pushNamed(context, '/quizPage');
    }
  }

  @override
  void dispose() {
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video"), centerTitle: true),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: isLoadingVideo ? null : _prepareVideo,
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
                        Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
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
                const Spacer(),
                CustomFilledButton(
                  title: "Selanjutnya",
                  variant: isWatched
                      ? ButtonColorVariant.blue
                      : ButtonColorVariant.secondary,
                  onPressed: isWatched ? _handleNext : null,
                  withShadow: isWatched,
                ),
              ],
            ),
          ),
        ],
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
        title: const Text(
          "Video",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.white),
            onPressed: _isInitialized
                ? () => Navigator.pop(context, true)
                : null,
          ),
        ],
      ),
      body: Align(
        alignment: Alignment(0, -0.3),
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