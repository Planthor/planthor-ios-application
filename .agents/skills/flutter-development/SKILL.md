---
name: flutter-development
description: >-
  Use this skill when developing or extending Flutter features in the Planthor project.
  It details the feature-first clean architecture, state management (Riverpod), and routing (GoRouter) standards.
---

# Planthor Flutter Development Workflow

## 1. Feature Organization
All application features reside in `lib/features/<feature>/`. Each feature must be organized into:
- `data/`: Contains `datasources/` (API integration), `repositories/` (implementation), and `models/` (data transfer objects).
- `domain/`: Contains `entities/` (business objects) and `repositories/` (interfaces).
- `presentation/`: Contains UI `screens/` or `pages/`, `widgets/` (feature-specific UI components), and `providers/` (state management).

## 2. State Management (Riverpod)
- Always use `@riverpod` annotations and rely on `build_runner` for provider generation (`.g.dart`).
- Use `AsyncNotifier` (for complex async state) or `FutureProvider` (for simple async fetches).
- For async operations, wrap API calls in `AsyncValue.guard()`.

Example:
```dart
@riverpod
class MyFeatureNotifier extends _$MyFeatureNotifier {
  @override
  FutureOr<MyData> build() async {
    return ref.watch(myFeatureRepositoryProvider).getData();
  }
}
```

## 3. UI and Theming
- Do not hardcode colors or spacing. Use `AppColors` and `AppSpacing` from `lib/core/theme/`.
- Maintain compact canvas size (390px) as the default layout reference.
- Add descriptive keys (e.g., `Key('my-feature-loading')`) to support widget testing.

## 4. Run Build Runner
Whenever you modify providers, generate code:
`dart run build_runner build --delete-conflicting-outputs`
