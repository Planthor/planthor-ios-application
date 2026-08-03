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

## Design Implementation Rules

`design.md` is the implementation contract for the Figma design. Treat its
node references, semantic tokens, typography, geometry, component contracts,
runtime states, and delivery order as authoritative for product UI work. When
the Figma file and existing code differ, preserve behavior and migrate the
implementation toward `design.md` rather than introducing another visual
variant.

- Use the 390 px compact layout as the reference. Keep the 24 px page margin,
  75 px shared app bar, 90 px bottom navigation, 56 px controls, 24 px card
  radius/padding, and other geometry tokens from `design.md`; adapt medium and
  expanded layouts through the existing breakpoints instead of stretching the
  mobile composition.
- Add or update semantic values in `AppColors`, `AppSpacing`, and the shared
  theme before using them in product screens. Do not add direct hex values or
  one-off typography in a screen. Use Montserrat for product UI and retain
  Inter only where the sign-in design explicitly requires it.
- Reuse `PlanthorAppBar`, `PlanthorBottomNav`, `PlanCard`, and
  `PlanProgressRing`. Extend shared widgets or theme definitions when a visual
  pattern is repeated; do not duplicate inline versions in feature screens.
- Keep feature code in the existing `lib/features/<feature>/` boundaries and
  use Riverpod for explicit loading, data, empty, error, and retry states.
  Use `personalPlansProvider` for active-plan data and support both legacy list
  and cursor-paginated payloads while the backend is in transition.
- Use GoRouter for product navigation. Preserve accessible tap targets and
  semantic labels, especially for plan cards, profile/avatar controls, status
  badges, navigation items, and destructive actions.
- Prefer approved repository-owned assets in `assets/images/`; use
  `flutter_svg` for SVG assets. Treat temporary Figma export URLs as
  non-durable and use Material icons only when their shape matches the source.
- Add a widget test for each new screen, targeted unit/provider tests for
  behavior, and golden tests for stable Figma-critical screens at 390 px when
  visual fidelity is part of the change. Run accessibility checks for the
  compact reference flows.
- Follow the delivery order in `design.md`: normalize tokens and typography,
  align shared navigation, finish Active Plans states, then build remaining
  flows and coverage. Never edit generated `*.g.dart` files manually.

## Testing Guidelines

Use `flutter_test`. Name test files `<subject>_test.dart`, organize assertions with `group`, and use descriptive `test`/`testWidgets` names. Add a widget test for each new screen and targeted unit tests for domain, provider, storage, or utility behavior. Wrap Riverpod widgets in `ProviderScope` and use `test/helpers/fakes.dart` for overrides when useful. Run analysis and the relevant tests before submitting changes.

## Commit & Pull Request Guidelines

Recent history uses short conventional prefixes: `feat:`, `fix:`, `docs:`, `test:`, `refactor:`, and `chore:`. Write imperative, focused subjects, for example `feat: add plant list screen`. Keep commits scoped to one coherent change.
flutter run --dart-define=ENV=dev include screenshots for UI changes, and note any provider generation, configuration, or platform impact. Confirm `flutter analyze` and relevant tests pass before requesting review.
