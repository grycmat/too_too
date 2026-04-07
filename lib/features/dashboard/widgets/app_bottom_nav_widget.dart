import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:too_too/core/theme/colors.dart';

class AppBottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  @Preview(name: 'Bottom Nav')
  const AppBottomNavWidget({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navBarBackground,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
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
    );
  }
}
