import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mintrix/features/ai/presentation/pages/ai_page.dart';
import 'package:mintrix/features/game/presentation/pages/game_page.dart';
import 'package:mintrix/features/home/presentation/pages/home_page.dart';
import 'package:mintrix/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:mintrix/features/navigation/presentation/bloc/navigation_bloc.dart';
import 'package:mintrix/features/navigation/presentation/bloc/navigation_event.dart';
import 'package:mintrix/features/navigation/presentation/bloc/navigation_state.dart';
import 'package:mintrix/features/profile/presentation/pages/profile_page.dart';
import 'package:mintrix/features/store/presentation/pages/store_page.dart';
import 'package:mintrix/shared/theme.dart';

// Model
class NavItem {
  final String iconPath;
  final Widget page;

  const NavItem({required this.iconPath, required this.page});
}

class _MainNavigationConstants {
  static const double iconSize = 28.0;
  static const double bottomNavHeight = 70.0;

  static const List<NavItem> navItems = [
    NavItem(iconPath: 'assets/icons/navbar-home.svg', page: HomePage()),
    NavItem(
      iconPath: 'assets/icons/navbar-game.svg',
      page: GamePage(userName: 'Renata', streak: 800, gems: 280, xp: 200),
    ),
    NavItem(
      iconPath: 'assets/icons/navbar-ai.svg',
      page: AIPage(showAppBar: false),
    ),
    NavItem(
      iconPath: 'assets/icons/navbar-leaderboard.svg',
      page: LeaderboardPage(),
    ),
    NavItem(iconPath: 'assets/icons/navbar-shop.svg', page: StorePage()),
    NavItem(iconPath: 'assets/icons/navbar-profile.svg', page: ProfilePage()),
  ];
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  /// History untuk back button
  final List<int> _history = [0];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (_history.length > 1) {
              _history.removeLast();
              final lastIndex = _history.last;

              context.read<NavigationBloc>().add(UpdateIndex(lastIndex));
              return false; // jangan keluar app
            }
            return true; // boleh keluar kalau history sudah habis
          },
          child: Scaffold(
            body: _buildBody(state.index),
            bottomNavigationBar: _buildBottomNavigationBar(
              context,
              state.index,
            ),
          ),
        );
      },
    );
  }

  // Body
  Widget _buildBody(int currentIndex) {
    return IndexedStack(
      index: currentIndex,
      children: _MainNavigationConstants.navItems
          .map((item) => item.page)
          .toList(),
    );
  }

  // Bottom Navbar
  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return Container(
      height: _MainNavigationConstants.bottomNavHeight + 10,
      padding: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(
          top: BorderSide(color: bluePrimaryColor.withAlpha(100), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _buildNavigationItems(context, currentIndex),
      ),
    );
  }

  // Semua item nav
  List<Widget> _buildNavigationItems(BuildContext context, int currentIndex) {
    return List.generate(_MainNavigationConstants.navItems.length, (index) {
      final item = _MainNavigationConstants.navItems[index];
      final isActive = index == currentIndex;

      return _buildNavItem(
        context: context,
        iconPath: item.iconPath,
        isActive: isActive,
        index: index,
      );
    });
  }

  // Satu item nav
  Widget _buildNavItem({
    required BuildContext context,
    required String iconPath,
    required bool isActive,
    required int index,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => _handleNavigation(context, index),
        splashColor: bluePrimaryColor.withValues(alpha: 0.1),
        highlightColor: bluePrimaryColor.withValues(alpha: 0.05),
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: _buildNavIcon(iconPath: iconPath, isActive: isActive),
          ),
        ),
      ),
    );
  }

  // Icon SVG
  Widget _buildNavIcon({required String iconPath, required bool isActive}) {
    return SvgPicture.asset(
      iconPath,
      width: _MainNavigationConstants.iconSize,
      height: _MainNavigationConstants.iconSize,
      colorFilter: ColorFilter.mode(
        isActive ? bluePrimaryColor : secondaryColor,
        BlendMode.srcIn,
      ),
    );
  }

  // Logika onTap
  void _handleNavigation(BuildContext context, int index) {
    final bloc = context.read<NavigationBloc>();

    if (bloc.state.index != index) {
      _history.add(index);
    }

    bloc.add(UpdateIndex(index));
  }
}
