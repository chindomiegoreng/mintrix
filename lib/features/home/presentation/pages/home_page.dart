import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart'; 
import 'package:mintrix/widgets/home_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ganti warna background agar sesuai desain
      backgroundColor: const Color(0xffF5F8FF), 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildLargeCard(),
              const SizedBox(height: 24),
              _buildMenuGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk Header
  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/images/logo_mintrix.png'), 
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ayo bermain",
              style: secondaryTextStyle.copyWith(fontSize: 12),
            ),
            Text(
              "Renata",
              style: primaryTextStyle.copyWith(
                fontSize: 18,
                fontWeight: bold,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Ganti dengan ikon yang sesuai
        const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
        const SizedBox(width: 4),
        Text("4", style: bluePrimaryTextStyle.copyWith(fontSize: 16, fontWeight: semiBold)),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: bluePrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Misi Harian",
            style: whiteTextStyle.copyWith(fontWeight: semiBold, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildLargeCard() {
    return const CustomHomeCardLarge(
      title: 'Liga Emas',
      subTitle: 'Posisi 1',
      description: 'Pertahankan posisimu dengan menyelesaikan misi harian dan mengisi catatan harian',
    );
  }

  Widget _buildMenuGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomHomeCardSmall(
              images: "assets/images/home_card_asset1.png",
              title: "Permainan",
              subTitle: "Ayo bermain dan belajar",
            ),
            const CustomHomeCardSmall(
              images: "assets/images/home_card_asset2.png",
              title: "Catatan harian",
              subTitle: "Ceritakan kegiatanmu hari ini",
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomHomeCardSmall(
              images: "assets/images/home_card_asset3.png",
              title: "Assisten",
              subTitle: "Mulai mengembangkan dirimu dengan bantuan Dino",
            ),
            const CustomHomeCardSmall(
              images: "assets/images/home_card_asset4.png",
              title: "Toko",
              subTitle: "Tingkatkan performa dengan membeli item",
            ),
          ],
        ),
      ],
    );
  }
}