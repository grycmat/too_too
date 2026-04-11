import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';

class SettingsThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const SettingsThemeOption({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.primary : AppColors.border;
    final glowShadow = selected
        ? [
            BoxShadow(
              color: AppColors.primaryGlow.withValues(alpha: 0.35),
              blurRadius: 18,
              spreadRadius: 0,
            ),
          ]
        : <BoxShadow>[];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.9),
        boxShadow: glowShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ThemeIconBadge(icon: icon, selected: selected),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description.toUpperCase(),
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textHint,
                                  letterSpacing: 1,
                                ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeIconBadge extends StatelessWidget {
  final IconData icon;
  final bool selected;

  const _ThemeIconBadge({required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: 0.9,
        ),
      ),
      child: Icon(
        icon,
        color: selected ? AppColors.primary : AppColors.textSecondary,
        size: 22,
      ),
    );
  }
}
