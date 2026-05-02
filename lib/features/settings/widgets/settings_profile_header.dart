import 'package:flutter/material.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/core/widgets/avatar_widget.dart';
import 'package:neon/core/widgets/neon_card_widget.dart';

class SettingsProfileHeader extends StatelessWidget {
  final String displayName;
  final String handle;
  final String avatarUrl;
  final String versionLabel;
  final VoidCallback? onEdit;

  const SettingsProfileHeader({
    super.key,
    required this.displayName,
    required this.handle,
    required this.avatarUrl,
    required this.versionLabel,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NeonCardWidget(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarWidget(
            imageUrl: avatarUrl,
            fallbackText: displayName,
            radius: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName.toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  handle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                _VersionChip(label: versionLabel),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.primary,
              size: 20,
            ),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _VersionChip extends StatelessWidget {
  final String label;

  const _VersionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.secondary, width: 0.8),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.secondary,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
