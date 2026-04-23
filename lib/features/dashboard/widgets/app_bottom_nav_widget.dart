import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:neon/core/theme/colors.dart';

class AppBottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  @Preview(name: 'Bottom Nav')
  const AppBottomNavWidget({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: AppColors.navBarBackground.withValues(alpha: 0.6),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.navBarSelected,
          unselectedItemColor: AppColors.navBarUnselected,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.language_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
