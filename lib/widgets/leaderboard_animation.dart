import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintrix/shared/theme.dart';

class LeaderboardAnimation extends StatefulWidget {
  const LeaderboardAnimation({super.key});

  @override
  State<LeaderboardAnimation> createState() => _LeaderboardAnimationState();
}

class _LeaderboardAnimationState extends State<LeaderboardAnimation> {
  bool showFirst = false;
  bool showSecond = false;
  bool showThird = false;

  @override
  void initState() {
    super.initState();

    // Jalankan animasi berurutan
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => showFirst = true);
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => showSecond = true);
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => showThird = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/leaderboard_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // JUARA 2 (Kiri)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            bottom: showSecond ? 0 : -300,
            right: 220,
            child: buildPodium(
              number: 2,
              name: "Rojali",
              xp: 513,
              image: "assets/images/profile2.png",
              podiumImage: "assets/images/leaderboard_podium2.png",
            ),
          ),

          // JUARA 1 (Tengah)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            bottom: showFirst ? 0 : -300,
            child: buildPodium(
              number: 1,
              name: "Renata",
              xp: 580,
              image: "assets/images/profile2.png",
              podiumImage: "assets/images/leaderboard_podium1.png",
              isFirst: true,
            ),
          ),

          // JUARA 3 (Kanan)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            bottom: showThird ? 0 : -300,
            left: 220,
            child: buildPodium(
              number: 3,
              name: "Kodomo",
              xp: 497,
              image: "assets/images/profile2.png",
              podiumImage: "assets/images/leaderboard_podium3.png",
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPodium({
    required int number,
    required String name,
    required int xp,
    required String image,
    required String podiumImage,
    bool isFirst = false,
  }) {
    // warna border berdasarkan peringkat
    Color getBorderColor() {
      if (number == 1) return bluePrimaryColor;
      if (number == 2) return greenColor;
      if (number == 3) return const Color(0xFFD1AA20);
      return Colors.transparent;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // badge "Kamu" untuk juara 1
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: getBorderColor(), width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isFirst)
              Positioned(
                bottom: -10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: bluePrimaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Kamu",
                      style: whiteTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: isFirst ? 12 : 8),

        // Name
        Text(
          name,
          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: bold),
        ),
        const SizedBox(height: 2),

        // XP
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: getBorderColor(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/icons/leaderboard_xp.svg",
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 4),
              Text(
                "$xp",
                style: whiteTextStyle.copyWith(fontSize: 12, fontWeight: bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // podium Image
        Image.asset(podiumImage, fit: BoxFit.contain),
      ],
    );
  }
}
