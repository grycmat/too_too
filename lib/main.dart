import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() {
  runApp(const TooTooApp());
}

class TooTooApp extends StatelessWidget {
  const TooTooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Too Too',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DashboardScreen(),
    );
  }
}
