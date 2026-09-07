---
name: flutter-test
description: Select and write Planthor Flutter behavior and regression tests. Use for component, widget, feature, accessibility, golden, or device-testing work and interpreting quality results.
---
# Behavior-focused testing

Read [testing strategy and current commands](../../../docs/testing.md).
For UI work also read [accessibility verification](../../../docs/accessibility.md).

- For future user-visible behavior changes, prefer feature tests exercising real
  screens, providers, repositories, and serialization with controlled external
  boundaries. Introduce needed seams only within the requested implementation scope.
- Keep focused tests for calculations, parsing, repository errors, and meaningful
  state transitions. Do not copy the backend's Domain-only unit-test restriction.
- Use Arrange, Act, Assert and behavior/outcome names. Assert observable results,
  not private helpers or incidental widget tree structure.
- Fix clocks, locale, responses, and platform dependencies where relevant; dispose
  containers/listeners. Prefer condition-based bounded pumps to arbitrary sleeps.
- Existing widget tests that replace providers verify rendering, not a whole
  feature or native/backend integration.
- Run existing tests for folder moves; no new tests are needed to mirror imports.
- Current CI reports line coverage against 70%; it does not enforce an 80% feature
  gate or branch coverage. Do not claim planned automation already exists.
- Never bypass a test or update a golden to conceal an accessibility conflict.
  Report outstanding design and physical-device checks separately.

Source: [Flutter testing](https://docs.flutter.dev/testing/overview), reviewed 2026-09-07.
