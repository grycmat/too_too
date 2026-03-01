import 'package:flutter/material.dart';
import 'package:too_too/features/dashboard/models/toot.dart';
import 'toot_card_widget.dart';

class TootsListWidget extends StatelessWidget {
  final List<Toot> toots;

  const TootsListWidget({super.key, required this.toots});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: toots.length,
      itemBuilder: (context, index) => TootCardWidget(toot: toots[index]),
    );
  }
}
