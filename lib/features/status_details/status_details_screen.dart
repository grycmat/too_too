import 'package:flutter/material.dart';
import 'package:too_too/core/di/service_locator.dart';
import 'package:too_too/core/theme/colors.dart';
import 'package:too_too/features/dashboard/models/status.dart';
import 'package:too_too/features/dashboard/models/status_context.dart';
import 'package:too_too/shared/service/toots_api_service.dart';

import 'widgets/status_hero_widget.dart';
import 'widgets/transmission_logs_widget.dart';

class StatusDetailsScreen extends StatefulWidget {
  final String statusId;

  const StatusDetailsScreen({super.key, required this.statusId});

  @override
  State<StatusDetailsScreen> createState() => _StatusDetailsScreenState();
}

class _StatusDetailsScreenState extends State<StatusDetailsScreen> {
  late Future<Status> _statusFuture;
  late Future<StatusContext> _contextFuture;
  final TootsApiService _tootsApiService = getIt<TootsApiService>();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _statusFuture = _tootsApiService.getStatusDetails(widget.statusId);
    _contextFuture = _tootsApiService.getStatusContext(widget.statusId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Status>(
      future: _statusFuture,
      builder: (context, statusSnapshot) {
        if (statusSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (statusSnapshot.hasError) {
          return Center(
            child: Text(
              'Error loading status',
              style: const TextStyle(color: AppColors.error),
            ),
          );
        }

        final status = statusSnapshot.data;
        if (status == null) return const SizedBox();

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 100,),),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: StatusHeroWidget(status: status),
                ),
              ),
              SliverToBoxAdapter(
                child: FutureBuilder<StatusContext>(
                  future: _contextFuture,
                  builder: (context, contextSnapshot) {
                    if (contextSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }
                    if (contextSnapshot.hasError || !contextSnapshot.hasData) {
                      return const SizedBox();
                    }

                    final contextData = contextSnapshot.data!;
                    final replies = contextData.descendants;

                    if (replies.isEmpty) return const SizedBox();

                    return TransmissionLogsWidget(replies: replies);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
