import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';
import 'package:too_too/features/dashboard/models/toot.dart';
import 'widgets/app_top_bar_widget.dart';
import 'widgets/app_bottom_nav_widget.dart';
import 'widgets/toots_list_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final toots = Toot.mockToots();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────────────
            const AppTopBarWidget(),

            // ── Feed ─────────────────────────────────────────────
            Expanded(child: TootsListWidget(toots: toots)),
          ],
        ),
      ),

      // ── Bottom Navigation ────────────────────────────────────
      bottomNavigationBar: AppBottomNavWidget(
        currentIndex: _navIndex,
        onTap: (index) => setState(() => _navIndex = index),
      ),

      // ── FAB ──────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
