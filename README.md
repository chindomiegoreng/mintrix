# Mintrix

<p align="center">
  <img src="https://res.cloudinary.com/dy4hqxkv1/image/upload/v1781148005/Container_1_d1jvmj.png" alt="Mintrix Thumbnail" width="100%" />
</p>

A Flutter-based mobile learning platform that combines gamified education with practical career tools — featuring interactive course modules, quizzes, a CV builder, AI-powered chat assistant, daily notes, leaderboard, and a store system.

## Tech Stack

- **Framework:** Flutter (Dart SDK ^3.8.1)
- **State Management:** BLoC / Cubit (`flutter_bloc`)
- **HTTP Client:** `http` package with custom `ApiClient` wrapper
- **Auth:** Firebase Auth + Google Sign-In + custom backend JWT
- **Storage:** `shared_preferences`, Hive
- **Video:** `youtube_player_flutter`, `chewie`
- **Charts:** `fl_chart`, `radar_chart`
- **DI:** Constructor-based injection (services instantiated in `main.dart`)

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.8.1
- Android Studio / Xcode (for emulators)
- A Firebase project configured for this app

### Setup

```bash
# Clone the repository
git clone <repo-url>
cd mintrix

# Install dependencies
flutter pub get

# Run code generation (Hive, etc.)
flutter pub run build_runner build

# Launch the app
flutter run
```

### Useful Commands

| Command | Description |
|---|---|
| `flutter pub get` | Install dependencies |
| `flutter run` | Run the app on a connected device/emulator |
| `flutter build apk` | Build Android APK |
| `flutter build ios` | Build iOS app |
| `flutter analyze` | Static analysis / linting |
| `flutter test` | Run tests |
| `flutter pub run build_runner build` | Generate Hive type adapters |
| `flutter pub run build_runner watch` | Watch mode for code generation |
| `flutter pub outdated` | Check for outdated dependencies |

## Architecture

```
lib/
├── core/                  # Shared infrastructure
│   ├── api/               # ApiClient & ApiEndpoints
│   ├── models/            # Data models (DTOs)
│   ├── services/          # Token storage, streak tracking
│   └── utils/             # Debug helpers, image downloader
├── features/              # Feature modules (vertical slices)
│   ├── ai/                # Dino AI chat
│   ├── auth/              # Login, register, Google Sign-In
│   ├── daily_notes/       # Personal notes CRUD
│   ├── game/              # Modules, lessons, quiz, video, CV builder
│   ├── home/              # Dashboard & daily missions
│   ├── leaderboard/       # Rankings
│   ├── main/              # Bottom navigation shell
│   ├── navigation/        # Tab index state
│   ├── personalization/   # Multi-step onboarding wizard
│   ├── profile/           # User profile, settings, download CV
│   ├── splash/            # Splash & get-started pages
│   └── store/             # In-app store
├── shared/                # Theme constants (colors, text styles)
├── widgets/               # Reusable UI components
└── main.dart              # App entry point, route table, BLoC providers
```

### Key Patterns

- **BLoC (Event → Bloc → State):** Auth, Profile, Personalization, Daily Notes, BuildCV all follow a `bloc/` folder with `*_bloc.dart`, `*_event.dart`, `*_state.dart` (sometimes `part` files).
- **Cubit (lighter):** Leaderboard and Navigation use the simpler Cubit pattern.
- **ApiClient:** Centralized HTTP wrapper (`core/api/api_client.dart`) handling token injection, multipart uploads, error mapping, and two backend base URLs (`mintrixBaseUrl` for main API, `dinoBaseUrl` for AI).
- **Route-based navigation:** Named routes defined in `MyApp.build()` in `main.dart` using `MaterialApp.routes`.
- **Token lifecycle:** Stored via `TokenStorageService` → `SharedPreferences`. On app start, `SplashPage` dispatches `CheckTokenEvent` to restore session or redirect to auth.
- **Services** (`data/services/`) encapsulate API calls for each domain (e.g., `CVService`, `GoogleSignInService`).

### Backend Endpoints

| Base URL | Purpose |
|---|---|
| `https://mintrix.yogawanadityapratama.com` | Core API (auth, modules, profile, notes, CV, leaderboard) |
| `https://dino.yogawanadityapratama.com` | AI Chat (Dino) |

## Team

| Role | GitHub |
|---|---|
| Backend Dev & Mobile Assist | [yogawan](https://github.com/yogawan) |
| Mobile Dev Integration & Slicing | [rstsfyn](https://github.com/rstsfyn) |
| Lead & Mobile Dev Slicing | [rafiikkodev](https://github.com/rafiikkodev) |
