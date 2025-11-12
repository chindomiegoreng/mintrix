import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Image.asset('assets/images/dino_get_started.png', width: 250),
              CachedNetworkImage(
                imageUrl:
                    'https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846592/character24_ufobti.png',
                width: 250,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
              ),
              const Spacer(),
              Text(
                'Yeay, Mintrix adalah temanmu untuk membantu mengenal diri lebih lagi',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              CustomFilledButton(
                title: 'Ayo Mulai Sekarang',
                variant: ButtonColorVariant.blue,
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
              const SizedBox(height: 16),
              CustomFilledButton(
                title: 'Masuk Yuk',
                variant: ButtonColorVariant.white,
                withShadow: true,
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
