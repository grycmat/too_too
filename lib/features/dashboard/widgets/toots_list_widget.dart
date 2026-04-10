import 'package:flutter/material.dart';
import 'package:too_too/core/di/service_locator.dart';
import 'package:too_too/core/theme/colors.dart';
import 'package:too_too/features/dashboard/models/status.dart';
import 'package:too_too/shared/service/toots_api_service.dart';
import 'toot_card_widget.dart';

class TootsListWidget extends StatefulWidget {
  final String? accountId;

  const TootsListWidget({super.key, this.accountId});

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
      final result = widget.accountId != null
          ? await getIt<TootsApiService>().getAccountStatuses(widget.accountId!)
          : await getIt<TootsApiService>().getUserTimeline();
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
    if (_loading && _statuses == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

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
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: statuses.length,
        itemBuilder: (context, index) =>
            TootCardWidget(status: statuses[index]),
      ),
    );
  }
}
