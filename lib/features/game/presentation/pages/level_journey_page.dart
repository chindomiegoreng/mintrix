import 'package:flutter/material.dart';
import 'package:mintrix/features/game/presentation/pages/video/video_page.dart';
import 'package:mintrix/features/game/presentation/pages/quiz/quiz_page.dart';
import 'package:mintrix/widgets/buttons.dart';

class LevelJourneyPage extends StatefulWidget {
  final String moduleId;
  final String sectionId;

  const LevelJourneyPage({
    super.key,
    required this.moduleId,
    required this.sectionId,
  });

  @override
  State<LevelJourneyPage> createState() => _LevelJourneyPageState();
}

class _LevelJourneyPageState extends State<LevelJourneyPage> {
  Map<String, bool> platformStatus = {
    'platform1': false,
    'platform2': false,
    'platform3': false,
  };

  // Mendapatkan data video berdasarkan modul dan section
  Map<String, dynamic> _getVideoData() {
    if (widget.moduleId == "modul1" && widget.sectionId == "bagian1") {
      return {
        "title": "Mengenal Minat Dan Bakat",
        "description":
            "Membahas cara mengidentifikasi minat dan bakat yang selaras dengan karakteristik kepribadian seseorang.",
        "videoDescription":
            "Video ini berisikan materi terkait mengenal minat dan bakat yang selaras dengan karakteristik kepribadian seseorang.",
        "videoUrl": "https://youtu.be/TjPhzgxe3L0?si=G3a6-fqbPu3ZikzA",
        "thumbnail": "assets/images/home_card_large.png",
        "characterImage": "assets/images/dino_reading.png",
        "ballImage": "assets/images/dino_ball.png",
      };
    } else if (widget.moduleId == "modul2" && widget.sectionId == "bagian1") {
      return {
        "title": "Persiapan Karir",
        "description":
            "Membahas langkah-langkah persiapan karir yang efektif untuk masa depan yang lebih cerah.",
        "videoDescription":
            "Video ini berisikan materi terkait persiapan karir dan strategi memasuki dunia kerja.",
        "videoUrl": "https://youtu.be/TjPhzgxe3L0?si=G3a6-fqbPu3ZikzA",
        "thumbnail": "assets/images/home_card_large.png",
        "characterImage": "assets/images/dino_learn.png",
        "ballImage": "assets/images/dino_career.png",
      };
    }

    // Default data
    return {
      "title": "Coming Soon",
      "description": "Konten akan segera hadir.",
      "videoDescription": "Video akan segera tersedia.",
      "videoUrl": "",
      "thumbnail": "assets/images/default_thumbnail.png",
      "characterImage": "assets/images/dino_reading.png",
      "ballImage": "assets/images/dino_ball.png",
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final videoData = _getVideoData();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const JourneyHeader(),
            Expanded(
              child: SizedBox(
                width: screenWidth,
                height: screenHeight,
                child: Stack(
                  children: [
                    CustomPaint(size: Size(screenWidth, screenHeight)),

                    Positioned(
                      top: 60,
                      left: 200,
                      child: _buildSmallPlatform(
                        isActive: true,
                        context: context,
                      ),
                    ),

                    Positioned(
                      top: 120,
                      left: 40,
                      child: _buildLargePlatform(
                        platformStatus['platform1']!
                            ? StageType.active
                            : StageType.incoming,
                        context,
                        platformKey: 'platform1',
                        videoData: videoData,
                      ),
                    ),

                    Positioned(
                      top: 225,
                      left: 90,
                      child: _buildSmallPlatform(
                        isActive: false,
                        context: context,
                      ),
                    ),

                    Positioned(
                      top: 285,
                      right: 160,
                      child: _buildSmallPlatform(
                        isActive: false,
                        context: context,
                      ),
                    ),

                    Positioned(
                      top: 330,
                      right: 35,
                      child: _buildLargePlatform(
                        platformStatus['platform2']!
                            ? StageType.active
                            : StageType.inactive,
                        context,
                        platformKey: 'platform2',
                        videoData: videoData,
                      ),
                    ),

                    Positioned(
                      top: 500,
                      right: 40,
                      child: _buildSmallPlatform(
                        isActive: false,
                        context: context,
                      ),
                    ),

                    Positioned(
                      top: 570,
                      right: 150,
                      child: _buildSmallPlatform(
                        isActive: false,
                        context: context,
                      ),
                    ),

                    Positioned(
                      top: 650,
                      left: 30,
                      child: _buildLargePlatform(
                        platformStatus['platform3']!
                            ? StageType.active
                            : StageType.inactive,
                        context,
                        platformKey: 'platform3',
                        videoData: videoData,
                      ),
                    ),

                    Positioned(
                      top: -10,
                      right: 10,
                      child: _buildCharacterStage(
                        context,
                        imagePath: videoData["ballImage"],
                        stageType: StageType.active,
                      ),
                    ),

                    Positioned(
                      top: 340,
                      left: 30,
                      child: _buildCharacterStage(
                        context,
                        imagePath: videoData["characterImage"],
                        stageType: StageType.completed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterStage(
    BuildContext context, {
    required String imagePath,
    required StageType stageType,
  }) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Image.asset(imagePath, fit: BoxFit.contain),
    );
  }

  Widget _buildLargePlatform(
    StageType stageType,
    BuildContext context, {
    required String platformKey,
    required Map<String, dynamic> videoData,
  }) {
    late String asset;

    switch (stageType) {
      case StageType.active:
      case StageType.inProgress:
        asset = "assets/images/platform_large_active.png";
        break;
      case StageType.incoming:
        asset = "assets/images/platform_large_incoming.png";
        break;
      case StageType.inactive:
      case StageType.completed:
        asset = "assets/images/platform_large_inactive.png";
        break;
    }

    return GestureDetector(
      onTap: () {
        _showLessonPopup(
          context,
          title: videoData["title"],
          description: videoData["description"],
          onStart: () {
            setState(() {
              platformStatus[platformKey] = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoPage(
                  title: videoData["title"],
                  description: videoData["videoDescription"],
                  videoUrl: videoData["videoUrl"],
                  thumbnail: videoData["thumbnail"],
                ),
              ),
            );
          },
        );
      },
      child: Image.asset(asset, width: 110, height: 70, fit: BoxFit.contain),
    );
  }

  Widget _buildSmallPlatform({
    required bool isActive,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => QuizPage()));
      },
      child: Image.asset(
        isActive
            ? "assets/images/platform_small_active.png"
            : "assets/images/platform_small_inactive.png",
        width: 60,
        height: 35,
        fit: BoxFit.contain,
      ),
    );
  }

  void _showLessonPopup(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onStart,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xFF7DD3F7),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                CustomFilledButton(
                  title: "Mulai +80 XP",
                  variant: ButtonColorVariant.white,
                  height: 50,
                  onPressed: () {
                    Navigator.pop(context);
                    onStart();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum StageType { active, inProgress, completed, incoming, inactive }

class JourneyHeader extends StatelessWidget {
  const JourneyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          Row(
            children: [
              Icon(Icons.local_fire_department, color: Colors.grey, size: 22),
              SizedBox(width: 4),
              Text(
                "4",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.ac_unit, color: Colors.lightBlueAccent, size: 22),
              SizedBox(width: 4),
              Text(
                "200",
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            "XP 520",
            style: TextStyle(
              color: Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Tidak dihapus sesuai permintaan
// class _JourneyPathPainter extends CustomPainter {
//   final double screenWidth;
//   _JourneyPathPainter(this.screenWidth);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFFB8C5D6)
//       ..strokeWidth = 3
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     final path = Path()
//       ..moveTo(230, 77.5);

//     ...
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
