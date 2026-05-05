import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neon/core/di/service_locator.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/core/widgets/glow_wrapper.dart';
import 'package:neon/features/dashboard/widgets/app_fab.widget.dart';
import 'package:neon/features/dashboard/widgets/app_nav_rail.widget.dart';
import 'package:neon/shared/service/instance_service.dart';
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
        return 'FEED :: ${getIt.get<InstanceService>().currentInstance?.domain ?? ''}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;

          return Row(
            children: [
              if (isWide)
                AppNavRailWidget(
                  currentIndex: navigationShell.currentIndex,
                  onTap: (index) => navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  ),
                ),
              Expanded(
                child: Stack(
                  children: [
                    Column(children: [Expanded(child: navigationShell)]),
                    AppTopBarWidget(
                      title: _getTopBarTitle(navigationShell.currentIndex),
                    ),
                    if (!isWide)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AppBottomNavWidget(
                          currentIndex: navigationShell.currentIndex,
                          onTap: (index) => navigationShell.goBranch(
                            index,
                            initialLocation:
                                index == navigationShell.currentIndex,
                          ),
                        ),
                      ),
                    if (!isWide)
                      Positioned(bottom: 80, right: 20, child: const AppFab()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
