import 'package:flutter/material.dart';
import 'package:neon/core/theme/colors.dart';

class TootActionsWidget extends StatelessWidget {
  final int replies;
  final int retoots;
  final int stars;
  final bool isFavourited;
  final bool isReblogged;
  final VoidCallback? onFavouriteToggle;
  final VoidCallback? onReblogToggle;

  const TootActionsWidget({
    super.key,
    required this.replies,
    required this.retoots,
    required this.stars,
    this.isFavourited = false,
    this.isReblogged = false,
    this.onFavouriteToggle,
    this.onReblogToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionIcon(icon: Icons.reply_rounded, count: replies),
        _ActionIcon(
          icon: isReblogged ? Icons.repeat_rounded : Icons.repeat_rounded,
          count: retoots,
          isActive: isReblogged,
          activeColor: AppColors.accent,
          onTap: onReblogToggle,
        ),
        _ActionIcon(
          icon: isFavourited ? Icons.star_rounded : Icons.star_border_rounded,
          count: stars,
          isActive: isFavourited,
          activeColor: AppColors.warning,
          onTap: onFavouriteToggle,
        ),
        _ActionIcon(icon: Icons.ios_share_rounded, count: null),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final int? count;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback? onTap;

  const _ActionIcon({
    required this.icon,
    this.count,
    this.isActive = false,
    this.activeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? (activeColor ?? AppColors.primary)
        : AppColors.iconDefault;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            if (count != null && count! > 0) ...[
              const SizedBox(width: 4),
              Text(
                _formatCount(count!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isActive ? color : AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}
