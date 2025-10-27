import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintrix/shared/theme.dart';

class StoreItemCard1 extends StatelessWidget {
  final String image;
  final String title;
  final String multiplier;
  final bool isPopular;
  final VoidCallback? onTap;

  const StoreItemCard1({
    super.key,
    required this.image,
    required this.title,
    required this.multiplier,
    this.isPopular = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 170,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: Color(0xFFE5E5E5), width: 2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFE5E5E5),
                  offset: Offset(0, 4),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Image.asset(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: primaryTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  multiplier,
                  style: bluePrimaryTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: bold,
                  ),
                ),
              ],
            ),
          ),
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: bluePrimaryColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Text(
                  'Populer',
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class StoreItemCard2 extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final VoidCallback? onTap;

  const StoreItemCard2({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 340,
        height: 104,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: whiteColor,
          border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFE5E5E5),
              offset: Offset(0, 4),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(image, width: 100, height: 100, fit: BoxFit.contain),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: primaryTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/obsidian.svg',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        price,
                        style: bluePrimaryTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: bold,
                        ),
                      ),
                      Text(
                        ' Permata',
                        style: bluePrimaryTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: bold,
                        ),
                      ),
                    ],
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
// // usage

// StoreItemCard(
//   image: 'assets/images/mantra_xp.png',
//   title: 'Mantra XP',
//   multiplier: 'x2',
//   isPopular: true,
//   onTap: () {
//     print('Mantra XP clicked');
//   },
// )

// StoreItemCard(
//   image: 'assets/images/potion_hp.png',
//   title: 'Potion HP',
//   multiplier: 'x3',
//   isPopular: false,
//   onTap: () {},
// )

// StoreItemCard2(
//   image: 'assets/images/store_3streak.png',
//   title: '3 Pembeku Streak',
//   price: '25',
//   onTap: () {
//     print('3 Pembeku Streak clicked');
//   },
// )
