import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/features/game/presentation/pages/quiz/quiz_page.dart';
import 'package:mintrix/features/game/presentation/pages/video/video_page.dart';
import 'package:mintrix/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:mintrix/features/profile/presentation/pages/detail_profile_page.dart';
import 'package:mintrix/features/profile/presentation/pages/settings.dart';
import 'package:mintrix/features/profile/presentation/pages/settings_connect.dart';
import 'package:mintrix/features/store/presentation/pages/store_page.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/features/personalization/persentation/pages/personalization_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/main/presentation/pages/main_navigation_page.dart';
import 'features/navigation/presentation/bloc/navigation_bloc.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/splash/presentation/pages/get_started_page.dart';

void main() async {
  runApp(const MyApp());
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => NavigationBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: lightBackgoundColor,
          appBarTheme: AppBarTheme(
            backgroundColor: lightBackgoundColor,
            surfaceTintColor: lightBackgoundColor,
            elevation: 0, // shadow
            centerTitle: true,
            iconTheme: IconThemeData(color: primaryColor),
            titleTextStyle: primaryTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/get-started': (context) => const GetStartedPage(),
          '/login': (context) => const LoginPage(),
          '/personalization': (context) => const PersonalizationPage(),
          '/register': (context) => const RegisterPage(),
          '/main': (context) => const MainNavigationPage(),
          '/detail-profile': (context) => const DetailProfilePage(),
          '/settings': (context) => const SettingsPage(),
          '/settings-connect': (context) => const SettingsConnectPage(),
          '/store': (context) => const StorePage(),
          '/leaderboard': (context) => const LeaderboardPage(),
          '/videoPage': (context) => const VideoPage(title: '',description: '',videoUrl: '', thumbnail: '',),
          '/quizPage': (context) => const QuizPage(),
        },
      ),
    );
  }
}
