import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintrix/shared/theme.dart';

class CustomHomeCardLarge extends StatelessWidget {
  final String title;
  final String subTitle;
  final String description;

  const CustomHomeCardLarge({
    super.key,
    required this.title,
    required this.subTitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          SvgPicture.asset(
            "assets/images/home_card_large.svg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: 175,
          ),
          Container(
            width: double.infinity,
            height: 175,
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: bluePrimaryTextStyle.copyWith(
                          fontWeight: bold,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subTitle,
                        style: bluePrimaryTextStyle.copyWith(
                          fontWeight: semiBold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: bluePrimaryTextStyle.copyWith(
                          fontWeight: medium,
                          fontSize: 12,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Image.asset(
                  "assets/images/home_card_asset.png",
                  width: 100,
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomHomeCardSmall extends StatelessWidget {
  final String images;
  final String title;
  final String subTitle;

  const CustomHomeCardSmall({
    super.key,
    required this.images,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      height: 180,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SvgPicture.asset(
                "assets/images/home_card_small.svg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  // "assets/images/home_card_asset1.png",
                  images,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 3),
                Text(
                  // "Permainan",
                  title,
                  style: bluePrimaryTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 1),
                Text(
                  // "Ayo bermain dan belajar",
                  subTitle,
                  style: bluePrimaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
