import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_http_service.dart';
import 'oauth_callback_handler.dart';

class AuthService {
  static const _redirectUri = 'tootoo://oauth-callback';
  static const _scopes = 'read write push';
  static const _clientName = 'TooToo';

  static const _keyAccessToken = 'access_token';
  static const _keyClientId = 'client_id';
  static const _keyClientSecret = 'client_secret';
  static const _keyInstanceUrl = 'instance_url';

  final FlutterSecureStorage _secureStorage;
  final AppHttpService _httpService;
  final OAuthCallbackHandler _callbackHandler;

  String? _accessToken;
  String? _instanceUrl;

  bool get isLoggedIn => _accessToken != null && _instanceUrl != null;
  String? get instanceUrl => _instanceUrl;

  AuthService({
    required FlutterSecureStorage secureStorage,
    required AppHttpService httpService,
    required OAuthCallbackHandler callbackHandler,
  }) : _secureStorage = secureStorage,
       _httpService = httpService,
       _callbackHandler = callbackHandler;

  Future<bool> tryRestoreSession() async {
    final token = await _secureStorage.read(key: _keyAccessToken);
    final instance = await _secureStorage.read(key: _keyInstanceUrl);

    if (token == null || instance == null) return false;

    _accessToken = token;
    _instanceUrl = instance;
    _httpService.setBaseUrl(instance);
    _httpService.setAuthToken(token);

    try {
      await _httpService.get('/api/v1/accounts/verify_credentials');
      return true;
    } catch (_) {
      await _clearCredentials();
      return false;
    }
  }

  Future<Map<String, String>> _registerApp(String instanceUrl) async {
    final existingClientId = await _secureStorage.read(key: _keyClientId);
    final existingSecret = await _secureStorage.read(key: _keyClientSecret);
    final existingInstance = await _secureStorage.read(key: _keyInstanceUrl);

    if (existingClientId != null &&
        existingSecret != null &&
        existingInstance == instanceUrl) {
      return {'client_id': existingClientId, 'client_secret': existingSecret};
    }

    _httpService.setBaseUrl(instanceUrl);

    final response = await _httpService.post(
      '/api/v1/apps',
      data: {
        'client_name': _clientName,
        'redirect_uris': _redirectUri,
        'scopes': _scopes,
      },
    );

    final clientId = response.data['client_id'] as String;
    final clientSecret = response.data['client_secret'] as String;

    await _secureStorage.write(key: _keyClientId, value: clientId);
    await _secureStorage.write(key: _keyClientSecret, value: clientSecret);
    await _secureStorage.write(key: _keyInstanceUrl, value: instanceUrl);

    return {'client_id': clientId, 'client_secret': clientSecret};
  }

  Uri buildAuthorizationUrl(String instanceUrl, String clientId) {
    return Uri.https(instanceUrl, '/oauth/authorize', {
      'client_id': clientId,
      'redirect_uri': _redirectUri,
      'response_type': 'code',
      'scope': _scopes,
    });
  }

  Future<String> login(String instanceUrl) async {
    final cleanInstance = instanceUrl
        .replaceAll('https://', '')
        .replaceAll('http://', '')
        .replaceAll('/', '')
        .trim();

    final appCredentials = await _registerApp(cleanInstance);
    final clientId = appCredentials['client_id']!;
    final clientSecret = appCredentials['client_secret']!;

    final authUrl = buildAuthorizationUrl(cleanInstance, clientId);

    _callbackHandler.startListening();

    final launched = await launchUrl(
      authUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      _callbackHandler.stopListening();
      throw Exception('Could not open browser for authorization');
    }

    final authCode = await _callbackHandler.onAuthCode.first.timeout(
      const Duration(minutes: 5),
      onTimeout: () {
        _callbackHandler.stopListening();
        throw TimeoutException('Authorization timed out');
      },
    );

    _callbackHandler.stopListening();

    final tokenResponse = await _httpService.post(
      '/oauth/token',
      data: {
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'client_secret': clientSecret,
        'redirect_uri': _redirectUri,
        'code': authCode,
        'scope': _scopes,
      },
    );

    final accessToken = tokenResponse.data['access_token'] as String;

    await _storeCredentials(
      accessToken: accessToken,
      instanceUrl: cleanInstance,
    );

    _httpService.setBaseUrl(cleanInstance);
    _httpService.setAuthToken(accessToken);

    await _httpService.get('/api/v1/accounts/verify_credentials');

    return accessToken;
  }

  Future<void> logout() async {
    try {
      final clientId = await _secureStorage.read(key: _keyClientId);
      final clientSecret = await _secureStorage.read(key: _keyClientSecret);

      if (clientId != null && clientSecret != null && _accessToken != null) {
        await _httpService.post(
          '/oauth/revoke',
          data: {
            'client_id': clientId,
            'client_secret': clientSecret,
            'token': _accessToken,
          },
        );
      }
    } catch (_) {}

    _httpService.clearAuthToken();
    await _clearCredentials();
  }

  Future<void> _storeCredentials({
    required String accessToken,
    required String instanceUrl,
  }) async {
    _accessToken = accessToken;
    _instanceUrl = instanceUrl;
    await _secureStorage.write(key: _keyAccessToken, value: accessToken);
    await _secureStorage.write(key: _keyInstanceUrl, value: instanceUrl);
  }

  Future<void> _clearCredentials() async {
    _accessToken = null;
    _instanceUrl = null;
    await _secureStorage.delete(key: _keyAccessToken);
    await _secureStorage.delete(key: _keyClientId);
    await _secureStorage.delete(key: _keyClientSecret);
    await _secureStorage.delete(key: _keyInstanceUrl);
  }
}
