import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';
import 'package:too_too/features/dashboard/models/toot.dart';
import 'author_widget.dart';
import 'toot_content_widget.dart';
import 'toot_actions_widget.dart';

class TootCardWidget extends StatelessWidget {
  final Toot toot;

  const TootCardWidget({super.key, required this.toot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glowBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGlow.withValues(alpha: 0.25),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthorWidget(
              name: toot.authorName,
              handle: toot.authorHandle,
              avatarUrl: toot.authorAvatarUrl,
              timestamp: toot.timestamp,
            ),

            const SizedBox(height: 12),

            TootContentWidget(content: toot.content, imageUrl: toot.imageUrl),

            const SizedBox(height: 14),

            TootActionsWidget(
              replies: toot.replies,
              retoots: toot.retoots,
              stars: toot.stars,
            ),
          ],
        ),
      ),
    );
  }
}
