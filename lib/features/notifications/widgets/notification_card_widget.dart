import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';
import 'package:too_too/features/dashboard/models/notification.dart' as model;
import 'package:too_too/features/dashboard/utils/status_formatting.dart';
import 'package:too_too/features/dashboard/widgets/toot_content_widget.dart';
import 'package:too_too/features/profile/profile_screen.dart';
import 'package:too_too/features/status_details/status_details_screen.dart';

class NotificationCardWidget extends StatelessWidget {
  final model.Notification notification;

  const NotificationCardWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    switch (notification.type) {
      case 'mention':
        return _buildMentionCard(context);
      case 'reblog':
        return _buildReblogCard(context);
      case 'favourite':
        return _buildFavouriteCard(context);
      case 'follow':
        return _buildFollowCard(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWrapper({
    required BuildContext context,
    required bool isPrimary,
    required IconData badgeIcon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary ? AppColors.primary : AppColors.secondary,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isPrimary ? AppColors.primaryGlow : AppColors.secondaryGlow)
                .withValues(alpha: 0.25),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NotificationAvatar(
            avatarUrl: notification.account.avatar,
            isPrimary: isPrimary,
            badgeIcon: badgeIcon,
          ),
          const SizedBox(width: 16),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildMentionCard(BuildContext context) {
    final status = notification.status;
    if (status == null) return const SizedBox();

    return _buildWrapper(
      context: context,
      isPrimary: true,
      badgeIcon: Icons.alternate_email,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '@${notification.account.username}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                relativeTime(notification.createdAt),
                style: const TextStyle(color: AppColors.textHint, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StatusDetailsScreen(statusId: notification.status!.id),
                ),
              );
            },
            child: TootContentWidget(content: htmlToPlainText(status.content)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.alternate_email,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 16),
              const Icon(Icons.reply, size: 16, color: AppColors.textHint),
              const SizedBox(width: 16),
              const Icon(Icons.favorite, size: 16, color: AppColors.textHint),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReblogCard(BuildContext context) {
    final status = notification.status;
    return _buildWrapper(
      context: context,
      isPrimary: false,
      badgeIcon: Icons.bolt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: notification.account.displayName.isNotEmpty
                      ? notification.account.displayName
                      : notification.account.username,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' boosted your status'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (status != null)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StatusDetailsScreen(statusId: notification.status!.id),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"${htmlToPlainText(status.content)}"',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFavouriteCard(BuildContext context) {
    final status = notification.status;

    return _buildWrapper(
      context: context,
      isPrimary: true,
      badgeIcon: Icons.favorite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: notification.account.displayName.isNotEmpty
                      ? notification.account.displayName
                      : notification.account.username,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' favorited your status'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (status != null)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StatusDetailsScreen(statusId: notification.status!.id),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"${htmlToPlainText(status.content)}"',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFollowCard(BuildContext context) {
    return _buildWrapper(
      context: context,
      isPrimary: false,
      badgeIcon: Icons.person_add,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileScreen(accountId: notification.account.id),
                ),
              );
            },
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    notification.account.displayName.isNotEmpty
                        ? notification.account.displayName
                        : notification.account.username,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'FOLLOWED YOU',
                    style: TextStyle(
                      color: AppColors.secondaryVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 32,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(
                  color: AppColors.secondaryVariant,
                  width: 1,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'FOLLOW BACK',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationAvatar extends StatelessWidget {
  final String avatarUrl;
  final bool isPrimary;
  final IconData badgeIcon;

  const _NotificationAvatar({
    required this.avatarUrl,
    required this.isPrimary,
    required this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPrimary ? AppColors.primary : AppColors.secondary;
    final glow = isPrimary ? AppColors.primaryGlow : AppColors.secondaryGlow;

    return SizedBox(
      width: 58,
      height: 58,
      child: Stack(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color, width: 1.5),
              boxShadow: [
                BoxShadow(color: glow, blurRadius: 10, spreadRadius: 1),
              ],
              image: avatarUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(avatarUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: avatarUrl.isEmpty ? Icon(Icons.person, color: color) : null,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.card,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.2),
              ),
              child: Icon(badgeIcon, size: 14, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
