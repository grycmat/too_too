import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/core/widgets/glow_wrapper.dart';
import 'widgets/app_top_bar_widget.dart';
import 'widgets/app_bottom_nav_widget.dart';

class DashboardScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardScreen({super.key, required this.navigationShell});

  String _getTopBarTitle(int currentIndex) {
    switch (currentIndex) {
      case 1:
        return 'INCOMING :: NOTIFY';
      case 2:
        return 'EXPLORE';
      case 3:
        return 'PROVILER_VIEW';
      case 0:
      default:
        return 'NEON_FEED';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(children: [Expanded(child: navigationShell)]),
          AppTopBarWidget(title: _getTopBarTitle(navigationShell.currentIndex)),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNavWidget(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                context.push('/compose');
              },
              child: SizedBox(
                width: 56,
                height: 56,
                child: GlowWrapper(
                  borderRadius: 50,
                  glowColor: AppColors.primary,
                  child: const Icon(Icons.add, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
