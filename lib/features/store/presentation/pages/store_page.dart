import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/store_item_cards.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b4251),
      body: Column(
        children: [
          buildTopContainer(),
          const SizedBox(height: 35),
          Expanded(child: buildBottomContainer()),
        ],
      ),
    );
  }

  Widget buildTopContainer() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: double.infinity,
          child: Image.asset(
            "assets/images/store_potion_bg.png",
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        Positioned(
          top: 60,
          left: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: whiteColor,
                  border: Border.all(color: bluePrimaryColor, width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/obsidian.svg"),
                    const SizedBox(width: 8),
                    Text(
                      "200",
                      style: TextStyle(
                        color: bluePrimaryColor,
                        fontSize: 16,
                        fontWeight: bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Toko Poin",
                style: TextStyle(
                  color: Color(0xff275e73),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Naik level lebih cepat!",
                style: TextStyle(
                  color: Color(0xff275e73),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -15,
          left: 0,
          right: 0,
          child: Image.asset(
            "assets/images/store_table.png",
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          bottom: -103,
          left: 190,
          right: 0,
          child: SizedBox(
            // height: 140,
            child:
                // Image.asset(
                //   "assets/images/store_dino.png",
                //   fit: BoxFit.contain,
                // ),
                CachedNetworkImage(
                  imageUrl:
                      'https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846597/character25_ofdwly.png',
                  // width: 350,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
          ),
        ),
      ],
    );
  }

  Widget buildBottomContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                Text(
                  "Penawaran Unggulan",
                  style: primaryTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: bold,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      spacing: 16,
                      children: [
                        StoreItemCard1(
                          image: 'assets/images/store_1xp.png',
                          title: 'Mantra XP',
                          multiplier: 'x2',
                          isPopular: true,
                          onTap: () {},
                        ),
                        StoreItemCard1(
                          image: 'assets/images/store_1streak.png',
                          title: 'Pembeku',
                          multiplier: 'x2',
                          isPopular: true,
                          onTap: () {},
                        ),
                        StoreItemCard1(
                          image: 'assets/images/store_1xp.png',
                          title: 'Mantra XP',
                          multiplier: 'x2',
                          isPopular: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Penawaran Lainnya",
                  style: primaryTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: bold,
                  ),
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  labelColor: bluePrimaryColor,
                  unselectedLabelColor: thirdColor,
                  indicatorColor: bluePrimaryColor,
                  indicatorWeight: 3,
                  labelStyle: TextStyle(fontSize: 16, fontWeight: semiBold),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                  tabs: const [
                    Tab(text: 'Power-up'),
                    Tab(text: 'Diamond'),
                    Tab(text: 'Badge'),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      buildPowerUpTab(),
                      buildDiamondTab(),
                      buildBadgeTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPowerUpTab() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          spacing: 16,
          children: [
            StoreItemCard2(
              image: "assets/images/store_3streak.png",
              title: "3 Pembeku Streak",
              price: "25",
            ),
            StoreItemCard2(
              image: "assets/images/store_3xp.png",
              title: "3 Mantra XP",
              price: "25",
            ),
            StoreItemCard2(
              image: "assets/images/store_3streak.png",
              title: "3 Pembeku Streak",
              price: "25",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDiamondTab() {
    return ListView(
      children: [
        Center(
          child: Text(
            'Diamond Items',
            style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
        ),
      ],
    );
  }

  Widget buildBadgeTab() {
    return ListView(
      children: [
        Center(
          child: Text(
            'Badge Items',
            style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
        ),
      ],
    );
  }
}
