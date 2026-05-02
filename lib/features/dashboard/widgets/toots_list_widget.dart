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
  List<Status> _statuses = [];
  final ScrollController _scrollController = ScrollController();

  bool _loading = false;
  bool _isLoadingMore = false;
  bool _hasReachedEnd = false;
  Object? _error;

  static const double _loadMoreThreshold = 300;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitial();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore || _hasReachedEnd || _loading) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - _loadMoreThreshold) {
      _loadMore();
    }
  }

  Future<List<Status>> _fetchPage({String? maxId}) async {
    switch (widget.timelineType) {
      case TimelineType.home:
        return getIt<TootsApiService>().getUserTimeline(maxId: maxId);
      case TimelineType.public:
        return getIt<TootsApiService>().getPublicTimeline(maxId: maxId);
      case TimelineType.account:
        return getIt<TootsApiService>().getAccountStatuses(
          widget.accountId!,
          maxId: maxId,
        );
    }
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loading = true;
      _error = null;
      _hasReachedEnd = false;
    });
    try {
      final result = await _fetchPage();
      if (!mounted) return;
      setState(() {
        _statuses
          ..clear()
          ..addAll(result);
        _loading = false;
        if (result.isEmpty) _hasReachedEnd = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_statuses.isEmpty) return;

    setState(() => _isLoadingMore = true);
    try {
      final maxId = _statuses.last.id;
      final result = await _fetchPage(maxId: maxId);
      if (!mounted) return;
      setState(() {
        if (result.isEmpty) {
          _hasReachedEnd = true;
        } else {
          final nextStatuses = [..._statuses, ...result];
          setState(() {
            _statuses = nextStatuses;
          });
        }
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && _statuses.isEmpty) {
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
              FilledButton(onPressed: _loadInitial, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInitial,
      color: AppColors.primary,
      child: Skeletonizer(
        enabled: _loading && _statuses.isEmpty,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 8, bottom: 80),

          itemCount: _statuses.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) return const SizedBox(height: 100);

            if (index == _statuses.length + 1) {
              if (_isLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox(height: 100);
            }

            final status = _statuses[index - 1];
            return TootCardWidget(status: status);
          },
        ),
      ),
    );
  }
}
