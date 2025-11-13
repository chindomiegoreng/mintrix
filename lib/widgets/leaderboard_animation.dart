import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintrix/core/models/leaderboard_models.dart';
import 'package:mintrix/shared/theme.dart';

class LeaderboardAnimation extends StatefulWidget {
  final List<LeaderboardUser> topUsers;

  const LeaderboardAnimation({super.key, required this.topUsers});

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
    if (widget.topUsers.length < 3) return const SizedBox(height: 300);

    final first = widget.topUsers[0];
    final second = widget.topUsers[1];
    final third = widget.topUsers[2];

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
          // 🥈 Podium 2 (belakang)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            bottom: showSecond ? 0 : -300,
            right: 220,
            child: buildPodium(
              number: 2,
              name: second.nama,
              xp: second.xp,
              image: second.foto ?? "assets/images/profile_placeholder.png",
              podiumImage: "assets/images/leaderboard_podium2.png",
            ),
          ),

          // 🥉 Podium 3 (belakang)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            bottom: showThird ? 0 : -300,
            left: 225,
            child: buildPodium(
              number: 3,
              name: third.nama,
              xp: third.xp,
              image: third.foto ?? "assets/images/profile_placeholder.png",
              podiumImage: "assets/images/leaderboard_podium3.png",
            ),
          ),

          // 🥇 Podium 1 (paling depan)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            bottom: showFirst ? 0 : -300,
            child: buildPodium(
              number: 1,
              name: first.nama,
              xp: first.xp,
              image: first.foto ?? "assets/images/profile_placeholder.png",
              podiumImage: "assets/images/leaderboard_podium1.png",
              isFirst: true,
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
    Color getBorderColor() {
      if (number == 1) return bluePrimaryColor;
      if (number == 2) return greenColor;
      if (number == 3) return const Color(0xFFD1AA20);
      return Colors.transparent;
    }

    final imageWidget = image.startsWith('http')
        ? Image.network(
            image,
            fit: BoxFit.cover,
            width: 65,
            height: 65,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              "assets/images/profile_placeholder.png",
              fit: BoxFit.cover,
              width: 65,
              height: 65,
            ),
          )
        : Image.asset(image, fit: BoxFit.cover, width: 65, height: 65);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
              child: ClipOval(child: imageWidget),
            ),
            // if (isFirst)
            //   Positioned(
            //     bottom: -10,
            //     left: 0,
            //     right: 0,
            //     child: Center(
            //       child: Container(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 12,
            //           vertical: 4,
            //         ),
            //         decoration: BoxDecoration(
            //           color: bluePrimaryColor,
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //         child: Text(
            //           "Kamu",
            //           style: whiteTextStyle.copyWith(
            //             fontSize: 12,
            //             fontWeight: bold,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
        SizedBox(height: isFirst ? 12 : 8),
        // 👇 hanya tampilkan first name
        Text(
          name.split(' ').first,
          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: bold),
        ),
        const SizedBox(height: 2),
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
        Image.asset(podiumImage, fit: BoxFit.contain),
      ],
    );
  }
}
