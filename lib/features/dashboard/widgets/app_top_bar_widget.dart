import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTopBarWidget extends StatelessWidget {
  final String title;

  const AppTopBarWidget({super.key, this.title = 'NEON_FEED'});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineLarge),
              IconButton(
                onPressed: () {
                  context.pushNamed('/settings');
                },
                icon: Icon(Icons.settings_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
