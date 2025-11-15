import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/game_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mintrix/features/game/presentation/pages/level_journey_page.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/features/navigation/presentation/bloc/navigation_bloc.dart';
import 'package:mintrix/features/navigation/presentation/bloc/navigation_event.dart';
import 'package:mintrix/features/navigation/presentation/bloc/navigation_state.dart';

class GameDetailPage extends StatefulWidget {
  final String sectionTitle;
  final double progress;
  final String moduleId;
  final String sectionId;

  const GameDetailPage({
    super.key,
    required this.sectionTitle,
    required this.progress,
    required this.moduleId,
    required this.sectionId,
  });

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Map<String, bool> _lessonCompletionStatus = {};

  @override
  void initState() {
    super.initState();
    _loadLessonProgress();
  }

  Future<void> _loadLessonProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lessonCompletionStatus = {
        "modul1_bagian1_0": prefs.getBool("modul1_bagian1_0") ?? false,
        "modul1_bagian1_1": prefs.getBool("modul1_bagian1_1") ?? false,
        "modul1_bagian1_2": prefs.getBool("modul1_bagian1_2") ?? false,
        "modul2_bagian1_0": prefs.getBool("modul2_bagian1_0") ?? false,
      };
    });
  }

  String _getSectionTitle() {
    if (widget.moduleId == "modul1") {
      return "Bagian 1";
    } else if (widget.moduleId == "modul2") {
      return "Bagian 1";
    }
    return "Bagian 1";
  }

  bool _isLessonUnlocked(int currentIndex) {
    if (currentIndex == 0) return true;

    int previousIndex = currentIndex - 1;
    String previousKey =
        "${widget.moduleId}_${widget.sectionId}_$previousIndex";

    return _lessonCompletionStatus[previousKey] ?? false;
  }

  List<Map<String, dynamic>> _getLessons() {
    if (widget.moduleId == "modul2" && widget.sectionId == "bagian1") {
      return [
        {
          "title": "Persiapan Karir",
          "dinoImage":
              "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846591/character2_h9dbhr.png",
          "locked": !_isLessonUnlocked(0),
          "lessonIndex": 0,
        },
      ];
    }

    if (widget.moduleId == "modul1" && widget.sectionId == "bagian1") {
      return [
        {
          "title": "Mencari Hal Yang Kamu Suka",
          "dinoImage":
              "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846604/character13_r0wia5.png",
          "locked": !_isLessonUnlocked(0),
          "lessonIndex": 0,
        },
        {
          "title": "Mengatur Waktu",
          "dinoImage":
              "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846604/character13_r0wia5.png",
          "locked": !_isLessonUnlocked(1),
          "lessonIndex": 1,
        },
        {
          "title": "Berpikir Positif",
          "dinoImage":
              "https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846604/character13_r0wia5.png",
          "locked": !_isLessonUnlocked(2),
          "lessonIndex": 2,
        },
      ];
    }
    return [
      {
        "title": "Coming Soon",
        "dinoImage": "assets/images/dino_daily_mission.png",
        "locked": true,
        "lessonIndex": 0,
      },
    ];
  }

  bool _showCarousel() {
    return _getLessons().length > 1;
  }

  bool _isCurrentLessonLocked() {
    final lessons = _getLessons();
    if (!_showCarousel()) {
      return lessons[0]["locked"];
    }
    return lessons[_currentPage]["locked"];
  }

  @override
  Widget build(BuildContext context) {
    final lessons = _getLessons();
    final showCarousel = _showCarousel();
    final isLocked = _isCurrentLessonLocked();

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GameHeaderWidget(),
                SectionProgressCard(
                  title: _getSectionTitle(),
                  subtitle: widget.sectionTitle,
                  progress: widget.progress,
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 12),
                Expanded(
                  child: showCarousel
                      ? PageView.builder(
                          controller: _controller,
                          onPageChanged: (index) =>
                              setState(() => _currentPage = index),
                          itemCount: lessons.length,
                          itemBuilder: (context, index) {
                            final lesson = lessons[index];
                            return LessonCard(
                              title: lesson["title"],
                              dinoImage: lesson["dinoImage"],
                              locked: lesson["locked"],
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: LessonCard(
                            title: lessons[0]["title"],
                            dinoImage: lessons[0]["dinoImage"],
                            locked: lessons[0]["locked"],
                          ),
                        ),
                ),
                if (showCarousel) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      lessons.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.lightBlue
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomFilledButton(
                    title: isLocked ? "Terkunci" : "Mulai",
                    variant: isLocked
                        ? ButtonColorVariant.secondary
                        : ButtonColorVariant.blue,
                    onPressed: isLocked
                        ? null
                        : () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LevelJourneyPage(
                                  moduleId: widget.moduleId,
                                  sectionId: widget.sectionId,
                                  lessonIndex: showCarousel ? _currentPage : 0,
                                ),
                              ),
                            );

                            // Reload progress setelah kembali dari journey
                            if (result == true) {
                              _loadLessonProgress();
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(context, state.index),
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
                
                // Pop back to main navigation page
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
}

class SectionProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  const SectionProgressCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1.4),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: bluePrimaryTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: regular,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonCard extends StatelessWidget {
  final String title;
  final String dinoImage;
  final bool locked;

  const LessonCard({
    super.key,
    required this.title,
    required this.dinoImage,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        height: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage(
              locked
                  ? "assets/images/modul_locked.png"
                  : "assets/images/modul_card.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 24,
              left: 0,
              right: 0,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: primaryTextStyle.copyWith(
                  fontSize: 28,
                  fontWeight: extraBold,
                ),
              ),
            ),
            if (!locked)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: CachedNetworkImage(
                    imageUrl: dinoImage,
                    width: 220,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                  ),
                ),
              ),
            if (locked)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
