import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:neon/features/settings/models/user_settings.dart';

class UserSettingsService {
  static const String _storageKey = 'user_settings';

  final SharedPreferences _prefs;
  UserSettings _cache = const UserSettings.defaults();

  UserSettingsService({required SharedPreferences prefs}) : _prefs = prefs;

  UserSettings get settings => _cache;

  Future<void> load() async {
    final raw = _prefs.getString(_storageKey);
    if (raw == null) {
      _cache = const UserSettings.defaults();
      return;
    }
    try {
      _cache =
          UserSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      log('Failed to decode user settings, falling back to defaults: $e');
      _cache = const UserSettings.defaults();
    }
  }

  Future<void> update(UserSettings settings) async {
    _cache = settings;
    await _prefs.setString(_storageKey, jsonEncode(settings.toJson()));
  }

  Future<void> setAccountPrivacy(AccountPrivacy value) =>
      update(_cache.copyWith(accountPrivacy: value));

  Future<void> setTwoFactorAuthEnabled(bool value) =>
      update(_cache.copyWith(twoFactorAuthEnabled: value));

  Future<void> setPushNotificationsEnabled(bool value) =>
      update(_cache.copyWith(pushNotificationsEnabled: value));

  Future<void> setMentionsAndRepliesEnabled(bool value) =>
      update(_cache.copyWith(mentionsAndRepliesEnabled: value));

  Future<void> setThemeVariant(AppThemeVariant value) =>
      update(_cache.copyWith(themeVariant: value));

  Future<void> setBrightness(int value) =>
      update(_cache.copyWith(brightness: value.clamp(0, 100)));
}
