import 'package:flutter/material.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/features/dashboard/models/status.dart';
import 'package:neon/features/dashboard/utils/status_formatting.dart';
import 'package:neon/features/dashboard/widgets/author_widget.dart';
import 'package:neon/features/dashboard/widgets/toot_content_widget.dart';

class QuotedStatusWidget extends StatelessWidget {
  final Status status;
  final VoidCallback? onClear;

  const QuotedStatusWidget({
    super.key,
    required this.status,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final s = status.reblog ?? status;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'QUOTING ↓',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AuthorWidget(
                accountId: s.account.id,
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
                spoilerText: s.spoilerText,
                sensitive: s.sensitive,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.repeat_rounded, size: 14, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(
                    '${s.reblogsCount}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.star_rounded, size: 14, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(
                    '${s.favouritesCount}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (onClear != null)
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.secondary),
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
