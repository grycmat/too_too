import 'package:flutter/material.dart';
import 'package:neon/core/di/service_locator.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/features/settings/models/user_settings.dart';
import 'package:neon/shared/service/user_service.dart';
import 'package:neon/shared/service/user_settings_service.dart';

import 'widgets/settings_brightness_slider.dart';
import 'widgets/settings_danger_button.dart';
import 'widgets/settings_profile_header.dart';
import 'widgets/settings_section_header.dart';
import 'widgets/settings_theme_option.dart';
import 'widgets/settings_toggle_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserSettingsService _settingsService = getIt<UserSettingsService>();
  final UserService _userService = getIt<UserService>();

  late UserSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = _settingsService.settings;
  }

  Future<void> _apply(UserSettings next) async {
    setState(() => _settings = next);
    await _settingsService.update(next);
  }

  @override
  Widget build(BuildContext context) {
    final account = _userService.currentAccount;
    final displayName = (account?.displayName.isNotEmpty ?? false)
        ? account!.displayName
        : (account?.username ?? 'UNKNOWN');
    final handle = account != null ? '@${account.acct}' : '';
    final avatar = account?.avatar ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('SETTINGS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingsProfileHeader(
              displayName: displayName,
              handle: handle,
              avatarUrl: avatar,
              versionLabel: 'MASTODON',
              onEdit: () {},
            ),
            const SettingsSectionHeader(label: 'SYSTEM // ACCOUNT'),
            const SettingsSectionHeader(label: 'SIGNAL // NOTIFICATIONS'),
            SettingsToggleTile(
              icon: Icons.notifications_outlined,
              title: 'PUSH NOTIFICATIONS',
              value: _settings.pushNotificationsEnabled,
              onChanged: (v) =>
                  _apply(_settings.copyWith(pushNotificationsEnabled: v)),
            ),
            SettingsToggleTile(
              icon: Icons.alternate_email,
              title: 'MENTIONS & REPLIES',
              value: _settings.mentionsAndRepliesEnabled,
              onChanged: (v) =>
                  _apply(_settings.copyWith(mentionsAndRepliesEnabled: v)),
            ),
            const SettingsSectionHeader(label: 'INTERFACE // APPEARANCE'),
            SettingsThemeOption(
              icon: Icons.dark_mode_outlined,
              title: 'NEON NOIR',
              description: 'Deep obsidian with cyan highlights',
              selected: _settings.themeVariant == AppThemeVariant.neonNoir,
              onTap: () => _apply(
                _settings.copyWith(themeVariant: AppThemeVariant.neonNoir),
              ),
            ),
            SettingsThemeOption(
              icon: Icons.blur_on,
              title: 'PLASMA PINK',
              description: 'Synthetic magenta pulse theme',
              selected: _settings.themeVariant == AppThemeVariant.plasmaPink,
              onTap: () => _apply(
                _settings.copyWith(themeVariant: AppThemeVariant.plasmaPink),
              ),
            ),
            SettingsBrightnessSlider(
              value: _settings.brightness,
              onChanged: (v) => _apply(_settings.copyWith(brightness: v)),
            ),
            const SettingsSectionHeader(
              label: 'CRITICAL // DANGER ZONE',
              color: AppColors.error,
            ),
            SettingsDangerButton(
              icon: Icons.logout,
              label: 'LOGOUT',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
