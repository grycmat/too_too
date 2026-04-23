import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/features/dashboard/models/status.dart';
import 'package:neon/features/status_details/widgets/transmission_log_reply_widget.dart';

class TransmissionLogsWidget extends StatelessWidget {
  final List<Status> replies;

  const TransmissionLogsWidget({super.key, required this.replies});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'CONVERSATION',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: Container(height: 1, color: AppColors.divider)),
            ],
          ),
          const SizedBox(height: 24),
          ...replies.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                final path = '/status/${entry.value.id}';
                context.push(path);
              },
              child: TransmissionLogReplyWidget(
                reply: entry.value,
                isLast: entry.key == replies.length - 1,
              ),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
