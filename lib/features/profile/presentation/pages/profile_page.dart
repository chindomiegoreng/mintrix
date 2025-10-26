import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:radar_chart/radar_chart.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // bg
          Positioned.fill(
            child: Image.asset(
              "assets/images/profile_background.png",
              fit: BoxFit.cover,
            ),
          ),
          // container white
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 423,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          // konten scroll
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 98),
              profileInfo(),
              statsRow(),
              achievementsContainer(),
              progressContainer(context),
              const SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }

  Widget profileInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          Image.asset("assets/images/profile.png"),
          SizedBox(height: 14),
          Text(
            "Renata",
            style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: bold),
          ),
          SizedBox(height: 6),
          Text(
            "ID: 5220411131",
            style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: regular),
          ),
        ],
      ),
    );
  }

  Widget statsRow() {
    return Container(
      height: 117,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(color: bluePrimaryColor, width: 1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: bluePrimaryColor,
            offset: const Offset(0, 4),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/home_card_asset.png", height: 36),
              SizedBox(height: 2),
              Text(
                "Liga",
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Emas",
                style: TextStyle(
                  color: Color(0xffFFC800),
                  fontWeight: bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          VerticalDivider(
            color: bluePrimaryColor,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/xp.png", height: 36),
              SizedBox(height: 2),
              Text(
                "Total XP",
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "600",
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
              ),
            ],
          ),
          VerticalDivider(
            color: bluePrimaryColor,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/fire.png", height: 36),
              SizedBox(height: 2),
              Text(
                "Runtutan",
                style: primaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "5",
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget achievementsContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pencapaian",
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              Text(
                "Lihat Detail",
                style: secondaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: bluePrimaryColor, width: 1),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: bluePrimaryColor,
                  offset: const Offset(0, 4),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                Image.asset("assets/images/pencapaian1.png"),
                Image.asset("assets/images/pencapaian2.png"),
                Image.asset("assets/images/pencapaian3.png"),
                Image.asset("assets/images/pencapaian4.png"),
                Image.asset("assets/images/pencapaian5.png"),
                Image.asset("assets/images/pencapaian6.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget progressContainer(context) {
    final labels = [
      "Berani",
      "Empati",
      "Tanggung Jawab",
      "Kerja Sama",
      "Kreativitas",
    ];
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 50),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Perkembangan",
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/detail-profile");
                },
                child: Text(
                  "Lihat Detail",
                  style: secondaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: bluePrimaryColor, width: 1),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: bluePrimaryColor,
                  offset: const Offset(0, 4),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RadarChart(
                  length: 5,
                  radius: 90,
                  initialAngle: 0,
                  borderStroke: 2,
                  borderColor: thirdColor,
                  radialStroke: 1,
                  radialColor: thirdColor,
                  vertices: [
                    for (int i = 0; i < 5; i++)
                      PreferredSize(
                        preferredSize: const Size.fromRadius(15),
                        child: Text(
                          labels[i],
                          style: TextStyle(
                            color: bluePrimaryColor,
                            fontSize: 14,
                            fontWeight: semiBold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                  ],
                  radars: [
                    RadarTile(
                      values: [0.4, 0.8, 0.65, 0.7, 0.5],
                      borderStroke: 2,
                      backgroundColor: greenColor.withAlpha(100),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
