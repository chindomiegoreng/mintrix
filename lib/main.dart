import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/services/token_storage_service.dart';
import 'package:mintrix/features/auth/data/repositories/auth_repository.dart';
import 'package:mintrix/features/game/presentation/pages/buildcv/build_cv_page.dart';
import 'package:mintrix/features/game/presentation/pages/quiz/quiz_page.dart';
import 'package:mintrix/features/game/presentation/pages/video_page.dart';
import 'package:mintrix/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:mintrix/features/personalization/persentation/bloc/personalization_bloc.dart';
import 'package:mintrix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mintrix/features/profile/presentation/pages/detail_profile_page.dart';
import 'package:mintrix/features/profile/presentation/pages/download_cv.dart';
import 'package:mintrix/features/profile/presentation/pages/settings.dart';
import 'package:mintrix/features/profile/presentation/pages/settings_connect.dart';
import 'package:mintrix/features/store/presentation/pages/store_page.dart';
import 'package:mintrix/firebase_options.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/features/personalization/persentation/pages/personalization_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/main/presentation/pages/main_navigation_page.dart';
import 'features/navigation/presentation/bloc/navigation_bloc.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/splash/presentation/pages/get_started_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Token Stora
  final tokenStorageService = TokenStorageService();
  await tokenStorageService.init();
  print('✅ Token storage initialized');

  // ✅ Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
  }

  // ✅ Initialize ApiClient
  final apiClient = ApiClient();

  runApp(MyApp(apiClient: apiClient, tokenStorageService: tokenStorageService));
}

class MyApp extends StatelessWidget {
  final ApiClient apiClient; // ✅ Accept apiClient
  final TokenStorageService tokenStorageService;

  const MyApp({
    super.key,
    required this.apiClient,
    required this.tokenStorageService,
  }); // ✅ Constructor

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(
      tokenStorageService: tokenStorageService,
    );

    return MultiBlocProvider(
      providers: [
        // ✅ AuthBloc dengan ApiClient dan AuthRepository
        BlocProvider(
          create: (context) => AuthBloc(
            apiClient: apiClient,
            tokenStorageService: tokenStorageService,
            authRepository: authRepository,
          ),
        ),
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
          '/main': (context) => BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              // ✅ If user logs out while on main page, navigate to get-started
              if (state is AuthUnauthenticated) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/get-started',
                  (route) => false,
                );
              }
            },
            child: const MainNavigationPage(),
          ),
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
            moduleId: '',
            sectionId: '',
            subSection: '',
            xpReward: 0,
          ),
          '/quizPage': (context) =>
              const QuizPage(moduleId: '', sectionId: '', subSection: ''),
          '/build-cv': (context) => const BuildCVPage(),
        },
      ),
    );
  }
}
