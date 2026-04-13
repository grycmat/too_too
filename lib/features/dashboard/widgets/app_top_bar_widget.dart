import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTopBarWidget extends StatelessWidget {
  final String title;

  const AppTopBarWidget({super.key, this.title = 'FEED'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 4),
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
    );
  }
}
