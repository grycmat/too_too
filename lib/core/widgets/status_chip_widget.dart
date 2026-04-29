import 'package:flutter/material.dart';

class StatusChipWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool isActive;

  const StatusChipWidget({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.iconColor,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ActionChip(
      avatar: Icon(
        icon,
        size: 16,
        color: isActive
            ? colorScheme.onPrimary
            : (iconColor ?? colorScheme.primary),
      ),
      label: Text(
        label,
        style: isActive
            ? TextStyle(color: colorScheme.onPrimary)
            : null,
      ),
      onPressed: onTap ?? () {},
      backgroundColor: isActive ? colorScheme.primary : null,
      side: BorderSide(
        color: isActive
            ? colorScheme.primary
            : colorScheme.primary.withValues(alpha: 0.5),
        width: 0.5,
      ),
    );
  }
}
