import 'package:flutter/material.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/features/dashboard/models/status.dart';
import 'package:neon/features/dashboard/utils/status_formatting.dart';
import 'package:neon/features/status_details/media_details_screen.dart';
import 'package:neon/features/dashboard/widgets/toot_content_widget.dart';

class TransmissionLogReplyWidget extends StatelessWidget {
  final Status reply;
  final bool isLast;

  const TransmissionLogReplyWidget({
    super.key,
    required this.reply,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.glowBorder, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.primaryGlow,
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.surface,
                    backgroundImage: reply.account.avatar.isNotEmpty
                        ? NetworkImage(reply.account.avatar)
                        : null,
                    child: reply.account.avatar.isEmpty
                        ? Text(
                            reply.account.displayName.isNotEmpty
                                ? reply.account.displayName[0].toUpperCase()
                                : '?',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          )
                        : null,
                  ),
                ),
                if (!isLast) ...[
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        color: AppColors.divider.withValues(alpha: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGlow.withValues(alpha: 0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            reply.account.displayName.isNotEmpty
                                ? reply.account.displayName.toUpperCase()
                                : reply.account.username.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          relativeTime(reply.createdAt).toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textHint,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TootContentWidget(
                      content: htmlToPlainText(reply.content),
                      imageUrl: firstImageUrl(reply.mediaAttachments),
                      spoilerText: reply.spoilerText,
                      sensitive: reply.sensitive,
                      onImageTap: () {
                        final imageUrl = firstImageUrl(reply.mediaAttachments);
                        if (imageUrl != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  MediaDetailsScreen(imageUrl: imageUrl),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.reply,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 32),
                        Icon(
                          reply.favourited == true
                              ? Icons.star
                              : Icons.star_border,
                          color: AppColors.primary,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
