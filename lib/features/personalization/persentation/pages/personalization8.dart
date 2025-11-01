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
            style: primaryTextStyle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 32),
          Image.asset(
            'assets/images/dino_congrats.png',
            height: 350,
            width: 350,
          ),
          const SizedBox(height: 32),
          Text(
            'Mantap! Sekarang, cililg warna sistem kamu! Ini akan membentu kami menyesuaikan tampilan yang akan ikut tumbuh dan berkembang bersama di setiap mau.',
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
