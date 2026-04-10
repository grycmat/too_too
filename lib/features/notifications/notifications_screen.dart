import 'package:flutter/material.dart';
import 'package:too_too/core/di/service_locator.dart';
import 'package:too_too/core/theme/colors.dart';
import 'package:too_too/features/dashboard/models/notification.dart' as model;
import 'package:too_too/shared/service/toots_api_service.dart';
import 'widgets/notification_card_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<model.Notification>? _notifications;
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
      final result = await getIt<TootsApiService>().getAllNotifications();
      if (!mounted) return;
      setState(() {
        _notifications = result;
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
    if (_loading && _notifications == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null && _notifications == null) {
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
                'Could not load notifications',
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

    final notifications = _notifications ?? const [];
    if (notifications.isEmpty) {
      return const Center(
        child: Text(
          'No notifications yet.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: notifications.length,
        itemBuilder: (context, index) =>
            NotificationCardWidget(notification: notifications[index]),
      ),
    );
  }
}
