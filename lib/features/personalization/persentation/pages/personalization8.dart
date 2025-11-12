import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';

class Personalization8 extends StatelessWidget {
  final VoidCallback onComplete;

  const Personalization8({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'Langkah Terakhir Sebelum Bertualang!',
            textAlign: TextAlign.center,
            style: primaryTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 32),
          // Image.asset(
          //   'assets/images/dino_congrats.png',
          //   height: 350,
          //   width: 350,
          // ),
          CachedNetworkImage(
            imageUrl:
                'https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846591/character16_r0dgpz.png',
            width: 350,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
          ),
          const SizedBox(height: 32),
          Text(
            'Mantap! Sekarang, pilih wujud avatarmu. Ia akan menjadi teman setiamu yang akan ikut tumbuh dan berkembang bersamamu di setiap misi.',
            textAlign: TextAlign.center,
            style: secondaryTextStyle.copyWith(fontSize: 14),
          ),
          const Spacer(),
          CustomFilledButton(
            title: 'Selanjutnya',
            variant: ButtonColorVariant.blue,
            onPressed: onComplete,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
