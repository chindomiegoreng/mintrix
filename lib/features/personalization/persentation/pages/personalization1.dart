import 'package:flutter/material.dart';
import 'package:mintrix/widgets/buttons.dart';

class Personalization1 extends StatelessWidget {
  final VoidCallback onNext;

  const Personalization1({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            'assets/images/dino_welcome.png',
            height:350,
            width: 350,
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
