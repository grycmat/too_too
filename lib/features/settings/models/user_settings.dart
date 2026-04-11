enum AppThemeVariant { neonNoir, plasmaPink }

enum AccountPrivacy { publicAccount, followersOnly, private }

class UserSettings {
  final AccountPrivacy accountPrivacy;
  final bool twoFactorAuthEnabled;
  final bool pushNotificationsEnabled;
  final bool mentionsAndRepliesEnabled;
  final AppThemeVariant themeVariant;
  final int brightness;

  const UserSettings({
    required this.accountPrivacy,
    required this.twoFactorAuthEnabled,
    required this.pushNotificationsEnabled,
    required this.mentionsAndRepliesEnabled,
    required this.themeVariant,
    required this.brightness,
  });

  const UserSettings.defaults()
      : accountPrivacy = AccountPrivacy.publicAccount,
        twoFactorAuthEnabled = true,
        pushNotificationsEnabled = true,
        mentionsAndRepliesEnabled = false,
        themeVariant = AppThemeVariant.neonNoir,
        brightness = 85;

  UserSettings copyWith({
    AccountPrivacy? accountPrivacy,
    bool? twoFactorAuthEnabled,
    bool? pushNotificationsEnabled,
    bool? mentionsAndRepliesEnabled,
    AppThemeVariant? themeVariant,
    int? brightness,
  }) {
    return UserSettings(
      accountPrivacy: accountPrivacy ?? this.accountPrivacy,
      twoFactorAuthEnabled: twoFactorAuthEnabled ?? this.twoFactorAuthEnabled,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      mentionsAndRepliesEnabled:
          mentionsAndRepliesEnabled ?? this.mentionsAndRepliesEnabled,
      themeVariant: themeVariant ?? this.themeVariant,
      brightness: brightness ?? this.brightness,
    );
  }

  Map<String, dynamic> toJson() => {
        'accountPrivacy': accountPrivacy.name,
        'twoFactorAuthEnabled': twoFactorAuthEnabled,
        'pushNotificationsEnabled': pushNotificationsEnabled,
        'mentionsAndRepliesEnabled': mentionsAndRepliesEnabled,
        'themeVariant': themeVariant.name,
        'brightness': brightness,
      };

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      accountPrivacy: AccountPrivacy.values.firstWhere(
        (v) => v.name == json['accountPrivacy'],
        orElse: () => AccountPrivacy.publicAccount,
      ),
      twoFactorAuthEnabled: json['twoFactorAuthEnabled'] as bool? ?? true,
      pushNotificationsEnabled:
          json['pushNotificationsEnabled'] as bool? ?? true,
      mentionsAndRepliesEnabled:
          json['mentionsAndRepliesEnabled'] as bool? ?? false,
      themeVariant: AppThemeVariant.values.firstWhere(
        (v) => v.name == json['themeVariant'],
        orElse: () => AppThemeVariant.neonNoir,
      ),
      brightness: (json['brightness'] as num?)?.toInt() ?? 85,
    );
  }
}
