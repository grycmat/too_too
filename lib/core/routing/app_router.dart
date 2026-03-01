import 'package:go_router/go_router.dart';
import 'package:too_too/features/dashboard/dashboard_screen.dart';
import 'package:too_too/features/dashboard/widgets/toots_list_widget.dart';
import 'package:too_too/features/dashboard/models/toot.dart';
import 'package:too_too/features/notifications/notifications_screen.dart';
import 'package:too_too/features/explore/explore_screen.dart';
import 'package:too_too/features/profile/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return DashboardScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) =>
                  TootsListWidget(toots: Toot.mockToots()),
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
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
