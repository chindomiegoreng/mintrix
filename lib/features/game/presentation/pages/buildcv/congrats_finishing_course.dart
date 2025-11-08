import 'package:flutter/material.dart';
import 'package:mintrix/widgets/buttons.dart';

class CVCongratulations extends StatelessWidget {
  final VoidCallback onNext;

  const CVCongratulations({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 0, right: 24.0, bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hebat kamu sudah menyelesaikan materi !!!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nah, karena sekarang kamu sudah lebih paham persiapannya, Apakah kamu sudah memiliki CV sebelumnya?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Spacer(),
          CustomFilledButton(
            title: 'Belum',
            variant: ButtonColorVariant.blue,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}