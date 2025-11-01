import 'package:flutter/material.dart';
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
          Image.asset(
            "assets/images/home_card_large.png",
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
      width: 175,
      height: 220,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/images/home_card_small.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(images, width: 90, height: 90),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: bluePrimaryTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 32,
                  child: Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: bluePrimaryTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
