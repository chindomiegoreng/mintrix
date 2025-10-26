import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToGetStarted();
  }

  Future<void> _navigateToGetStarted() async {
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/get-started');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/logo_mintrix.png', width: 200),
      ),
    );
  }
}
