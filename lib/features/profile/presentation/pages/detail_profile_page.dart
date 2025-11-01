import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:radar_chart/radar_chart.dart';

class DetailProfilePage extends StatelessWidget {
  const DetailProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          profileInfo(),
          SizedBox(height: 20),
          sectionTitle1(),
          progressContainer(),
          SizedBox(height: 12),
          sectionTitle2(),
          SizedBox(height: 50),
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

  Widget sectionTitle1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kepribadian Kamu",
          style: bluePrimaryTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Data di bawah ini merupakan rekam jejak penggunaan aplikasi dari awal hingga saat ini dan dapat berubah kapanpun. Penilaian yang ditampilkan didasarkan pada keseluruhan aktivitas anak.",
          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ],
    );
  }

  Widget progressContainer() {
    final labels = [
      "Berani",
      "Empati",
      "Tanggung Jawab",
      "Kerja Sama",
      "Kreativitas",
    ];
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
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

  Widget sectionTitle2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hobi dan Minat Kamu",
          style: bluePrimaryTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Menggambar, bermain musik, dan menulis. kamu senang mengarang dan menciptakan dunia dari imajinasi kamu sendiri.",
          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ],
    );
  }
}
