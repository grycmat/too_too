import 'dart:developer';
import 'package:too_too/features/profile/models/profile.dart';
import 'package:too_too/features/dashboard/models/status.dart';
import 'package:too_too/shared/service/app_http_service.dart';

class UserService {
  final AppHttpService _http;

  Profile? _currentProfile;
  Profile? get currentProfile => _currentProfile;

  Account? _currentAccount;
  Account? get currentAccount => _currentAccount;

  UserService({required AppHttpService httpService}) : _http = httpService;

  Future<Profile?> getCurrentUserProfile() async {
    try {
      final response = await _http.get<Map<String, dynamic>>('/api/v1/profile');
      if (response.data != null) {
        _currentProfile = Profile.fromJson(response.data!);
        return _currentProfile;
      }
    } catch (e) {
      log('Error fetching current user profile: $e');
    }
    return null;
  }

  Future<Account?> getCurrentAccount() async {
    try {
      final response = await _http.get<Map<String, dynamic>>('/api/v1/accounts/verify_credentials');
      if (response.data != null) {
        _currentAccount = Account.fromJson(response.data!);
        return _currentAccount;
      }
    } catch (e) {
      log('Error fetching current user account: $e');
    }
    return null;
  }

  Future<Account?> getAccount(String id) async {
    try {
      final response = await _http.get<Map<String, dynamic>>('/api/v1/accounts/$id');
      if (response.data != null) {
        return Account.fromJson(response.data!);
      }
    } catch (e) {
      log('Error fetching account $id: $e');
    }
    return null;
  }
}
