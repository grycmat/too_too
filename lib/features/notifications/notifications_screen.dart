import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Notifications',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
      ),
    );
  }
}
