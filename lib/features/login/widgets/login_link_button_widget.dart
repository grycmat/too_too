import 'package:flutter/material.dart';

class LoginLinkButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const LoginLinkButtonWidget({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
