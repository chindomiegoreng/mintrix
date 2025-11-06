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

// Model nggo Navigation Item
class NavItem {
  final String iconPath;
  final Widget page;

  const NavItem({required this.iconPath, required this.page});
}

// Constants nggo Main Navigation
class _MainNavigationConstants {
  static const double iconSize = 28.0;
  static const double bottomNavHeight = 70.0;

  static const List<NavItem> navItems = [
    NavItem(iconPath: 'assets/icons/navbar-home.svg', page: HomePage()),
    NavItem(iconPath: 'assets/icons/navbar-game.svg', page: GamePage(userName: 'Renata', streak: 800, gems: 280, xp: 200,)),
    NavItem(iconPath: 'assets/icons/navbar-ai.svg', page: AIPage()),
    NavItem(
      iconPath: 'assets/icons/navbar-leaderboard.svg',
      page: LeaderboardPage(),
    ),
    NavItem(iconPath: 'assets/icons/navbar-shop.svg', page: StorePage()),
    NavItem(iconPath: 'assets/icons/navbar-profile.svg', page: ProfilePage()),
  ];
}

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state.index),
          bottomNavigationBar: _buildBottomNavigationBar(context, state.index),
        );
      },
    );
  }

  Widget _buildBody(int currentIndex) {
    return IndexedStack(
      index: currentIndex,
      children: _MainNavigationConstants.navItems
          .map((item) => item.page)
          .toList(),
    );
  }

  // Bottom Navigation Bar karo custom
  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return Container(
      height: _MainNavigationConstants.bottomNavHeight,
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(top: BorderSide(color: bluePrimaryColor.withAlpha(100), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _buildNavigationItems(context, currentIndex),
      ),
    );
  }

  // Build navigation items karo custom SVG icons
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

  // Build single navigation item
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

  // Build custom SVG icon karo color change
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

  // Handle navigation tap
  void _handleNavigation(BuildContext context, int index) {
    context.read<NavigationBloc>().add(UpdateIndex(index));
  }
}

