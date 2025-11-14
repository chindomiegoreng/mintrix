import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';

class Personalization3 extends StatelessWidget {
  final VoidCallback onNext;

  const Personalization3({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rewards = [
      {
        'icon': Icons.list_alt_outlined,
        'title': 'Yuk, Jadi Super Seru Bareng Mintrix',
        'subtitle': 'Belajar asik tanpa bosen',
      },
      {
        'icon': Icons.videocam_outlined,
        'title': 'Video Keren Bikin Kamu Jago',
        'subtitle': 'Dari ngatasin bullying sampe nyobain hobi baru, semua ada',
      },
      {
        'icon': Icons.extension_outlined,
        'title': 'Jadi Versi Paling Kerenmu',
        'subtitle':
            'Dapetin reminder asik, bikin avatar kece, dan belanja di toko seru',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Image.asset(
                'assets/icons/icon_rewards.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Yay, Ini Hadiah Keren yang Bisa Kamu Dapetin',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rewards.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Color(0xFFE5E5E5),
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final reward = rewards[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      Icon(reward['icon'], color: bluePrimaryColor, size: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reward['title'],
                              style: primaryTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: semiBold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              reward['subtitle'],
                              style: secondaryTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Spacer(),

          CustomFilledButton(
            title: 'Selanjutnya',
            variant: ButtonColorVariant.blue,
            onPressed: onNext,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
