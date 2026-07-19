# Repository Guidelines

## Project Structure & Module Organization

Planthor is a Flutter application for iOS and Android. Application code is in `lib/`: shared concerns belong in `lib/core/` (configuration, layout, networking, storage, theme, utilities, and reusable widgets), while product work lives in `lib/features/<feature>/`. Keep feature layers separated into `presentation/`, `domain/`, `data/`, and provider/state folders where applicable. Platform runners are in `ios/` and `android/`; images are in `assets/images/`; technical documentation is in `docs/`.

Tests mirror behavior under `test/unit/` and `test/widget/`; shared test doubles go in `test/helpers/`. Do not edit generated `*.g.dart` files.

## Build, Test, and Development Commands

```bash
flutter pub get                                      # install dependencies
dart run build_runner build --delete-conflicting-outputs # regenerate providers
flutter analyze                                      # run Flutter and Dart lints
flutter test                                         # run all unit and widget tests
flutter test test/widget/sign_in_screen_test.dart    # run one test file
flutter run --dart-define=ENV=dev                    # run against local services
```

Use `ENV=prod` only when intentionally targeting production endpoints. Local development expects Keycloak and the API via Docker Compose; see `docs/environment-setup.md`.

## Coding Style & Naming Conventions

Follow `analysis_options.yaml` (`flutter_lints`) and standard Dart formatting: run `dart format` on changed Dart files. Use `snake_case.dart` filenames, `PascalCase` types/widgets, and `camelCase` members. Favor small composed widgets, `const` constructors where appropriate, explicit async error states, and the existing Riverpod and GoRouter patterns. Extend `lib/core/theme/` and shared widgets rather than duplicating inline styles.

For annotated Riverpod code or files with `part '*.g.dart'`, regenerate code with `build_runner`; never hand-edit generated output.

## Testing Guidelines

Use `flutter_test`. Name test files `<subject>_test.dart`, organize assertions with `group`, and use descriptive `test`/`testWidgets` names. Add a widget test for each new screen and targeted unit tests for domain, provider, storage, or utility behavior. Wrap Riverpod widgets in `ProviderScope` and use `test/helpers/fakes.dart` for overrides when useful. Run analysis and the relevant tests before submitting changes.

## Commit & Pull Request Guidelines

Recent history uses short conventional prefixes: `feat:`, `fix:`, `docs:`, `test:`, `refactor:`, and `chore:`. Write imperative, focused subjects, for example `feat: add plant list screen`. Keep commits scoped to one coherent change.

PRs should explain the user-visible change, link the related issue when available, include screenshots for UI changes, and note any provider generation, configuration, or platform impact. Confirm `flutter analyze` and relevant tests pass before requesting review.
