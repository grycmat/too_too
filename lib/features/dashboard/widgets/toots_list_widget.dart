import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:neon/core/di/service_locator.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/features/dashboard/models/status.dart';
import 'package:neon/shared/service/toots_api_service.dart';
import 'toot_card_widget.dart';

enum TimelineType { home, public, account }

class TootsListWidget extends StatefulWidget {
  final TimelineType timelineType;
  final String? accountId;

  const TootsListWidget({
    super.key,
    this.timelineType = TimelineType.home,
    this.accountId,
  }) : assert(
         timelineType != TimelineType.account || accountId != null,
         'accountId must be provided when timelineType is account',
       );

  @override
  State<TootsListWidget> createState() => _TootsListWidgetState();
}

class _TootsListWidgetState extends State<TootsListWidget> {
  List<Status>? _statuses;
  bool _loading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final List<Status> result;
      switch (widget.timelineType) {
        case TimelineType.home:
          result = await getIt<TootsApiService>().getUserTimeline();
          break;
        case TimelineType.public:
          result = await getIt<TootsApiService>().getPublicTimeline();
          break;
        case TimelineType.account:
          result = await getIt<TootsApiService>().getAccountStatuses(
            widget.accountId!,
          );
          break;
      }
      if (!mounted) return;
      setState(() {
        _statuses = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && _statuses == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: AppColors.textHint,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                'Could not load timeline',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '$_error',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final statuses = _statuses ?? const [];
    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primary,
      child: Skeletonizer(
        enabled: _loading,
        child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          children: [
            SizedBox(height: 100),
            ...statuses.map((status) => TootCardWidget(status: status)).toList(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
