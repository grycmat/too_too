import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'core/theme/theme.dart';
import 'core/routing/app_router.dart';
import 'shared/service/auth_service.dart';
import 'shared/service/user_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  final isLogged = await getIt<AuthService>().tryRestoreSession();
  if (isLogged) {
    await getIt<UserService>().getCurrentUserProfile();
  }
  runApp(const TooTooApp());
}

class TooTooApp extends StatelessWidget {
  const TooTooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Too Too',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
