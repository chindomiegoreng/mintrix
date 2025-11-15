import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ✅ Add this
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/game_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mintrix/features/game/presentation/pages/video_page.dart';
import 'package:mintrix/features/game/presentation/pages/quiz/quiz_page.dart';
import 'package:mintrix/features/game/presentation/pages/buildcv/build_cv_page.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_bloc.dart'; // ✅ Add this
import 'package:mintrix/features/profile/presentation/bloc/profile_event.dart'; // ✅ Add this
import 'package:mintrix/features/navigation/presentation/bloc/navigation_bloc.dart';
import 'package:mintrix/features/navigation/presentation/bloc/navigation_event.dart';
import 'package:mintrix/features/navigation/presentation/bloc/navigation_state.dart';

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
  Map<String, bool> subSectionFirstTimeCompleted = {}; // ✅ Track by subSection

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
      // ✅ Load status untuk semua 7 platform
      platformStatus = {
        'platform1': prefs.getBool('${lessonKey}_platform1') ?? false,
        'platform2': prefs.getBool('${lessonKey}_platform2') ?? false,
        'platform3': prefs.getBool('${lessonKey}_platform3') ?? false,
        'platform4': prefs.getBool('${lessonKey}_platform4') ?? false,
        'platform5': prefs.getBool('${lessonKey}_platform5') ?? false,
        'platform6': prefs.getBool('${lessonKey}_platform6') ?? false,
        'platform7': prefs.getBool('${lessonKey}_platform7') ?? false,
      };
    });

    // ✅ Load first time completion status for ALL subSections
    final allSubSections = [
      'mencari_hal_yang_kamu_suka_video',
      'mencari_hal_yang_kamu_suka_quiz1',
      'mencari_hal_yang_kamu_suka_quiz2',
      'mencari_hal_yang_kamu_suka_quiz3',
      'mencari_hal_yang_kamu_suka_quiz4',
      'mencari_hal_yang_kamu_suka_quiz5',
      'mencari_hal_yang_kamu_suka_quiz6',
      'mengatur_waktu_video',
      'mengatur_waktu_quiz1',
      'mengatur_waktu_quiz2',
      'mengatur_waktu_quiz3',
      'mengatur_waktu_quiz4',
      'mengatur_waktu_quiz5',
      'mengatur_waktu_quiz6',
      'berpikir_positif_video',
      'berpikir_positif_quiz1',
      'berpikir_positif_quiz2',
      'berpikir_positif_quiz3',
      'berpikir_positif_quiz4',
      'berpikir_positif_quiz5',
      'berpikir_positif_quiz6',
      'persiapan_karir',
    ];

    for (var subSection in allSubSections) {
      final key =
          'first_completed_${widget.moduleId}_${widget.sectionId}_$subSection';
      final isCompleted = prefs.getBool(key) ?? false;
      subSectionFirstTimeCompleted[subSection] = isCompleted;
      print('📖 Loaded: $key = $isCompleted');
    }

    print('📊 All first-time status: $subSectionFirstTimeCompleted');

    // ✅ After loading, show auto-popup for next available platform
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowAutoPopup();
    });
  }

  /// 🎯 Automatically show popup for the next available (unlocked, not completed) platform
  void _maybeShowAutoPopup() {
    try {
      final platformDataList = _getPlatformData();
      if (platformDataList.isEmpty) return;

      print('🔍 Looking for next available platform to auto-show...');

      // Find the first platform that is:
      // 1. Unlocked (previous platform completed OR platform1)
      // 2. Not yet completed by user
      for (var platformData in platformDataList) {
        final key = platformData['key'] as String?;
        if (key == null) continue;

        // Skip if already completed
        if (platformStatus[key] == true) {
          print('   ⏭️ $key already completed, skipping');
          continue;
        }

        // Check if unlocked
        if (!_isPreviousPlatformCompleted(key)) {
          print('   🔒 $key is locked, stopping search');
          break; // Stop at first locked platform
        }

        // Found the next platform to play!
        final subSection = platformData['subSection'] as String? ?? '';
        if (subSection == 'default' || subSection.isEmpty) {
          print('   ⚠️ $key has no valid subSection, skipping');
          continue;
        }

        final isFirstTime = _isFirstTimePlay(subSection);
        final xpReward = isFirstTime ? 80 : 2;

        print('🎯 Auto-showing popup for: $key (subSection: $subSection)');
        print('   First Time: $isFirstTime, XP: $xpReward');

        // Show the popup
        _showLessonPopup(
          context,
          title: platformData['title'] ?? '',
          description: platformData['description'] ?? '',
          xpReward: xpReward,
          isReplay: !isFirstTime,
          onStart: () async {
            print('🚀 Auto-popup: Mulai button pressed!');

            // Mark first time if needed
            if (isFirstTime) {
              await _markSubSectionAsPlayed(subSection);
              await _checkAndUpdateStreak();
            }

            setState(() {
              platformStatus[key] = true;
            });

            await _savePlatformStatus(key, true);

            // Navigate based on platform type
            if (widget.moduleId == 'modul2' &&
                widget.sectionId == 'bagian1' &&
                subSection == 'persiapan_karir') {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BuildCVPage()),
              );

              if (result == true) {
                _loadPlatformStatus();
              }
            } else if (platformData['hasVideo'] == true) {
              final videoData = platformData['videoData'] ?? _getVideoData();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPage(
                    title: videoData['title'] ?? '',
                    description: videoData['videoDescription'] ?? '',
                    videoUrl: videoData['videoUrl'] ?? '',
                    thumbnail: videoData['thumbnail'] ?? '',
                    moduleId: widget.moduleId,
                    sectionId: widget.sectionId,
                    subSection: subSection,
                    xpReward: xpReward,
                  ),
                ),
              );

              if (result == true) {
                _loadPlatformStatus();
              }
            } else {
              // Navigate to quiz
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizPage(
                    moduleId: widget.moduleId,
                    sectionId: widget.sectionId,
                    subSection: subSection,
                    xpReward: xpReward,
                  ),
                ),
              );

              if (result == true) {
                _loadPlatformStatus();
              }
            }
          },
        );

        // Only show popup for ONE platform (the next available one)
        break;
      }

      print('✅ Auto-popup check completed');
    } catch (e) {
      print('❌ Failed to auto-show popup: $e');
    }
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
        "videoUrl": "https://res.cloudinary.com/dy4hqxkv1/video/upload/v1763188431/submodul1_outxfm.mp4",
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
        "videoUrl": "https://res.cloudinary.com/dy4hqxkv1/video/upload/v1763188431/submodul1_outxfm.mp4",
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
    // 🎯 Lesson 0: Mencari Hal Yang Kamu Suka
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.lessonIndex == 0) {
      return [
        {
          "key": "platform1",
          "hasVideo": true,
          "title": "Mengenal Minat Dan Bakat",
          "description":
              "Membahas cara mengidentifikasi minat dan bakat yang selaras dengan karakteristik kepribadian seseorang.",
          "subSection": "mencari_hal_yang_kamu_suka_video",
          "videoData": {
            "title": "Mengenal Minat Dan Bakat",
            "videoDescription":
                "Video ini berisikan materi terkait mengenal minat dan bakat yang selaras dengan karakteristik kepribadian seseorang.",
            "videoUrl": "https://res.cloudinary.com/dy4hqxkv1/video/upload/v1763188431/submodul1_outxfm.mp4",
            "thumbnail": "assets/images/home_card_large.png",
          },
        },
        {
          "key": "platform2",
          "hasVideo": false,
          "title": "Quiz: Mengenal Minat",
          "description":
              "Uji pemahamanmu tentang cara menemukan minat dan bakat.",
          "subSection": "mencari_hal_yang_kamu_suka_quiz1",
        },
        {
          "key": "platform3",
          "hasVideo": false,
          "title": "Quiz: Eksplorasi Diri",
          "description":
              "Kenali lebih dalam tentang passion dan kelebihan dirimu.",
          "subSection": "mencari_hal_yang_kamu_suka_quiz2",
        },
        {
          "key": "platform4",
          "hasVideo": false,
          "title": "Quiz: Menemukan Passion",
          "description":
              "Cari tahu apa yang benar-benar membuatmu bersemangat.",
          "subSection": "mencari_hal_yang_kamu_suka_quiz3",
        },
        {
          "key": "platform5",
          "hasVideo": false,
          "title": "Quiz: Potensi Diri",
          "description": "Gali potensi tersembunyi yang ada dalam dirimu.",
          "subSection": "mencari_hal_yang_kamu_suka_quiz4",
        },
        {
          "key": "platform6",
          "hasVideo": false,
          "title": "Quiz: Karir Impian",
          "description": "Temukan karir yang sesuai dengan minat dan bakatmu.",
          "subSection": "mencari_hal_yang_kamu_suka_quiz5",
        },
        {
          "key": "platform7",
          "hasVideo": false,
          "title": "Quiz: Pengembangan Minat",
          "description": "Strategi mengembangkan minat menjadi keahlian.",
          "subSection": "mencari_hal_yang_kamu_suka_quiz6",
        },
      ];
    }

    // 🎯 Lesson 1: Mengatur Waktu
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.lessonIndex == 1) {
      return [
        {
          "key": "platform1",
          "hasVideo": true,
          "title": "Manajemen Waktu Efektif",
          "description":
              "Belajar teknik mengatur waktu untuk produktivitas optimal.",
          "subSection": "mengatur_waktu_video",
          "videoData": {
            "title": "Manajemen Waktu",
            "videoDescription":
                "Video ini membahas teknik-teknik manajemen waktu yang efektif untuk kehidupan sehari-hari.",
            "videoUrl": "https://res.cloudinary.com/dy4hqxkv1/video/upload/v1763188431/submodul1_outxfm.mp4",
            "thumbnail": "assets/images/home_card_large.png",
          },
        },
        {
          "key": "platform2",
          "hasVideo": false,
          "title": "Quiz: Manajemen Waktu",
          "description":
              "Uji pemahamanmu tentang cara mengatur waktu dengan efektif.",
          "subSection": "mengatur_waktu_quiz1",
        },
        {
          "key": "platform3",
          "hasVideo": false,
          "title": "Quiz: Prioritas Tugas",
          "description":
              "Belajar menentukan prioritas dalam mengerjakan tugas.",
          "subSection": "mengatur_waktu_quiz2",
        },
        {
          "key": "platform4",
          "hasVideo": false,
          "title": "Quiz: Produktivitas",
          "description":
              "Tingkatkan produktivitas dengan teknik manajemen waktu.",
          "subSection": "mengatur_waktu_quiz3",
        },
        {
          "key": "platform5",
          "hasVideo": false,
          "title": "Quiz: Disiplin Waktu",
          "description": "Bangun kebiasaan disiplin dalam mengatur waktu.",
          "subSection": "mengatur_waktu_quiz4",
        },
        {
          "key": "platform6",
          "hasVideo": false,
          "title": "Quiz: Efisiensi Kerja",
          "description": "Maksimalkan efisiensi dalam setiap pekerjaan.",
          "subSection": "mengatur_waktu_quiz5",
        },
        {
          "key": "platform7",
          "hasVideo": false,
          "title": "Quiz: Work-Life Balance",
          "description": "Seimbangkan kehidupan kerja dan pribadi dengan baik.",
          "subSection": "mengatur_waktu_quiz6",
        },
      ];
    }

    // 🎯 Lesson 2: Berpikir Positif
    if (widget.moduleId == "modul1" &&
        widget.sectionId == "bagian1" &&
        widget.lessonIndex == 2) {
      return [
        {
          "key": "platform1",
          "hasVideo": true,
          "title": "Mindset Positif",
          "description":
              "Membangun pola pikir positif untuk menghadapi tantangan hidup.",
          "subSection": "berpikir_positif_video",
          "videoData": {
            "title": "Berpikir Positif",
            "videoDescription":
                "Video ini membahas cara membangun dan mempertahankan mindset positif dalam kehidupan sehari-hari.",
            "videoUrl": "https://res.cloudinary.com/dy4hqxkv1/video/upload/v1763188431/submodul1_outxfm.mp4",
            "thumbnail": "assets/images/home_card_large.png",
          },
        },
        {
          "key": "platform2",
          "hasVideo": false,
          "title": "Quiz: Berpikir Positif",
          "description":
              "Uji pemahamanmu tentang cara berpikir positif dan manfaatnya.",
          "subSection": "berpikir_positif_quiz1",
        },
        {
          "key": "platform3",
          "hasVideo": false,
          "title": "Quiz: Mindset Growth",
          "description": "Kembangkan pola pikir berkembang untuk sukses.",
          "subSection": "berpikir_positif_quiz2",
        },
        {
          "key": "platform4",
          "hasVideo": false,
          "title": "Quiz: Resiliensi Mental",
          "description": "Bangun ketahanan mental menghadapi tantangan hidup.",
          "subSection": "berpikir_positif_quiz3",
        },
        {
          "key": "platform5",
          "hasVideo": false,
          "title": "Quiz: Optimisme",
          "description": "Pelajari cara memandang hidup dengan optimis.",
          "subSection": "berpikir_positif_quiz4",
        },
        {
          "key": "platform6",
          "hasVideo": false,
          "title": "Quiz: Motivasi Diri",
          "description": "Temukan sumber motivasi dari dalam diri.",
          "subSection": "berpikir_positif_quiz5",
        },
        {
          "key": "platform7",
          "hasVideo": false,
          "title": "Quiz: Kesejahteraan Mental",
          "description": "Jaga kesehatan mental untuk hidup lebih bahagia.",
          "subSection": "berpikir_positif_quiz6",
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
          "videoData": {
            "title": "Menetapkan Tujuan",
            "videoDescription":
                "Video ini membahas teknik SMART goal setting dan cara membuat action plan untuk mencapai tujuan hidup Anda.",
            "videoUrl": "https://youtu.be/wtQkr22maZI",
            "thumbnail": "assets/images/home_card_large.png",
          },
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

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
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
                  const GameHeaderWidget(),
                  Expanded(
                    child: SizedBox(
                      width: screenWidth,
                      height: screenHeight,
                      child: Stack(
                        children: [
                          CustomPaint(size: Size(screenWidth, screenHeight)),

                          // 1. button kecil
                          Positioned(
                            top: 60,
                            left: 150,
                            child: _buildSmallPlatform(
                              isActive: true,
                              context: context,
                            ),
                          ),

                          // 2. button besar
                          if (platformDataList.isNotEmpty)
                            Positioned(
                              top: 120,
                              left: 40,
                              child: _buildLargePlatform(
                                // ✅ Status berdasarkan completion
                                (platformStatus[platformDataList[0]["key"]] ??
                                        false)
                                    ? StageType.active
                                    : (_isPreviousPlatformCompleted(
                                            platformDataList[0]["key"],
                                          )
                                          ? StageType.incoming
                                          : StageType.inactive),
                                context,
                                platformData: platformDataList[0],
                                videoData: videoData,
                              ),
                            ),

                          // 3. button kecil
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
                              top: 221,
                              left: 90,
                              child: _buildSmallPlatform(
                                isActive: false,
                                context: context,
                              ),
                            ),

                          // 4. button kecil
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

                          // 5. button besar
                          if (platformDataList.length > 3)
                            Positioned(
                              top: 330,
                              right: 35,
                              child: _buildLargePlatform(
                                // ✅ Status berdasarkan completion
                                (platformStatus[platformDataList[3]["key"]] ??
                                        false)
                                    ? StageType.active
                                    : (_isPreviousPlatformCompleted(
                                            platformDataList[3]["key"],
                                          )
                                          ? StageType.incoming
                                          : StageType.inactive),
                                context,
                                platformData: platformDataList[3],
                                videoData: videoData,
                              ),
                            )
                          else
                            Positioned(
                              top: 330,
                              right: 35,
                              child: _buildLargePlatform(
                                StageType.inactive,
                                context,
                              ),
                            ),

                          // 6. button kecil
                          if (platformDataList.length > 4)
                            Positioned(
                              top: 500,
                              right: 40,
                              child: _buildSmallPlatform(
                                isActive:
                                    (platformStatus[platformDataList[4]["key"]] ??
                                    false),
                                context: context,
                                platformData: platformDataList[4],
                                videoData: videoData,
                              ),
                            )
                          else
                            Positioned(
                              top: 500,
                              right: 40,
                              child: _buildSmallPlatform(
                                isActive: false,
                                context: context,
                              ),
                            ),

                          // 7. button kecil
                          if (platformDataList.length > 5)
                            Positioned(
                              top: 570,
                              right: 150,
                              child: _buildSmallPlatform(
                                isActive:
                                    (platformStatus[platformDataList[5]["key"]] ??
                                    false),
                                context: context,
                                platformData: platformDataList[5],
                                videoData: videoData,
                              ),
                            )
                          else
                            Positioned(
                              top: 570,
                              right: 150,
                              child: _buildSmallPlatform(
                                isActive: false,
                                context: context,
                              ),
                            ),

                          // 8. button besar
                          if (platformDataList.length > 6)
                            Positioned(
                              top: 650,
                              left: 30,
                              child: _buildLargePlatform(
                                // ✅ Status berdasarkan completion
                                (platformStatus[platformDataList[6]["key"]] ??
                                        false)
                                    ? StageType.active
                                    : (_isPreviousPlatformCompleted(
                                            platformDataList[6]["key"],
                                          )
                                          ? StageType.incoming
                                          : StageType.inactive),
                                context,
                                platformData: platformDataList[6],
                                videoData: videoData,
                              ),
                            )
                          else
                            Positioned(
                              top: 650,
                              left: 30,
                              child: _buildLargePlatform(
                                StageType.inactive,
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
            bottomNavigationBar: _buildBottomNavigationBar(context, state.index),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    const double bottomNavHeight = 70.0;
    const double iconSize = 28.0;
    
    final navItems = [
      'assets/icons/navbar-home.svg',
      'assets/icons/navbar-game.svg',
      'assets/icons/navbar-ai.svg',
      'assets/icons/navbar-leaderboard.svg',
      'assets/icons/navbar-shop.svg',
      'assets/icons/navbar-profile.svg',
    ];

    return Container(
      height: bottomNavHeight + 10,
      padding: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: bluePrimaryColor.withAlpha(100), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final isActive = index == 1; // Game page is at index 1
          return Expanded(
            child: InkWell(
              onTap: () {
                // Update navigation bloc
                context.read<NavigationBloc>().add(UpdateIndex(index));
                
                // Pop back to main navigation page (through GameDetailPage and back)
                // This will allow the MainNavigationPage BlocBuilder to handle the page change
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              splashColor: bluePrimaryColor.withValues(alpha: 0.1),
              highlightColor: bluePrimaryColor.withValues(alpha: 0.05),
              child: Container(
                height: double.infinity,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  navItems[index],
                  width: iconSize,
                  height: iconSize,
                  colorFilter: ColorFilter.mode(
                    isActive ? bluePrimaryColor : secondaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          );
        }),
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
        print('🖱️ Large Platform tapped!');

        final platformKey = platformData["key"] as String;
        bool isPreviousCompleted = _isPreviousPlatformCompleted(platformKey);

        print('   Platform Key: $platformKey');
        print('   Previous Completed: $isPreviousCompleted');
        print('   Stage Type: $stageType');

        if (!isPreviousCompleted) {
          print('   ❌ Platform locked!');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Selesaikan modul sebelumnya terlebih dahulu!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        final subSection = platformData["subSection"] as String;
        final isFirstTime = _isFirstTimePlay(subSection);
        final xpReward = isFirstTime ? 80 : 2;

        print('🎯 Large Platform - SubSection: $subSection');
        print('   First Time: $isFirstTime, XP: $xpReward');

        _showLessonPopup(
          context,
          title: platformData["title"],
          description: platformData["description"],
          xpReward: xpReward,
          isReplay: !isFirstTime,
          onStart: () async {
            print('🚀 Mulai button pressed!');

            if (isFirstTime) {
              await _markSubSectionAsPlayed(subSection);
            }

            setState(() {
              platformStatus[platformKey] = true;
            });

            await _savePlatformStatus(platformKey, true);

            // ✅ Check if this is Modul 2 Bagian 1 - navigate to Build CV
            if (widget.moduleId == "modul2" &&
                widget.sectionId == "bagian1" &&
                subSection == "persiapan_karir") {
              print('🎯 Navigating to Build CV Page...');

              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BuildCVPage()),
              );

              if (result == true) {
                _loadPlatformStatus();
                await _checkAndUpdateStreak();
              }
            } else if (platformData["hasVideo"]) {
              // ✅ Gunakan video data dari platform sendiri
              final platformVideoData =
                  platformData["videoData"] as Map<String, dynamic>;

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPage(
                    title: platformVideoData["title"],
                    description: platformVideoData["videoDescription"],
                    videoUrl: platformVideoData["videoUrl"],
                    thumbnail: platformVideoData["thumbnail"],
                    moduleId: widget.moduleId,
                    sectionId: widget.sectionId,
                    subSection: subSection,
                    xpReward: xpReward,
                  ),
                ),
              );

              if (result == true) {
                _loadPlatformStatus();
                // ✅ Update streak when completing first game of the day
                await _checkAndUpdateStreak();
              }
            } else {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizPage(
                    moduleId: widget.moduleId,
                    sectionId: widget.sectionId,
                    subSection: subSection,
                    xpReward: xpReward,
                  ),
                ),
              );

              if (result == true) {
                _loadPlatformStatus();
                // ✅ Update streak when completing first game of the day
                await _checkAndUpdateStreak();
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
        print('🖱️ Small Platform tapped!');

        if (platformData != null && videoData != null) {
          String platformKey = platformData["key"];
          bool isPreviousCompleted = _isPreviousPlatformCompleted(platformKey);

          print('   Platform Key: $platformKey');
          print('   Previous Completed: $isPreviousCompleted');

          if (!isPreviousCompleted) {
            print('   ❌ Platform locked!');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Selesaikan modul sebelumnya terlebih dahulu!'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }

          // ✅ Check if first time or replay by subSection
          final subSection = platformData["subSection"] as String;
          final isFirstTime = _isFirstTimePlay(subSection);
          final xpReward = isFirstTime ? 80 : 2;

          print('🎯 Small Platform - SubSection: $subSection');
          print('   First Time: $isFirstTime, XP: $xpReward');

          _showLessonPopup(
            context,
            title: platformData["title"],
            description: platformData["description"],
            xpReward: xpReward,
            isReplay: !isFirstTime,
            onStart: () async {
              print('🚀 Mulai button pressed!');

              // ✅ Mark as played IMMEDIATELY when user clicks "Mulai"
              if (isFirstTime) {
                await _markSubSectionAsPlayed(subSection);
              }

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
                    subSection: subSection,
                    xpReward: xpReward,
                  ),
                ),
              );

              if (result == true) {
                _loadPlatformStatus();
                // ✅ Update streak when completing first game of the day
                await _checkAndUpdateStreak();
              }
            },
          );
        } else {
          print('   ⚠️ Platform data is null, cannot tap');
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
    // Platform 1 selalu unlocked
    if (currentPlatformKey == "platform1") {
      return true;
    }

    // Platform 2-7 harus menunggu platform sebelumnya selesai
    if (currentPlatformKey == "platform2") {
      return platformStatus["platform1"] ?? false;
    } else if (currentPlatformKey == "platform3") {
      return platformStatus["platform2"] ?? false;
    } else if (currentPlatformKey == "platform4") {
      return platformStatus["platform3"] ?? false;
    } else if (currentPlatformKey == "platform5") {
      return platformStatus["platform4"] ?? false;
    } else if (currentPlatformKey == "platform6") {
      return platformStatus["platform5"] ?? false;
    } else if (currentPlatformKey == "platform7") {
      return platformStatus["platform6"] ?? false;
    }

    return false;
  }

  // ✅ Mark subSection as completed - call this BEFORE navigation
  Future<void> _markSubSectionAsPlayed(String subSection) async {
    if (subSection == "default" || subSection.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final key =
        'first_completed_${widget.moduleId}_${widget.sectionId}_$subSection';

    // ✅ Fixed: Check if it's actually first time (handle null safely)
    final isAlreadyCompleted =
        subSectionFirstTimeCompleted[subSection] ?? false;

    if (!isAlreadyCompleted) {
      await prefs.setBool(key, true);
      setState(() {
        subSectionFirstTimeCompleted[subSection] = true;
      });
      print('✅ Marked $subSection as played (key: $key)');
    } else {
      print('⚠️ $subSection already marked as completed');
    }
  }

  // ✅ Check and update streak for today
  Future<void> _checkAndUpdateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';
    final lastStreakUpdateKey = 'last_streak_update_date';

    final lastUpdateDate = prefs.getString(lastStreakUpdateKey);

    print('🔥 Checking streak: Today=$todayKey, Last=$lastUpdateDate');

    // Only update streak once per day
    if (lastUpdateDate != todayKey) {
      print('✅ First game completion today, updating streak...');

      // Update streak via ProfileBloc
      context.read<ProfileBloc>().add(UpdateStreak());

      // Save today's date to prevent multiple updates
      await prefs.setString(lastStreakUpdateKey, todayKey);

      print('🎉 Streak update triggered!');
    } else {
      print('⏭️ Streak already updated today');
    }
  }

  // ✅ Check if this subSection is first time play
  bool _isFirstTimePlay(String subSection) {
    if (subSection == "default" || subSection.isEmpty) return false;
    final isFirstTime = !(subSectionFirstTimeCompleted[subSection] ?? false);
    print('🎮 SubSection: $subSection, First Time: $isFirstTime');
    return isFirstTime;
  }

  void _showLessonPopup(
    BuildContext context, {
    required String title,
    required String description,
    required int xpReward, // ✅ Add XP parameter
    required bool isReplay, // ✅ Add replay status
    required VoidCallback onStart,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7DD3F7),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ Show replay badge if replaying with slide animation
                        if (isReplay)
                          SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, -0.5),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: const Interval(
                                      0.3,
                                      1.0,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                                ),
                            child: FadeTransition(
                              opacity: CurvedAnimation(
                                parent: animation,
                                curve: const Interval(0.3, 1.0),
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "🔄 Replay Mode",
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // ✅ Title with slide animation
                        SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, -0.3),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: const Interval(
                                    0.2,
                                    1.0,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                              ),
                          child: FadeTransition(
                            opacity: CurvedAnimation(
                              parent: animation,
                              curve: const Interval(0.2, 1.0),
                            ),
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              style: whiteTextStyle.copyWith(
                                fontSize: 20,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // ✅ Description with slide animation
                        SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: const Interval(
                                    0.3,
                                    1.0,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                              ),
                          child: FadeTransition(
                            opacity: CurvedAnimation(
                              parent: animation,
                              curve: const Interval(0.3, 1.0),
                            ),
                            child: Text(
                              description,
                              textAlign: TextAlign.center,
                              style: secondaryTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: medium,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // ✅ Button with scale and fade animation
                        ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: const Interval(
                                0.4,
                                1.0,
                                curve: Curves.elasticOut,
                              ),
                            ),
                          ),
                          child: FadeTransition(
                            opacity: CurvedAnimation(
                              parent: animation,
                              curve: const Interval(0.4, 1.0),
                            ),
                            child: CustomFilledButton(
                              title: "Mulai +$xpReward XP",
                              variant: ButtonColorVariant.white,
                              height: 50,
                              onPressed: () async {
                                Navigator.pop(context);
                                onStart();

                                // ✅ Wait for activity to complete then refresh
                                await Future.delayed(
                                  const Duration(milliseconds: 500),
                                );
                                if (context.mounted) {
                                  context.read<ProfileBloc>().add(
                                    RefreshProfile(),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum StageType { active, inProgress, completed, incoming, inactive }

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
