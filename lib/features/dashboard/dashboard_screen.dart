import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:too_too/core/theme/colors.dart';
import 'package:too_too/core/widgets/glow_wrapper.dart';
import 'package:too_too/features/new_toot/new_toot_screen.dart';
import 'widgets/app_top_bar_widget.dart';
import 'widgets/app_bottom_nav_widget.dart';

class DashboardScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(children: [Expanded(child: navigationShell)]),
          const AppTopBarWidget(),
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
                showModalBottomSheet(
                  showDragHandle: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => const NewTootScreen(),
                );
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
