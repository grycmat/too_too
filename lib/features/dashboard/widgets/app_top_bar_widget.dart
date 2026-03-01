import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';

class AppTopBarWidget extends StatelessWidget {
  final String title;

  const AppTopBarWidget({super.key, this.title = 'FEED'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Title ────────────────────────────────────────────
          Text(title, style: Theme.of(context).textTheme.headlineLarge),

          // ── Profile avatar ───────────────────────────────────
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.glowBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGlow,
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surface,
              child: Icon(Icons.person, color: AppColors.primary, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
