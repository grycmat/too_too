import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neon/core/di/service_locator.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/features/dashboard/models/status.dart';
import 'package:neon/features/dashboard/utils/status_formatting.dart';
import 'package:neon/features/dashboard/widgets/author_widget.dart';
import 'package:neon/features/dashboard/widgets/toot_actions_widget.dart';
import 'package:neon/features/dashboard/widgets/toot_content_widget.dart';
import 'package:neon/features/status_details/media_details_screen.dart';
import 'package:neon/shared/service/toots_api_service.dart';

class StatusHeroWidget extends StatefulWidget {
  final Status status;

  const StatusHeroWidget({super.key, required this.status});

  @override
  State<StatusHeroWidget> createState() => _StatusHeroWidgetState();
}

class _StatusHeroWidgetState extends State<StatusHeroWidget> {
  late bool _isFavourited;
  late bool _isReblogged;
  late int _favouritesCount;
  late int _reblogsCount;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final s = widget.status.reblog ?? widget.status;
    _isFavourited = s.favourited ?? false;
    _isReblogged = s.reblogged ?? false;
    _favouritesCount = s.favouritesCount;
    _reblogsCount = s.reblogsCount;
  }

  Future<void> _toggleFavourite() async {
    if (_busy) return;
    _busy = true;
    final s = widget.status.reblog ?? widget.status;
    try {
      if (_isFavourited) {
        await getIt<TootsApiService>().unfavouriteStatus(s.id);
        if (!mounted) return;
        setState(() {
          _isFavourited = false;
          _favouritesCount = (_favouritesCount - 1).clamp(0, 999999);
        });
      } else {
        await getIt<TootsApiService>().favouriteStatus(s.id);
        if (!mounted) return;
        setState(() {
          _isFavourited = true;
          _favouritesCount += 1;
        });
      }
    } catch (_) {
    } finally {
      _busy = false;
    }
  }

  Future<void> _toggleReblog() async {
    if (_busy) return;
    _busy = true;
    final s = widget.status.reblog ?? widget.status;
    try {
      if (_isReblogged) {
        await getIt<TootsApiService>().unreblogStatus(s.id);
        if (!mounted) return;
        setState(() {
          _isReblogged = false;
          _reblogsCount = (_reblogsCount - 1).clamp(0, 999999);
        });
      } else {
        await getIt<TootsApiService>().reblogStatus(s.id);
        if (!mounted) return;
        setState(() {
          _isReblogged = true;
          _reblogsCount += 1;
        });
      }
    } catch (_) {
    } finally {
      _busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.status.reblog ?? widget.status;
    final String domain = s.account.acct.contains('@')
        ? s.account.acct.split('@').last
        : 'LOCAL';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glowBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGlow.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AuthorWidget(
                  accountId: s.account.id,
                  name: s.account.displayName.isNotEmpty
                      ? s.account.displayName
                      : s.account.username,
                  handle: '@${s.account.acct}',
                  avatarUrl: s.account.avatar.isNotEmpty
                      ? s.account.avatar
                      : null,
                  timestamp: '',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  domain.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TootContentWidget(
            content: htmlToPlainText(s.content),
            imageUrl: firstImageUrl(s.mediaAttachments),
            spoilerText: s.spoilerText,
            sensitive: s.sensitive,
            onImageTap: () {
              final imageUrl = firstImageUrl(s.mediaAttachments);
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
          const SizedBox(height: 16),
          Text(
            '${s.createdAt.hour.toString().padLeft(2, '0')}:${s.createdAt.minute.toString().padLeft(2, '0')} // ${s.createdAt.day} ${s.createdAt.month} ${s.createdAt.year}  •  ${s.application?.name?.toUpperCase() ?? "WEB"}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textHint,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider, thickness: 1),
          const SizedBox(height: 12),
          TootActionsWidget(
            replies: s.repliesCount,
            retoots: _reblogsCount,
            stars: _favouritesCount,
            isFavourited: _isFavourited,
            isReblogged: _isReblogged,
            onFavouriteToggle: _toggleFavourite,
            onReblogToggle: _toggleReblog,
            onQuoteTap: () => context.push('/compose', extra: s),
          ),
        ],
      ),
    );
  }
}

extension StatusApplicationExtension on Status {
  Application? get application => null;
}

class Application {
  final String? name;
  Application({this.name});
}
