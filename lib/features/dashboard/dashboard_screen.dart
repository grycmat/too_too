import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:too_too/core/theme/colors.dart';
import 'widgets/app_top_bar_widget.dart';
import 'widgets/app_bottom_nav_widget.dart';

class DashboardScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBarWidget(),

            Expanded(child: navigationShell),
          ],
        ),
      ),

      bottomNavigationBar: AppBottomNavWidget(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
