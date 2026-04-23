# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter Mastodon client ("Neon") using Material 3 with a custom cyberpunk/neon-glow dark theme. Flutter SDK `^3.10.7`.

## Commands

```bash
flutter pub get        # install deps
flutter run            # run app
flutter analyze        # static analysis (uses analysis_options.yaml → flutter_lints)
flutter test                          # run all tests
flutter test test/widget_test.dart    # run a single test file
```

## Architecture

### Dependency injection (`lib/core/di/service_locator.dart`)
All services are registered as singletons in `get_it` via `setupServiceLocator()`, which is awaited in `main()` **before** `runApp`. `SharedPreferences`, `FlutterSecureStorage`, `AppHttpService`, `OAuthCallbackHandler`, and `AuthService` all come from `getIt<T>()`. When adding a new service, register it here and have it consume other services via constructor injection (see `AuthService`).

### Routing (`lib/core/routing/app_router.dart`)
`go_router` with a global `redirect` guard that reads `getIt<AuthService>().isLoggedIn` — unauthenticated users are pushed to `/login`, authenticated users on `/login` are pushed to `/`. The authenticated area uses `StatefulShellRoute.indexedStack` with four branches (`/`, `/notifications`, `/explore`, `/profile`); `DashboardScreen` receives the `navigationShell` and renders the bottom nav. Adding a new tab = add a `StatefulShellBranch` and update `AppBottomNavWidget`.

### Auth flow (Mastodon OAuth)
`AuthService` + `AppHttpService` + `OAuthCallbackHandler` cooperate:
1. `login(instanceUrl)` strips protocol/slashes, calls `_registerApp` which either reuses cached `client_id`/`client_secret` from secure storage or POSTs `/api/v1/apps` to register.
2. Opens the Mastodon `/oauth/authorize` URL in the external browser via `url_launcher`.
3. `OAuthCallbackHandler` listens for the `neon://oauth-callback?code=...` deep link via `app_links` and emits the code on a broadcast stream.
4. `AuthService` exchanges the code at `/oauth/token`, stores the access token in `FlutterSecureStorage`, and configures `AppHttpService` (base URL + `Authorization: Bearer` header).
5. On app start, `tryRestoreSession()` reads stored creds and hits `/api/v1/accounts/verify_credentials` to validate; on failure it clears creds.

`AppHttpService` is a thin `Dio` wrapper — base URL and auth token are mutable (`setBaseUrl`, `setAuthToken`, `clearAuthToken`) because they change at login/logout time. Do not create new `Dio` instances; reuse this service.

The custom URL scheme `neon://oauth-callback` must be registered in the native Android/iOS configs for the callback to work.

### Feature structure
Code is organized as `lib/features/<feature>/` with `<feature>_screen.dart`, optional `models/`, and `widgets/`. There are three cross-feature homes:
- `lib/core/widgets/` — reusable styled primitives (`GlowWrapper`, `AppTextField`, `NeonCardWidget`, `AvatarWidget`).
- `lib/core/theme/` — design tokens (`AppColors`, `AppTheme.darkTheme`); use these rather than hard-coding colors to keep the neon-glow aesthetic consistent.
- `lib/shared/service/` and `lib/shared/widgets/` — app-wide services (`AuthService`, `AppHttpService`, `TootsApiService`, `UserService`, `UserSettingsService`, `OAuthCallbackHandler`) and generic widgets (`AppButton`, `LinkButton`). New services go here and are wired up in `lib/core/di/service_locator.dart`.
