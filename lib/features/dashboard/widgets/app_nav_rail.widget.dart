import 'package:flutter/material.dart';
import 'package:neon/features/dashboard/widgets/app_fab.widget.dart';
import 'package:neon/core/theme/colors.dart';

class AppNavRailWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppNavRailWidget({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      labelType: NavigationRailLabelType.none,
      indicatorColor: AppColors.navBarSelected,
      trailingAtBottom: true,
      trailing: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: const AppFab(),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(Icons.notifications_rounded),
          label: Text('Notifications'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.language_outlined),
          selectedIcon: Icon(Icons.language_rounded),
          label: Text('Explore'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: Text('Profile'),
        ),
      ],
    );
  }
}
