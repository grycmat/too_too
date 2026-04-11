import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';
import 'settings_tile_container.dart';

class SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTileContainer(
      onTap: () => onChanged(!value),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.background,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.textHint,
            inactiveTrackColor: AppColors.surface,
            trackOutlineColor:
                WidgetStateProperty.all(AppColors.border),
          ),
        ],
      ),
    );
  }
}
