# Adapt App for Foldable Devices

This plan outlines the steps and suggestions to modify the current `neon` Mastodon client to better support foldable devices and larger screens. Currently, the app relies heavily on a mobile-first design, specifically utilizing a `BottomNavigationBar` and full-screen pushed routes.

## User Review Required

> [!IMPORTANT]
> Adapting for foldable devices can be done in two main ways: 
> 1. **Simple Breakpoints:** We can use `LayoutBuilder` to change the layout (e.g. from bottom nav to side nav) when the screen gets wider.
> 2. **Hinge Awareness:** We can integrate a package like `dual_screen` to detect physical hinges and explicitly split content across screens.
> Please let me know which approach you prefer, or if you want me to start with simple breakpoints.

## Open Questions

- Do you want a **Master-Detail** layout for the status details? (i.e. clicking a post on a wide screen opens it on the right side of the screen rather than pushing a new full screen).
- Should the `Compose` screen appear as a dialog/popup on larger screens instead of a full-screen route?

## Proposed Changes

If we proceed with the standard responsive approach (Breakpoints & Master-Detail), the following components will be updated:

### 1. Responsive Navigation (Dashboard)

Switching between `BottomNavigationBar` and `NavigationRail` depending on the available screen width.

#### [MODIFY] `lib/features/dashboard/dashboard_screen.dart`
- Wrap the main scaffold body in a `LayoutBuilder`.
- If `maxWidth < 600`, show the current `AppBottomNavWidget` and `AppTopBarWidget`.
- If `maxWidth >= 600` (foldable unfolded state), hide the bottom nav and show a `NavigationRail` on the left side of the screen.

#### [NEW] `lib/features/dashboard/widgets/app_nav_rail_widget.dart`
- Create a new widget `AppNavRailWidget` containing the identical 4 destinations (Home, Notifications, Explore, Profile) but formatted vertically.

### 2. Master-Detail Split Screen for Status Details

When opening a specific post (status details) on a wide screen, the app shouldn't hide the feed.

#### [MODIFY] `lib/core/routing/app_router.dart`
- Use an adaptive layout approach for the `StatusDetailsScreen`. 
- Instead of using a standard `GoRoute` that pushes on top, we might use a custom Shell route or state parameters to show the details alongside the list in the same screen when the width is large enough.

#### [MODIFY] `lib/features/dashboard/widgets/toots_list_widget.dart`
- Modify the feed to check the screen width. If it's a wide screen, tapping a status updates a selected state, which renders the `StatusDetailsScreen` on the right side of a `Row`.

### 3. Adaptive Compose Screen

#### [MODIFY] `lib/features/dashboard/dashboard_screen.dart`
- The `FloatingActionButton` behavior will change based on screen size. On foldable/wide screens, it might open a `Dialog` with the `ComposeScreen` instead of using `context.push('/compose')`, allowing the user to keep the context of their feed.

## Verification Plan

### Automated Tests
- Use Flutter's `tester.binding.window.physicalSizeTestValue` to simulate different screen sizes (e.g., standard phone size vs. unfolded tablet size).

### Manual Verification
- Run the application on an Android Foldable Emulator or resize the desktop/web window.
- Verify the navigation smoothly transitions between bottom bar and side rail.
- Verify the Master-Detail view shows side-by-side correctly without overlapping or layout overflow errors.
