import 'package:flutter/material.dart';
import 'package:neon/features/dashboard/widgets/toots_list_widget.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TootsListWidget(timelineType: TimelineType.public);
  }
}
