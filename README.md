# Neon

Flutter Mastodon client with a neon-glow dark theme.
## Screenshots

The UI features a neon-glow dark theme with cyan accents, glowing card borders, and a feed-style dashboard.

## Project Structure

```
lib/
├── main.dart                             # App entry point
├── core/
│   └── theme/
│       ├── colors.dart                   # AppColors — cyberpunk color palette
│       └── theme.dart                    # AppTheme — full Material dark theme
└── features/
    └── dashboard/
        ├── dashboard_screen.dart         # Main feed screen
        ├── models/
        │   └── toot.dart                 # Toot data model
        └── widgets/
            ├── app_top_bar_widget.dart   # "FEED" title + profile avatar
            ├── app_bottom_nav_widget.dart # 4-tab bottom navigation
            ├── toots_list_widget.dart    # Scrollable feed list
            ├── toot_card_widget.dart     # Card with glow border
            ├── author_widget.dart        # Avatar, name, handle, timestamp
            ├── toot_content_widget.dart  # Body text + hashtag highlighting + image
            └── toot_actions_widget.dart  # Reply, repost, star, share actions
```

## Getting Started

### Prerequisites

- Flutter SDK `^3.10.7`

### Run

```bash
flutter pub get
flutter run
```

### Analyze

```bash
flutter analyze
```

## Tech Stack

- **Flutter** — cross-platform UI
- **Material 3** — design system with custom dark theme
- **Dart** — language
