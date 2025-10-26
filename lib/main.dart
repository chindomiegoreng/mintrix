import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/features/profile/presentation/pages/detail_profile_page.dart';
import 'package:mintrix/features/profile/presentation/pages/settings.dart';
import 'package:mintrix/features/profile/presentation/pages/settings_connect.dart';
import 'package:mintrix/shared/theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/main/presentation/pages/main_navigation_page.dart';
import 'features/navigation/presentation/bloc/navigation_bloc.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/splash/presentation/pages/get_started_page.dart';

void main() {
  runApp(const MyApp());
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
          // reusable app bar
          scaffoldBackgroundColor: lightBackgoundColor,
          appBarTheme: AppBarTheme(
            backgroundColor: lightBackgoundColor,
            surfaceTintColor:
                lightBackgoundColor, // ketika scroll appbar akan berada di lightbackgroundcolor
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
          '/register': (context) => const RegisterPage(),
          '/main': (context) => const MainNavigationPage(),
          '/detail-profile': (context) => const DetailProfilePage(),
          '/settings': (context) => const SettingsPage(),
          '/settings-connect': (context) => const SettingsConnectPage(),
        },
      ),
    );
  }
}
