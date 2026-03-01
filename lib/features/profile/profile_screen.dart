import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
      ),
    );
  }
}
