import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/api/api_client.dart'; // ✅ Import ApiClient
import 'package:mintrix/features/game/presentation/pages/buildcv/build_cv_page.dart';
import 'package:mintrix/features/game/presentation/pages/quiz/quiz_page.dart';
import 'package:mintrix/features/game/presentation/pages/video_page.dart';
import 'package:mintrix/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:mintrix/features/personalization/persentation/bloc/personalization_bloc.dart'; // ✅ Import
import 'package:mintrix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mintrix/features/profile/presentation/pages/detail_profile_page.dart';
import 'package:mintrix/features/profile/presentation/pages/download_cv.dart';
import 'package:mintrix/features/profile/presentation/pages/settings.dart';
import 'package:mintrix/features/profile/presentation/pages/settings_connect.dart';
import 'package:mintrix/features/store/presentation/pages/store_page.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/features/personalization/persentation/pages/personalization_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/main/presentation/pages/main_navigation_page.dart';
import 'features/navigation/presentation/bloc/navigation_bloc.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/splash/presentation/pages/get_started_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Required untuk async operations

  // ✅ Initialize ApiClient
  final apiClient = ApiClient();

  runApp(MyApp(apiClient: apiClient)); // ✅ Pass apiClient

  // ⚠️ Clear preferences (hanya untuk development testing)
  // Hapus baris ini di production!
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
}

class MyApp extends StatelessWidget {
  final ApiClient apiClient; // ✅ Accept apiClient

  const MyApp({super.key, required this.apiClient}); // ✅ Constructor

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ✅ AuthBloc dengan ApiClient
        BlocProvider(create: (context) => AuthBloc(apiClient: apiClient)),
        // ✅ PersonalizationBloc dengan ApiClient
        BlocProvider(
          create: (context) => PersonalizationBloc(apiClient: apiClient),
        ),
        // ✅ ProfileBloc dengan ApiClient
        BlocProvider(create: (context) => ProfileBloc(apiClient: apiClient)),
        // ✅ NavigationBloc (tidak butuh ApiClient)
        BlocProvider(create: (context) => NavigationBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: lightBackgoundColor,
          appBarTheme: AppBarTheme(
            backgroundColor: lightBackgoundColor,
            surfaceTintColor: lightBackgoundColor,
            elevation: 0,
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
          '/download-cv': (context) => const DownloadCv(),
          '/videoPage': (context) => const VideoPage(
            title: '',
            description: '',
            videoUrl: '',
            thumbnail: '',
          ),
          '/quizPage': (context) =>
              const QuizPage(moduleId: '', sectionId: '', subSection: ''),
          '/build-cv': (context) => const BuildCVPage(),
        },
      ),
    );
  }
}
