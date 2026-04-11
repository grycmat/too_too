import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String label;
  final Color? color;

  const SettingsSectionHeader({
    super.key,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.primary;
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: accent,
          letterSpacing: 2,
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label.toUpperCase(), style: labelStyle),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: accent.withValues(alpha: 0.25),
            ),
          ),
        ],
      ),
    );
  }
}
