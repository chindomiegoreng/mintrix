import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mintrix/features/game/presentation/pages/video_page.dart';
import 'package:mintrix/features/game/presentation/pages/quiz/quiz_page.dart';
import 'package:mintrix/widgets/buttons.dart';

class LevelJourneyPage extends StatefulWidget {
  final String moduleId;
  final String sectionId;
  final int lessonIndex;

  const LevelJourneyPage({
    super.key,
    required this.moduleId,
    required this.sectionId,
    required this.lessonIndex,
  });

  @override
  State<LevelJourneyPage> createState() => _LevelJourneyPageState();
}

class _LevelJourneyPageState extends State<LevelJourneyPage> {
  Map<String, bool> platformStatus = {};

  @override
  void initState() {
    super.initState();
    _loadPlatformStatus();
  }

  Future<void> _loadPlatformStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final lessonKey =
        "${widget.moduleId}_${widget.sectionId}_${widget.lessonIndex}";

    setState(() {
      platformStatus = {
        'platform1': prefs.getBool('${lessonKey}_platform1') ?? false,
        'platform2': prefs.getBool('${lessonKey}_platform2') ?? false,
        'platform3': prefs.getBool('${lessonKey}_platform3') ?? false,
      };
    });
  }

  Future<void> _savePlatformStatus(String platformKey, bool status) async {
    final prefs = await SharedPreferences.getInstance();
    final lessonKey =
        "${widget.moduleId}_${widget.sectionId}_${widget.lessonIndex}";
    await prefs.setBool('${lessonKey}_$platformKey', status);

    // Update lesson completion jika semua platform selesai
    await _updateLessonCompletion();
  }

  Future<void> _updateLessonCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    final lessonKey =
        "${widget.moduleId}_${widget.sectionId}_${widget.lessonIndex}";

    // Cek apakah semua platform sudah selesai
    bool allCompleted = platformStatus.values.every((completed) => completed);

    if (allCompleted) {
      await prefs.setBool(lessonKey, true);

      // Update section progress
      await _updateSectionProgress();
    }
  }

  Future<void> _updateSectionProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final sectionKey = "${widget.moduleId}_${widget.sectionId}";

    // Hitung berapa lesson yang sudah selesai di section ini
    int completedLessons = 0;
    int totalLessons = _getTotalLessonsInSection();

    for (int i = 0; i < totalLessons; i++) {
      String lessonKey = "${widget.moduleId}_${widget.sectionId}_$i";
      if (prefs.getBool(lessonKey) ?? false) {
        completedLessons++;
      }
    }

    double progress = completedLessons / totalLessons;
    await prefs.setDouble('${sectionKey}_progress', progress);
  }

  int _getTotalLessonsInSection() {
    if (widget.moduleId == "modul1" && widget.sectionId == "bagian1") {
      return 3; // 3 lessons
    } else if (widget.moduleId == "modul2" && widget.sectionId == "bagian1") {
      return 1; // 1 lesson
    }
    return 1;
  }

  Map<String, dynamic> _getVideoData() {
    if (widget.moduleId == "modul1" && widget.sectionId == "bagian1") {
      return {
        "title": "Mengenal Minat Dan Bakat",
        "description":
            "Membahas cara mengidentifikasi minat dan bakat yang selaras dengan karakteristik kepribadian seseorang.",
        "videoDescription":
            "Video ini berisikan materi terkait mengenal minat dan bakat yang selaras dengan karakteristik kepribadian seseorang.",
        "videoUrl": "https://youtu.be/JA8SjQ334CQ",
        "thumbnail": "assets/images/home_card_large.png",
        "characterImage":
            "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846596/character6_f99qfe.png",
        "ballImage":
            "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846596/character7_ejiapi.png",
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
        "characterImage":
            "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846592/character3_f6ngcd.png",
        "ballImage":
            "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846591/character2_h9dbhr.png",
      };
    }

    return {
      "title": "Coming Soon",
      "description": "Konten akan segera hadir.",
      "videoDescription": "Video akan segera tersedia.",
      "videoUrl": "",
      "thumbnail": "assets/images/default_thumbnail.png",
      "characterImage":
          "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846596/character6_f99qfe.png",
      "ballImage":
          "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846596/character7_ejiapi.png",
    };
  }

  List<Map<String, dynamic>> _getPlatformData() {
    if (widget.moduleId == "modul1" && widget.sectionId == "bagian1") {
      return [
        {
          "key": "platform1",
          "hasVideo": true,
          "title": "Mencari Hal Yang Kamu Suka",
          "description":
              "Membahas cara mengidentifikasi minat dan bakat yang selaras dengan karakteristik kepribadian seseorang.",
          "subSection": "mencari_hal_yang_kamu_suka",
        },
        {
          "key": "platform2",
          "hasVideo": false,
          "title": "Mengatur Waktu",
          "description":
              "Belajar manajemen waktu yang efektif untuk produktivitas optimal.",
          "subSection": "mengatur_waktu",
        },
        {
          "key": "platform3",
          "hasVideo": false,
          "title": "Berpikir Positif",
          "description":
              "Membangun mindset positif untuk menghadapi tantangan.",
          "subSection": "berpikir_positif",
        },
      ];
    }

    if (widget.moduleId == "modul2" && widget.sectionId == "bagian1") {
      return [
        {
          "key": "platform1",
          "hasVideo": true,
          "title": "Persiapan Karir",
          "description":
              "Membahas langkah-langkah persiapan karir yang efektif untuk masa depan yang lebih cerah.",
          "subSection": "persiapan_karir",
        },
        {
          "key": "platform2",
          "hasVideo": false,
          "title": "default",
          "description": "default",
          "subSection": "default",
        },
        {
          "key": "platform3",
          "hasVideo": false,
          "title": "default",
          "description": "default",
          "subSection": "default",
        },
      ];
    }

    return [
      {
        "key": "platform1",
        "hasVideo": false,
        "title": "Coming Soon",
        "description": "Konten akan segera hadir.",
        "subSection": "default",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final videoData = _getVideoData();
    final platformDataList = _getPlatformData();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
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
                        left: 170,
                        child: _buildSmallPlatform(
                          isActive: true,
                          context: context,
                        ),
                      ),

                      if (platformDataList.isNotEmpty)
                        Positioned(
                          top: 120,
                          left: 40,
                          child: _buildLargePlatform(
                            (platformStatus[platformDataList[0]["key"]] ??
                                    false)
                                ? StageType.active
                                : StageType.incoming,
                            context,
                            platformData: platformDataList[0],
                            videoData: videoData,
                          ),
                        ),

                      if (platformDataList.length > 1)
                        Positioned(
                          top: 225,
                          left: 90,
                          child: _buildSmallPlatform(
                            isActive:
                                (platformStatus[platformDataList[1]["key"]] ??
                                false),
                            context: context,
                            platformData: platformDataList[1],
                            videoData: videoData,
                          ),
                        )
                      else
                        Positioned(
                          top: 225,
                          left: 90,
                          child: _buildSmallPlatform(
                            isActive: false,
                            context: context,
                          ),
                        ),

                      if (platformDataList.length > 2)
                        Positioned(
                          top: 285,
                          right: 160,
                          child: _buildSmallPlatform(
                            isActive:
                                (platformStatus[platformDataList[2]["key"]] ??
                                false),
                            context: context,
                            platformData: platformDataList[2],
                            videoData: videoData,
                          ),
                        )
                      else
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
                          (platformDataList.length > 1 &&
                                  (platformStatus[platformDataList[1]["key"]] ??
                                      false))
                              ? StageType.active
                              : StageType.inactive,
                          context,
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
                          (platformDataList.length > 2 &&
                                  (platformStatus[platformDataList[2]["key"]] ??
                                      false))
                              ? StageType.active
                              : StageType.inactive,
                          context,
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
      ),
    );
  }

  // Widget _buildCharacterStage(
  //   BuildContext context, {
  //   required String imagePath,
  //   required StageType stageType,
  // }) {
  //   return SizedBox(
  //     width: 180,
  //     height: 180,
  //     child: Image.asset(imagePath, fit: BoxFit.contain),
  //   );
  // }

  Widget _buildCharacterStage(
    BuildContext context, {
    required String imagePath,
    required StageType stageType,
  }) {
    return SizedBox(
      width: 180,
      height: 180,
      child: CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.contain,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildLargePlatform(
    StageType stageType,
    BuildContext context, {
    Map<String, dynamic>? platformData,
    Map<String, dynamic>? videoData,
  }) {
    late String asset;
    bool hasData = platformData != null && videoData != null;

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
    if (!hasData) {
      return Image.asset(asset, width: 110, height: 70, fit: BoxFit.contain);
    }

    return GestureDetector(
      onTap: () {
        bool isLocked = stageType == StageType.inactive;
        if (isLocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Selesaikan modul sebelumnya terlebih dahulu!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        _showLessonPopup(
          context,
          title: platformData["title"],
          description: platformData["description"],
          onStart: () async {
            setState(() {
              platformStatus[platformData["key"]] = true;
            });

            await _savePlatformStatus(platformData["key"], true);

            if (platformData["hasVideo"]) {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPage(
                    title: videoData["title"],
                    description: videoData["videoDescription"],
                    videoUrl: videoData["videoUrl"],
                    thumbnail: videoData["thumbnail"],
                    moduleId: widget.moduleId,
                    sectionId: widget.sectionId,
                    subSection: platformData["subSection"],
                  ),
                ),
              );

              if (result == true) {
                _loadPlatformStatus();
              }
            } else {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizPage(
                    moduleId: widget.moduleId,
                    sectionId: widget.sectionId,
                    subSection: platformData["subSection"],
                  ),
                ),
              );

              if (result == true) {
                _loadPlatformStatus();
              }
            }
          },
        );
      },
      child: Image.asset(asset, width: 110, height: 70, fit: BoxFit.contain),
    );
  }

  Widget _buildSmallPlatform({
    required bool isActive,
    required BuildContext context,
    Map<String, dynamic>? platformData,
    Map<String, dynamic>? videoData,
  }) {
    return GestureDetector(
      onTap: () {
        if (platformData != null && videoData != null) {
          String platformKey = platformData["key"];
          bool isPreviousCompleted = _isPreviousPlatformCompleted(platformKey);

          if (!isPreviousCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Selesaikan modul sebelumnya terlebih dahulu!'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }

          _showLessonPopup(
            context,
            title: platformData["title"],
            description: platformData["description"],
            onStart: () async {
              setState(() {
                platformStatus[platformData["key"]] = true;
              });

              await _savePlatformStatus(platformData["key"], true);

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizPage(
                    moduleId: widget.moduleId,
                    sectionId: widget.sectionId,
                    subSection: platformData["subSection"],
                  ),
                ),
              );

              if (result == true) {
                _loadPlatformStatus();
              }
            },
          );
        }
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

  bool _isPreviousPlatformCompleted(String currentPlatformKey) {
    if (currentPlatformKey == "platform1") {
      return true;
    } else if (currentPlatformKey == "platform2") {
      return platformStatus["platform1"] ?? false;
    } else if (currentPlatformKey == "platform3") {
      return platformStatus["platform2"] ?? false;
    }
    return false;
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
          backgroundColor: const Color(0xFF7DD3F7),
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
