import 'package:flutter/material.dart';
import 'package:mintrix/widgets/home_card.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        // child: SafeArea(
        //   child: Wrap(
        //     runSpacing: 15,
        //     alignment: WrapAlignment.spaceBetween,
        //     children: [
        //       CustomHomeCardSmall(
        //         images: "assets/images/home_card_asset1.png",
        //         title: "title",
        //         subTitle: "subTitle",
        //       ),
        //       CustomHomeCardSmall(
        //         images: "assets/images/home_card_asset2.png",
        //         title: "title",
        //         subTitle: "subTitle",
        //       ),
        //       CustomHomeCardSmall(
        //         images: "assets/images/home_card_asset3.png",
        //         title: "title",
        //         subTitle: "subTitle",
        //       ),
        //       CustomHomeCardSmall(
        //         images: "assets/images/home_card_asset4.png",
        //         title: "title",
        //         subTitle: "subTitle",
        //       ),
        //     ],
        //   ),
        child: Column(
          children: [
            const Spacer(),
            // Logo container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 167, 213, 235),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.school,
                size: 60,
                color: Color.fromARGB(255, 27, 126, 154),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Mintrix',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belajar Lebih Mudah',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white70),
            ),
            const Spacer(),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  CustomHomeCardLarge(
                    title: "Liga Emas",
                    subTitle: "Posisi 1",
                    description:
                        "Pertahankan posisimu dengan menyelesaikan misi harian dan mengisi catatan harian",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
