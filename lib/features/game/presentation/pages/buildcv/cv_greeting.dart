import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';

class CVGreeting extends StatelessWidget {
  final VoidCallback onNext;

  const CVGreeting({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          Text(
            'Yuk, Cobain Bikin CV-mu Sendiri',
            style: secondaryTextStyle.copyWith(
              fontSize: 20,
              fontWeight: regular,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Ceritain pengalaman dan keahlianmu lewat CV, terus biarain AI yang review hasilnya. Nanti kamu bakal dapat versi yang lebih kece, rapi, dan sesuai dengan kebutuhan dunia kerja',
            style: secondaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: regular,
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
