import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neon/core/di/service_locator.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/features/dashboard/models/status.dart';
import 'package:neon/features/dashboard/utils/status_formatting.dart';
import 'package:neon/features/status_details/media_details_screen.dart';
import 'package:neon/shared/service/toots_api_service.dart';

import 'author_widget.dart';
import 'toot_actions_widget.dart';
import 'toot_content_widget.dart';

class TootCardWidget extends StatefulWidget {
  final Status status;

  const TootCardWidget({super.key, required this.status});

  @override
  State<TootCardWidget> createState() => _TootCardWidgetState();
}

class _TootCardWidgetState extends State<TootCardWidget> {
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

    return GestureDetector(
      onTap: () {
        final location = GoRouterState.of(context).matchedLocation;
        final path = location == '/'
            ? '/status/${s.id}'
            : '$location/status/${s.id}';
        context.push(path);
      },
      child: Container(
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
                accountId: s.account.id,
                name: s.account.displayName.isNotEmpty
                    ? s.account.displayName
                    : s.account.username,
                handle: '@${s.account.acct}',
                avatarUrl: s.account.avatar.isNotEmpty
                    ? s.account.avatar
                    : null,
                timestamp: relativeTime(s.createdAt),
              ),

              const SizedBox(height: 12),

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

              const SizedBox(height: 14),

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
        ),
      ),
    );
  }
}
