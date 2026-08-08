---
name: testing-guide
description: >-
  Use this skill when writing tests for the Planthor app. Covers unit testing,
  Riverpod provider testing, widget testing, and layout constraints.
---

# Planthor Testing Guide

## 1. Unit Tests
- Placed in `test/unit/`.
- Use `group` to organize behaviors and descriptive `test` names.
- For provider testing, wrap the system under test with a `ProviderContainer(overrides: [...])` and dispose after the test.

## 2. Widget Tests
- Placed in `test/widget/`.
- Use `testWidgets` and wrap UI components inside a `ProviderScope` containing necessary overrides.
- Use `test/helpers/fakes.dart` to simulate authenticated or unauthenticated states.

### Widget Sizing (Figma Constraints)
All widget tests for screens MUST enforce the 390px iPhone layout as a constraint baseline:
```dart
tester.view.physicalSize = const Size(390, 844);
tester.view.devicePixelRatio = 1.0;
addTearDown(() {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
});
```

## 3. Coverage
- Execute tests locally using: `flutter test --no-pub --coverage`
- CI runs `scripts/ci/check_coverage.sh` enforcing >70% line coverage. Validate new code coverage before pushing.
