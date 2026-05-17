# Planthor Project Instructions

This project is a Flutter application named **Planthor**, targeting both iOS and Android.

## Tech Stack
- **Framework:** Flutter
- **Language:** Dart
- **State Management:** Riverpod (using `riverpod_generator` for type safety)
- **Architecture:** Feature-first Clean Architecture
- **Tooling:** `build_runner` for code generation

## Coding Standards
- Follow official Flutter/Dart lint rules (as defined in `analysis_options.yaml`).
- Use descriptive variable and function names.
- Prefer composition over inheritance.
- Ensure all new widgets have basic widget tests.

## Gemini CLI Workflow
- **Research:** Always check `pubspec.yaml` before suggesting new dependencies.
- **Strategy:** Propose architectural changes before implementing.
- **Execution:** 
  - Run `flutter pub get` after dependency changes.
  - Run `dart run build_runner build --delete-conflicting-outputs` when modifying providers or models.
  - Run `flutter analyze` after code changes to ensure type safety.
