import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Explore',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
      ),
    );
  }
}
