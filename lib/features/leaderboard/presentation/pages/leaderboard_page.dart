import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/leaderboard_animation.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background & Content
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/leaderboard_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SizedBox(height: 64),
                buildHeader(),
                const SizedBox(height: 12),
                buildBadges(),
                const LeaderboardAnimation(),
                const SizedBox(height: 200),
              ],
            ),
          ),
          // Draggable Bottom Sheet
          buildDraggableSheet(context),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Liga Mintrix",
              style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: bold),
            ),
            const SizedBox(height: 4),
            Text(
              "5 besar akan melaju ke babak selanjutnya",
              style: primaryTextStyle.copyWith(
                fontSize: 12,
                fontWeight: medium,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.access_time, color: bluePrimaryColor, size: 14),
              const SizedBox(width: 4),
              Text(
                "3",
                style: TextStyle(
                  color: bluePrimaryColor,
                  fontSize: 12,
                  fontWeight: bold,
                ),
              ),
              Text(
                " Hari",
                style: TextStyle(
                  color: bluePrimaryColor,
                  fontSize: 12,
                  fontWeight: bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBadges() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Image.asset("assets/images/leaderboard_badges.png")],
      ),
    );
  }

  Widget buildDraggableSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.70,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(color: thirdColor, width: 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: thirdColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // List
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    buildLeaderboardItem(
                      rank: 1,
                      name: "Renata",
                      xp: 580,
                      image: "assets/images/profile2.png",
                      isHighlight: false,
                    ),
                    buildLeaderboardItem(
                      rank: 2,
                      name: "Rojali",
                      xp: 513,
                      image: "assets/images/profile2.png",
                      isHighlight: false,
                    ),
                    buildLeaderboardItem(
                      rank: 3,
                      name: "Kodomo",
                      xp: 497,
                      image: "assets/images/profile2.png",
                      isHighlight: false,
                    ),
                    buildLeaderboardItem(
                      rank: 4,
                      name: "Simons",
                      xp: 435,
                      image: "assets/images/profile2.png",
                      isHighlight: false,
                    ),
                    buildLeaderboardItem(
                      rank: 5,
                      name: "Hawila",
                      xp: 400,
                      image: "assets/images/profile2.png",
                      isHighlight: false,
                    ),
                    // Zona Aman
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/leaderboard_arrow.svg",
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Zona aman",
                            style: TextStyle(
                              color: greenColor,
                              fontSize: 16,
                              fontWeight: bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            "assets/icons/leaderboard_arrow.svg",
                          ),
                        ],
                      ),
                    ),
                    buildLeaderboardItem(
                      rank: 6,
                      name: "Badu",
                      xp: 395,
                      image: "assets/images/profile2.png",
                      isHighlight: false,
                    ),
                    buildLeaderboardItem(
                      rank: 7,
                      name: "Orisam",
                      xp: 386,
                      image: "assets/images/profile2.png",
                      isHighlight: false,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildLeaderboardItem({
    required int rank,
    required String name,
    required int xp,
    required String image,
    bool isHighlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlight
            ? bluePrimaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 30,
            child: Text(
              "$rank",
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: bold,
                color: secondaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: secondaryColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.person,
                      size: 24,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name
          Expanded(
            child: Text(
              name,
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
          ),
          // XP Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: greenColor,
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
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
