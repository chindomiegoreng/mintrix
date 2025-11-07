import 'package:flutter/material.dart';
import 'package:mintrix/widgets/buttons.dart';

class CVGreeting extends StatelessWidget {
  final VoidCallback onNext;

  const CVGreeting({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          const Text(
            'Yuk, Cobain Bikin CV-mu Sendiri',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.grey
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Ceritain pengalaman dan keahlianmu lewat CV, terus biarain AI yang review hasilnya. Nanti kamu bakal dapat versi yang lebih kece, rapi, dan sesuai dengan kebutuhan dunia kerja',
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          CustomFilledButton(
            title: 'Selanjutnya',
            variant: ButtonColorVariant.blue,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}