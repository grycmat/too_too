# Too Too — MVP Plan (Play Store Ready)

Audit of current state + gap analysis against baseline Mastodon client expectations (Tusky, Ivory, Elk, Moshidon). Goal: minimum viable, publishable Play Store build.

---

## 1. Current state (what's already shipped)

| Area | Status |
| --- | --- |
| Mastodon OAuth (per-instance, PKCE-less code flow) | ✅ working |
| Session restore via secure storage | ✅ |
| Home / public timelines | ✅ (no pagination) |
| Status details + reply thread (descendants only) | ✅ (no ancestors rendered) |
| Favourite / reblog with optimistic UI | ✅ |
| Compose toot + multi-image (up to 4) upload | ✅ basic |
| Notifications list | ✅ basic |
| Profile view (self + other account) | ✅ basic |
| Settings scaffolding | ⚠️ UI only, most actions no-op |
| Deep link `tootoo://oauth-callback` | ✅ Android manifest wired |
| Theme (cyberpunk dark, two variants) | ✅ |

---

## 2. Missing features — MVP critical

Must-have before a reasonable person would use this as a daily Mastodon client.

### 2.1 Timeline & reading
- [ ] **Pagination / infinite scroll** on home, public, notifications, profile, thread lists. API already supports `max_id`; wire scroll controller → `getUserTimeline(maxId: lastId)`.
- [ ] **Pull-to-refresh prepends new toots** (use `min_id` / `since_id`) instead of replacing list.
- [ ] **Content warning / spoiler collapse** — honor `sensitive` + `spoilerText`; tap to reveal.
- [ ] **Sensitive media blur** with tap-to-reveal.
- [ ] **Multiple media attachments** in card + swipeable viewer (current `firstImageUrl` shows only index 0).
- [ ] **Video / GIFV playback** (`video_player` + `chewie` or `better_player`). Required — many posts are video.
- [ ] **Render ancestors** in status details (currently only descendants).
- [ ] **Link preview cards** (Mastodon `card` field).
- [ ] **Custom emoji** rendering in display names / content (`emojis` field on Account/Status).
- [ ] **Clickable mentions, hashtags, links** inside toot content (currently plain text via `htmlToPlainText`).
- [ ] **Polls** render + vote.

### 2.2 Composing & interacting
- [ ] **Reply** button on toot card + pre-filled compose with `inReplyToId` + mention prefix.
- [ ] **Bookmark** action (field on model, no button; `/statuses/:id/bookmark`).
- [ ] **Content warning input** in compose (chip is placeholder).
- [ ] **Visibility picker** in compose (chip is placeholder) — public / unlisted / followers / direct.
- [ ] **Language picker** in compose (chip is placeholder).
- [ ] **Alt text / media description** on upload (accessibility — Play Store scorecard).
- [ ] **Delete own status** + **edit** (`PUT /statuses/:id`).
- [ ] **Draft save on dismiss** (local, SharedPreferences or sqflite).

### 2.3 Discovery
- [ ] **Search screen** — accounts, hashtags, statuses (`/api/v2/search`). Currently `/explore` just shows federated public timeline.
- [ ] **Hashtag timeline** (`/api/v1/timelines/tag/:tag`) reachable by tapping a tag.
- [ ] **Trending hashtags / posts** on explore.

### 2.4 Social graph
- [ ] **Follow / unfollow** button on profile (`/accounts/:id/follow`).
- [ ] **Followers / following lists**.
- [ ] **Mute / block / report** (Play Store policy requires block + report on any UGC app).
- [ ] **Edit own profile** (display name, bio, avatar, header).

### 2.5 Notifications
- [ ] **Filter by type** (mentions / boosts / favourites / follows / polls).
- [ ] **Tap notification → deep link** to status or profile.
- [ ] **Mark-as-read / dismiss** (`/notifications/clear`, `/dismiss`).

### 2.6 Settings (wire the existing UI)
- [ ] Logout button → `AuthService.logout()` + router redirect.
- [ ] Account section (switch accounts — optional for MVP, single-account fine).
- [ ] Persist theme variant + apply live (currently saved but `MaterialApp` only uses `AppTheme.darkTheme` — not reactive).
- [ ] About / privacy policy / open-source licenses screen.

---

## 3. Release-engineering gaps (Play Store blockers)

- [ ] **App label** in `android/app/src/main/AndroidManifest.xml` is `too_too` → change to `Too Too`.
- [ ] **applicationId** / package name confirmed unique (check `android/app/build.gradle`).
- [ ] **Release signing config** — generate keystore, wire `signingConfigs.release`, keep keystore out of VCS, document in `android/key.properties`.
- [ ] **Minify + shrink** (`minifyEnabled true`, `shrinkResources true`) + ProGuard rules for Dio / reflection libs.
- [ ] **`targetSdk` up to date** for current Play Store policy (API 35 at time of writing).
- [ ] **App bundle build** (`flutter build appbundle`) documented in README.
- [ ] **Privacy policy URL** — required because OAuth + network identity. Needed for Data Safety form.
- [ ] **Data safety declaration** — declare: account data, photos/videos, app activity (in-app interactions). Indicate no third-party sharing.
- [ ] **Content rating** questionnaire — UGC social app → Teen.
- [ ] **Store listing** — title, short/long description, feature graphic (1024×500), ≥2 phone screenshots, app icon (512×512).
- [ ] **Crash reporting** (Sentry or Firebase Crashlytics) — not strictly required, but prevents flying blind post-launch.
- [ ] **iOS Info.plist URL scheme** for `tootoo://` if iOS ship is in scope (CLAUDE.md mentions it — verify).
- [ ] **Clean up `print()` calls** in `new_toot_screen.dart` and elsewhere — replace with `dev.log`.
- [ ] **Version bump** strategy in `pubspec.yaml` + CI.

---

## 4. Code-health gaps (should-fix before scaling feature count)

- [ ] **State management** — every screen is `StatefulWidget` with local `_loading`/`_error`/list. Timeline state is duplicated between home tab and explore tab, and mutations (fav/reblog) in details screen won't reflect in list. Adopt `provider` or `flutter_bloc` for shared timeline / auth / notifications state before the list of features grows.
- [ ] **Error surface is inconsistent** — some screens show error UI, `UserService` swallows everything to `log`, `toot_card_widget._toggleFavourite` fails silently. Define a single `AppError` + snackbar pattern.
- [ ] **No tests** — at minimum widget-test the login flow and a `TootCardWidget` render; unit-test `Status.fromJson` against real Mastodon fixture JSON.
- [ ] **`htmlToPlainText`** strips links/mentions/hashtags — replace with `flutter_html` or a custom `TextSpan` builder that preserves tappable entities (required for 2.1).
- [ ] **Image picker only** — compose supports images but not video. Use `image_picker`'s video source and upload path.
- [ ] **`TootCardWidget` state ignores parent updates** — `initState`-only read of `favourited`. If the same status appears in two tabs, interactions diverge. Move to shared store.

---

## 5. Suggested implementation order

Four ~1-week milestones. Each ends in a testable build.

### Milestone 1 — Core reading experience (blocks everything else)
1. Shared timeline state (`ChangeNotifier` or bloc) for home / public / account.
2. Pagination + proper refresh.
3. Rich content rendering: clickable mentions / hashtags / links, custom emoji.
4. CW + sensitive media blur.
5. Multi-media carousel + video playback.
6. Ancestors in status details.

### Milestone 2 — Interaction parity
1. Reply flow (reuse `NewTootScreen`, accept `inReplyToId`).
2. Bookmark action + bookmarks list screen.
3. CW / visibility / language pickers wired in compose.
4. Alt text on media upload.
5. Delete + edit own status.
6. Draft persistence.

### Milestone 3 — Discovery + social graph
1. Search screen (accounts / tags / statuses tabs).
2. Hashtag timeline route.
3. Follow/unfollow on profile, followers/following lists.
4. Mute / block / report actions (Play Store requirement).
5. Edit profile.
6. Notification filters + tap-to-open + mark-as-read.

### Milestone 4 — Release hardening
1. Wire logout + reactive theme in settings, add About/licenses/privacy links.
2. Rename app label, set release signing, enable R8/ProGuard, bump targetSdk.
3. Add Sentry (or Crashlytics) + scrub `print`s.
4. Privacy policy page (hosted) + Data Safety form + content rating.
5. Store listing assets (icon, feature graphic, screenshots on 6.7" + tablet).
6. Internal testing track → closed testing → production.

---

## 6. Explicitly deferred (post-MVP)

Lists, scheduled posts, multi-account, federated timeline tab, filters/keyword mute, direct message UI polish, announcements, Unified Push / FCM push notifications, tablet-optimized layouts, offline cache, translation integration.

Push notifications in particular are a large chunk of work (Mastodon uses Web Push with per-instance VAPID keys; Android delivery needs either FCM via a relay like [ntfy](https://ntfy.sh) or UnifiedPush) and are not required for a v1.0 listing — ship polling-based notifications first.
