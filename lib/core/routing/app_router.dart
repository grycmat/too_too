import 'package:go_router/go_router.dart';
import 'package:too_too/core/di/service_locator.dart';
import 'package:too_too/features/dashboard/dashboard_screen.dart';
import 'package:too_too/features/dashboard/widgets/toots_list_widget.dart';
import 'package:too_too/features/explore/explore_screen.dart';
import 'package:too_too/features/login/login_screen.dart';
import 'package:too_too/features/notifications/notifications_screen.dart';
import 'package:too_too/features/profile/profile_screen.dart';
import 'package:too_too/features/settings/settings_screen.dart';
import 'package:too_too/features/status_details/status_details_screen.dart';
import 'package:too_too/shared/service/auth_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final authService = getIt<AuthService>();
    final isLoggedIn = authService.isLoggedIn;
    final isOnLogin = state.matchedLocation == '/login';

    if (!isLoggedIn && !isOnLogin) return '/login';
    if (isLoggedIn && isOnLogin) return '/';

    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      name: '/settings',
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return DashboardScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const TootsListWidget(),
              routes: [
                GoRoute(
                  path: 'status/:id',
                  builder: (context, state) => StatusDetailsScreen(
                    statusId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const NotificationsScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/explore',
              builder: (context, state) => const ExploreScreen(),
              routes: [
                GoRoute(
                  path: 'status/:id',
                  builder: (context, state) => StatusDetailsScreen(
                    statusId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'status/:id',
                  builder: (context, state) => StatusDetailsScreen(
                    statusId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
