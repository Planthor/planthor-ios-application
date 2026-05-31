# Contributing to Planthor

## Development Environment

**Required:**
- Flutter SDK (Dart ≥ 3.11.5) — install via [flutter.dev](https://flutter.dev/docs/get-started/install)
- Xcode ≥ 15 (iOS development)
- Android Studio with Android SDK (Android development)

**Recommended VS Code extensions:**
- [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
- [Riverpod Snippets](https://marketplace.visualstudio.com/items?itemName=robert-brunhage.flutter-riverpod-snippets)

## Branching

| Branch | Purpose |
|--------|---------|
| `main` | Stable, deployable code |
| `feature/<name>` | New feature work (e.g. `feature/plant-discovery-ui`) |
| `fix/<name>` | Bug fixes (e.g. `fix/sign-in-layout`) |

## Code Generation

This project uses `build_runner` to generate Riverpod provider boilerplate. Run it after modifying any file annotated with `@riverpod` or any code-generated model:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Do **not** manually edit `*.g.dart` files — they are auto-generated and will be overwritten.

## Coding Standards

Linting is enforced via [`analysis_options.yaml`](analysis_options.yaml). Key rules:

- Follow official Flutter/Dart lint rules (`flutter_lints`, `riverpod_lint`)
- Use descriptive variable and function names
- Prefer composition over inheritance
- Every new widget screen must have a corresponding widget test in `test/`

## Adding a New Feature

Follow the Feature-First Clean Architecture pattern. Use the `flutter-feature-gen` AI skill when available.

Manual scaffold:

```
lib/features/<feature_name>/
├── presentation/
│   ├── screens/            # Full-page widgets
│   └── widgets/            # Feature-specific UI components
├── bloc/                   # Riverpod providers / state notifiers
└── domain/                 # Entities and use-case logic (Phase 2+)
```

Steps:

1. Create the folder structure above under `lib/features/`
2. Add Riverpod provider(s) using the `@riverpod` annotation
3. Run `dart run build_runner build --delete-conflicting-outputs`
4. Wire the screen into the navigation scaffold or router
5. Add widget tests for each new screen

## Pull Request Checklist

Before opening a PR, confirm:

- [ ] `flutter pub get` has been run
- [ ] `dart run build_runner build --delete-conflicting-outputs` has been run (if providers or models were modified)
- [ ] `flutter analyze` passes with zero errors or warnings
- [ ] New screens have a corresponding widget test in `test/`
- [ ] `pubspec.yaml` was checked before adding any new dependency

## PR Title Conventions

Use a conventional commit prefix:

| Prefix | Use for |
|--------|---------|
| `feat:` | New feature or capability |
| `fix:` | Bug fix |
| `docs:` | Documentation only |
| `refactor:` | Code restructure with no behavior change |
| `test:` | Adding or updating tests |
| `chore:` | Build process, tooling, or dependency updates |

Example: `feat: add plant list screen to discovery feature`
