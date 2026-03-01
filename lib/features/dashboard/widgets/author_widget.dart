import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';

class AuthorWidget extends StatelessWidget {
  final String name;
  final String handle;
  final String? avatarUrl;
  final String timestamp;

  const AuthorWidget({
    super.key,
    required this.name,
    required this.handle,
    this.avatarUrl,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        // ── Avatar ──────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.glowBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGlow,
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.surface,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : null,
            child: avatarUrl == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  )
                : null,
          ),
        ),

        const SizedBox(width: 12),

        // ── Name + Handle ──────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: tt.titleMedium),
              const SizedBox(height: 2),
              Text(handle, style: tt.titleSmall),
            ],
          ),
        ),

        // ── Timestamp ──────────────────────────────────────────
        Text(timestamp, style: tt.bodySmall),
      ],
    );
  }
}
