import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mintrix/features/auth/presentation/bloc/auth_event.dart';
import 'package:mintrix/features/auth/presentation/bloc/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Trigger token check when app starts
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<AuthBloc>().add(CheckTokenEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // User has valid token, navigate to main
            Navigator.pushReplacementNamed(context, '/main');
          } else if (state is AuthUnauthenticated) {
            // No valid token, navigate to get started
            Navigator.pushReplacementNamed(context, '/get-started');
          }
        },
        child: Center(
          child: CachedNetworkImage(
            imageUrl:
                'https://res.cloudinary.com/dy4hqxkv1/image/upload/v1762846587/character18_auvbpd.png',
            width: 265,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
