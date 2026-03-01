import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';

class TootActionsWidget extends StatelessWidget {
  final int replies;
  final int retoots;
  final int stars;

  const TootActionsWidget({
    super.key,
    required this.replies,
    required this.retoots,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionIcon(icon: Icons.reply_rounded, count: replies),
        _ActionIcon(icon: Icons.repeat_rounded, count: retoots),
        _ActionIcon(icon: Icons.star_border_rounded, count: stars),
        _ActionIcon(icon: Icons.ios_share_rounded, count: null),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final int? count;

  const _ActionIcon({required this.icon, this.count});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.iconDefault, size: 20),
            if (count != null && count! > 0) ...[
              const SizedBox(width: 4),
              Text(
                _formatCount(count!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
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
