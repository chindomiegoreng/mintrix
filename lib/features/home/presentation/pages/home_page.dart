import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/features/daily_notes/persentation/daily_notes_page.dart';
import 'package:mintrix/features/home/presentation/pages/daily_mission_page.dart';
import 'package:mintrix/features/navigation/presentation/bloc/navigation_bloc.dart';
import 'package:mintrix/features/navigation/presentation/bloc/navigation_event.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/home_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 30),
              _buildLargeCard(),
              const SizedBox(height: 24),
              _buildMenuGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),
            ),
          ],
        ),
        const Spacer(),
        // Ganti dengan ikon yang sesuai
        const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
        const SizedBox(width: 4),
        Text(
          "4",
          style: bluePrimaryTextStyle.copyWith(
            fontSize: 16,
            fontWeight: semiBold,
          ),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DailyMissionPage()),
            );
          },
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
      description:
          'Pertahankan posisimu dengan menyelesaikan misi harian dan mengisi catatan harian',
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DailyNotesPage(),
                  ),
                );
              },
              child: const CustomHomeCardSmall(
                images: "assets/images/home_card_asset2.png",
                title: "Catatan harian",
                subTitle: "Ceritakan kegiatanmu hari ini",
              ),
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
            GestureDetector(
              onTap: () {
                context.read<NavigationBloc>().add(UpdateIndex(4));
              },
              child: const CustomHomeCardSmall(
                images: "assets/images/home_card_asset4.png",
                title: "Toko",
                subTitle: "Tingkatkan performa dengan membeli item",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
