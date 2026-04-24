# Planthor iOS Application

Flutter mobile application targeting iOS and Android. Dart SDK ^3.11.4, Material Design.

## Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run the app
flutter build ios        # Build for iOS
flutter build apk        # Build for Android
flutter test             # Run all tests
flutter test test/widget_test.dart  # Run a single test file
flutter analyze          # Static analysis
dart format .            # Format code
```

## Architecture

- Entry point: `lib/main.dart` — single-file app using `MaterialApp` with a `StatefulWidget` home page.
- State management: `StatefulWidget` + `setState`. No state management library is currently used.
- Linting: `package:flutter_lints/flutter.yaml` (configured in `analysis_options.yaml`).
- The package is private (`publish_to: 'none'`).

## Conventions

- Follow the lint rules from `flutter_lints`. Run `flutter analyze` before committing.
- Use `dart format .` to maintain consistent formatting.
- Widget tests go in `test/` and mirror the source structure.
