import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neon/shared/service/app_http_service.dart';
import 'package:neon/shared/service/auth_service.dart';
import 'package:neon/shared/service/instance_service.dart';
import 'package:neon/shared/service/oauth_callback_handler.dart';
import 'package:neon/shared/service/toots_api_service.dart';
import 'package:neon/shared/service/user_service.dart';
import 'package:neon/shared/service/user_settings_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  getIt.registerSingleton<AppHttpService>(AppHttpService());

  getIt.registerSingleton<OAuthCallbackHandler>(OAuthCallbackHandler());

  getIt.registerSingleton<AuthService>(
    AuthService(
      secureStorage: getIt<FlutterSecureStorage>(),
      httpService: getIt<AppHttpService>(),
      callbackHandler: getIt<OAuthCallbackHandler>(),
    ),
  );

  getIt.registerSingleton<TootsApiService>(
    TootsApiService(httpService: getIt<AppHttpService>()),
  );

  getIt.registerSingleton<UserService>(
    UserService(httpService: getIt<AppHttpService>()),
  );

  getIt.registerSingleton<InstanceService>(
    InstanceService(httpService: getIt<AppHttpService>()),
  );

  getIt.registerSingleton<UserSettingsService>(
    UserSettingsService(prefs: getIt<SharedPreferences>()),
  );
}
