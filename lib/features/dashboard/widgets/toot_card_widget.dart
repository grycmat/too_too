import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';
import 'package:too_too/features/dashboard/models/status.dart';
import 'package:too_too/features/dashboard/utils/status_formatting.dart';
import 'author_widget.dart';
import 'toot_content_widget.dart';
import 'toot_actions_widget.dart';

class TootCardWidget extends StatelessWidget {
  final Status status;

  const TootCardWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final s = status.reblog ?? status;

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
              name: s.account.displayName.isNotEmpty
                  ? s.account.displayName
                  : s.account.username,
              handle: '@${s.account.acct}',
              avatarUrl: s.account.avatar.isNotEmpty ? s.account.avatar : null,
              timestamp: relativeTime(s.createdAt),
            ),

            const SizedBox(height: 12),

            TootContentWidget(
              content: htmlToPlainText(s.content),
              imageUrl: firstImageUrl(s.mediaAttachments),
            ),

            const SizedBox(height: 14),

            TootActionsWidget(
              replies: s.repliesCount,
              retoots: s.reblogsCount,
              stars: s.favouritesCount,
            ),
          ],
        ),
      ),
    );
  }
}
