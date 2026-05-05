import 'package:flutter/material.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/core/widgets/glow_wrapper.dart';
import 'package:go_router/go_router.dart';

class AppFab extends StatelessWidget {
  const AppFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.push('/compose');
      },
      child: SizedBox(
        width: 56,
        height: 56,
        child: GlowWrapper(
          borderRadius: 50,
          blurRadius: 4,
          glowColor: AppColors.primary,
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }
}
