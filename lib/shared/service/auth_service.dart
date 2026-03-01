import 'package:flutter/foundation.dart';

class AuthService {
  Future<bool> login({
    required String instance,
    required String username,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  Future<void> logout() async {
    throw UnimplementedError();
  }

  Future<bool> register({
    required String instance,
    required String username,
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  Future<String?> getCredentialApplication() async {
    throw UnimplementedError();
  }

  @protected
  Future<void> storeCredentials({
    required String accessToken,
    String? refreshToken,
  }) async {
    throw UnimplementedError();
  }

  @protected
  Future<void> clearCredentials() async {
    throw UnimplementedError();
  }
}
