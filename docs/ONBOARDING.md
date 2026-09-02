# Planthor Flutter Onboarding

This guide is for developers who know general software development but are new to Flutter and Planthor. It explains how this application is assembled, where changes belong, and how to work safely with its state, navigation, and backend integration.

## 1. Run the Project

Install Flutter **3.44.1**, Xcode 15+ for iOS, Android Studio/SDK for Android, and CocoaPods 1.16.2+ for iOS dependencies. Then run:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run --dart-define=ENV=dev
```

`ENV` controls endpoints in `lib/core/config/app_config.dart`:

- `dev` is default. It uses local Keycloak at `http://localhost:8180` and the API at `http://localhost:5008`.
- `prod` uses production Keycloak and `https://api.planthor.space`.

For a custom local HTTPS endpoint, install a certificate trusted by the simulator or device. The app does not bypass TLS certificate validation.

For an Android emulator or physical device, replace localhost with a reachable host:

```bash
flutter run --dart-define=ENV=dev --dart-define=API_HOST=10.0.2.2
```

This repository does not contain the backend. Start its companion API before testing authenticated API calls. For prerequisites and platform troubleshooting, see [Environment Setup](environment-setup.md).

## 2. Mental Model: Flutter in This Repository

Flutter renders a tree of **widgets**. A widget's `build` method receives a `BuildContext` and returns UI; it can run repeatedly, so do not keep mutable work in `build`. Use a `StatefulWidget` only for UI state that changes over time (for example, a text controller or selected option); prefer `const` widgets for static UI.

Planthor uses **Riverpod** for app state. A `ConsumerWidget` or `ConsumerStatefulWidget` receives a `WidgetRef` and reacts to state with `ref.watch(provider)`. `watch` rebuilds UI when state changes; `read` performs one-off actions, such as `ref.read(authProvider.notifier).signOut()`. Async providers expose `AsyncValue`, which can be loading, data, or error—handle all applicable states in product UI.

`BuildContext` also gives access to navigation and inherited UI configuration. Use `context.go('/plans')` for GoRouter route changes. Avoid using a context after an `await` unless the widget is still mounted.

## 3. Code Map

```
lib/
├── main.dart                  # Creates ProviderScope and MaterialApp.router
├── core/
│   ├── config/                # Environment-aware endpoint configuration
│   ├── layout/                # Breakpoints, spacing tokens, adaptive layouts
│   ├── network/               # Dio API client and auth refresh interceptor
│   ├── router/                # GoRouter routes and authentication redirect guard
│   ├── storage/               # SharedPreferences LocalStore
│   ├── theme/                 # AppColors and Riverpod theme provider
│   ├── utils/                 # Shared helpers, including JWT decoding
│   └── widgets/               # Shared app bar and bottom navigation
├── features/
│   └── <feature>/             # Feature-first domain, data, presentation code

test/
├── unit/                      # Entities, providers, storage, and utilities
├── widget/                    # Rendered widget and screen behavior
└── helpers/fakes.dart          # Riverpod overrides and fake auth tokens
```

Feature folders may contain:

- `domain/`: entities and repository contracts. Keep this layer independent of Flutter, Dio, and storage where possible.
- `data/`: API, OAuth, secure-storage data sources and repository implementations.
- `presentation/`: screens, reusable feature widgets, and Riverpod providers.
- `bloc/`: existing plain `FutureProvider` declarations; retain this convention where it is already used.

Platform integration lives in `ios/` and `android/`. Application images belong in `assets/images/` and must be registered in `pubspec.yaml`.

## 4. Startup, State, and Navigation

`main.dart` wraps `MyApp` in `ProviderScope`, enabling every Riverpod provider. `MyApp` watches the theme and router providers, then builds `MaterialApp.router`.

```mermaid
flowchart TD
  A[main.dart] --> B[ProviderScope]
  B --> C[MyApp ConsumerWidget]
  C --> D[appThemeProvider]
  C --> E[appRouterProvider]
  E --> F{authProvider state}
  F -->|loading| G[/ splash]
  F -->|unauthenticated| H[/sign-in]
  F -->|authenticated| I[ShellRoute]
  I --> J[/home Discovery]
  I --> K[/plans Plans]
  I --> L[/settings Profile]
```

`appRouterProvider` listens for `authProvider` updates. Its redirect guard keeps unauthenticated users on `/sign-in` and directs authenticated users to `/home`. The shell route keeps `MainScaffold` and its bottom navigation around the three main tabs. Detail screens, such as Personal Information and Connect Apps, are pushed with the root navigator so they appear above the shell.

## 5. Authentication and API Requests

The authentication path is:

1. `Auth` (`authProvider`) restores a secure-stored token or refreshes it.
2. `signIn()` calls `AuthRepositoryImpl`, which uses `KeycloakAuthDatasource` and `flutter_appauth`.
3. After sign-in, the app creates or finds the member record, then stores its ID.
4. GoRouter observes the new auth state and moves the user to `/home`.

`apiClientProvider` constructs a shared Dio client. It adds the bearer token at request time, refreshes once after a 401 response, retries that request, and logs API activity with `[API]`. New backend calls should watch `apiClientProvider`, not create a separate Dio client.

`personalPlansProvider` currently requests `GET /v1/members/me/PersonalPlans`, but `PlansScreen` still renders hard-coded demonstration plans. Treat API wiring for that screen as unfinished work; do not assume displayed plans came from the server.

## 6. Project Conventions

### Riverpod and Code Generation

Use an `@riverpod` notifier when a feature owns state and actions. Add a `part '<file>.g.dart';` declaration, then regenerate generated code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Never edit `*.g.dart` files. Use plain `Provider` or `FutureProvider` for simple derived values and one-shot reads, following existing provider patterns. Read [State Management](state-management.md) before introducing a new provider type.

### Design and Layout

Reuse `AppColors`, `appThemeProvider`, `AppSpacing`, `AdaptiveLayout`, shared widgets, and existing Google Font choices. New UI should normally use Plus Jakarta Sans for headings and Inter for body copy. Keep feature-specific widgets next to their screen; promote only broadly reused widgets to `lib/core/widgets/`.

### Dependencies

Inspect `pubspec.yaml` before adding a package. Prefer Flutter/Dart SDK features and packages already in use. After changing dependencies, run `flutter pub get`; commit the resulting `pubspec.lock` update for this application.

## 7. Common Change Recipes

### Add a screen and route

1. Add a screen under `lib/features/<feature>/presentation/`.
2. Reuse the theme and shared layout components.
3. Register a `GoRoute` in `lib/core/router/app_router.dart`; place main-tab pages in the shell and detail pages above it when appropriate.
4. Add a widget test under `test/widget/`.

### Add state or an API call

1. Put entity/contract changes in `domain/`; implementation and HTTP mapping in `data/`.
2. Expose state from a provider in the feature's presentation layer.
3. Use `ref.watch` in UI to render loading, error, empty, and data states.
4. Add unit tests and override providers in widget tests using `test/helpers/fakes.dart`.

### Add an asset

1. Place it under `assets/images/`.
2. Ensure `assets/images/` remains listed in `pubspec.yaml`.
3. Reference it with `Image.asset('assets/images/<file>')`.

## 8. Testing and Debugging

Run focused checks while developing:

```bash
dart format lib/features/<feature> test/<type>/<file>_test.dart
flutter analyze
flutter test test/widget/<file>_test.dart
flutter test
```

Use `test` for pure Dart behavior and provider logic; use `testWidgets` to pump UI, locate widgets, interact, and assert visible behavior. Wrap Riverpod UI in `ProviderScope` and override external dependencies, so tests do not call Keycloak or the backend.

When debugging:

- **Provider stuck loading:** confirm the provider is watched, its future completes, and UI handles `AsyncValue` states.
- **Widget overflow or missed tap:** inspect constraints; use `Expanded`/`Flexible` correctly and scroll the target into view in widget tests.
- **Missing generated provider:** run `build_runner`; do not patch `*.g.dart` output.
- **OAuth redirect fails on iOS simulator:** test custom URL-scheme flows on a physical device when possible.
- **CocoaPods fails:** ensure CocoaPods 1.16.2+ is first on `PATH`; see [Environment Setup](environment-setup.md).
- **API returns 401:** inspect `[API]` logs, token storage, and refresh behavior; retry logic runs once before surfacing the failure.
- **CI test failure:** reproduce with the exact test path, then run `flutter test` and `flutter analyze --no-fatal-infos`.

## 9. First Contribution Checklist

- Read [Architecture](architecture.md), [Navigation](navigation.md), [State Management](state-management.md), [API](api.md), and [Authentication](authentication.md) for deeper topic guides.
- Read [Contributing](../CONTRIBUTING.md) before opening a pull request.
- Keep changes inside the correct feature or core boundary.
- Regenerate code after annotated-provider changes.
- Run formatter, analysis, and relevant tests.
- Describe user-visible behavior, configuration changes, and screenshots for UI work in the pull request.

The roadmap and current feature status are maintained in [TODO.md](../TODO.md).
