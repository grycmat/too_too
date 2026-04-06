import 'package:flutter/material.dart';

class StatusChipWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? iconColor;

  const StatusChipWidget({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ActionChip(
      avatar: Icon(
        icon,
        size: 16,
        color: iconColor ?? colorScheme.primary,
      ),
      label: Text(label),
      onPressed: onTap ?? () {},
      side: BorderSide(
        color: colorScheme.primary.withValues(alpha: 0.5),
        width: 0.5,
      ),
    );
  }
}
