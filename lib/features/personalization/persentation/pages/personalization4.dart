import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';

class Personalization4 extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onSkip;

  const Personalization4({
    super.key,
    required this.onStart,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            'Jadikan Petualangan Ini Milikmu Seutuhnya',
            textAlign: TextAlign.center,
            style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),
          ),
          Spacer(),
          // Image.asset(
          //   'assets/images/dino_personalisasi_4.png',
          //   height: 350,
          //   width: 350,
          //   fit: BoxFit.contain,
          // ),
          CachedNetworkImage(
            imageUrl:
                'https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846601/character11_kqpgwe.png',
            width: 350,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
          ),
          const SizedBox(height: 32),
          Text(
            'Jawabanmu akan membantu kami merancang tantangan yang banar-benar sesuai dengan dirimu. Siap untuk jadi versi terbaik dari dirimu?',
            textAlign: TextAlign.center,
            style: secondaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
          ),
          const Spacer(),
          CustomFilledButton(
            title: 'Mulai',
            variant: ButtonColorVariant.blue,
            onPressed: onStart,
          ),
          const SizedBox(height: 12),
          CustomFilledButton(
            title: 'Lewati',
            variant: ButtonColorVariant.white,
            onPressed: onSkip,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
