# Flutter testing: current setup and adoption strategy

## What exists now

The repository uses `flutter_test` for unit/provider/router and widget tests.
Plans tests are grouped in `test/unit/features/plans` and
`test/widget/features/plans`; other tests keep their current locations.

```sh
flutter pub get
flutter test
./scripts/ci/quality_checks.sh
```

The quality script checks formatting, runs fatal-warning/info static analysis,
then existing tests with LCOV coverage. CI currently reports a **70% line-coverage
candidate threshold**, without enforcing it. SonarQube has its existing separate
quality gate. See [CI/CD](ci-cd.md).

The existing macOS CI job compiles an unsigned dev iOS application:

```sh
flutter build ios --flavor dev --debug --no-codesign --no-pub
```

Compilation does not prove simulator journeys, native OAuth, or accessibility.
This first adoption step adds no tests, dependencies, CI jobs, coverage gates,
font assets, or behavioral implementation.

## Recommended next steps, when separately implemented

Favor behavior confidence, inspired by the backend honeycomb, adapted to Flutter.
No percentage allocation between test types is required.

| Layer | Purpose | Proposed location |
| --- | --- | --- |
| Unit/component | Calculations, parsing, repository failures, meaningful state transitions | `test/unit/features/<feature>/` |
| Widget | Rendering and user interactions in controlled screen states | `test/widget/features/<feature>/` |
| Feature | Real UI/providers/repositories/serialization together, with controlled HTTP/platform boundaries | `test/feature/<feature>/` |
| Golden | Selected visual regression comparisons | `test/golden/<feature>/` |
| Accessibility | Semantics, contrast, touch targets, text scaling, focus | With the relevant widget/feature tests |
| Simulator | Compiled app, routing, and feature wiring | `integration_test/` |
| Native/device | OAuth sheets, callbacks, storage, permissions, lifecycle, profiling | Dedicated future native/device suite |

A feature test runs through Flutter's widget framework. Keep real feature
providers/repositories; fake the HTTP/platform edge. Existing tests overriding
providers are useful rendering tests but do not establish full feature correctness.
Focused tests remain useful outside domain code; do not copy the backend's
Domain-only unit restriction.

For future behavior changes, cover loading/empty/data/error, malformed responses,
retry, invalid input without a request, mutation success and refresh, cancellation,
duplicate-submission protection, and input preservation after failure. Test auth
token injection, retry once, and terminal refresh failure at the network boundary.

Use Arrange/Act/Assert, descriptive behavior names, fresh disposed scopes, fixed
clocks/timezones, and deterministic responses. Fail unexpected HTTP calls. Prefer
bounded condition-based pumping to arbitrary delays. Do not write tests that only
mirror file moves or private implementation details.

## Visual and accessibility testing guidance

Apply [accessibility guidance](accessibility.md). Future tests should combine
Flutter guideline checks (`iOSTapTargetGuideline`, `labeledTapTargetGuideline`,
`textContrastGuideline`) with semantic and actual color-pair assertions.
Check 320/390 logical-pixel widths, supported landscape, 1x/2x text scaling,
keyboard/focus restoration, and reduced motion. Manual iPhone checks cover
VoiceOver, largest accessibility text, and Switch Control.

Goldens require a fixed Linux/Flutter version, viewport, locale, pixel ratio, and
repository-owned fonts before establishing baselines. None are added in this step.
Review visual diffs; never regenerate baselines to hide an unresolved defect.
Automated checks alone do not establish app-wide WCAG conformance.

## Simulator, native and performance roadmap

Start future simulator automation with SDK `integration_test`: unauthenticated
routing and a plan create/edit/delete journey with controlled boundaries.
Label fake-service runs clearly. Use Patrol when native browser/permission UI
automation is needed; `integration_test` cannot operate those native surfaces.

Before release or relevant native changes, use isolated accounts/environments to
check sign-in/cancel/failure, callbacks, expired-token handling, session restoration,
sign-out/storage clearing, Strava disconnect, and background/resume. Test only
permissions the app actually uses. Record device/OS, build, environment, and result.

Profile startup/scrolling on a physical iPhone in profile/release mode; establish
a comparable-device baseline before setting budgets. Simulator timing is not
release performance evidence. Add XCTest for meaningful custom Swift logic, not
for Flutter business logic or template tests.

An eventual first coverage gate can target 80% handwritten line coverage for a
migrated feature, detecting missing records and excluding generated files only.
That is a future decision/implementation; no new line or branch gate is active here.

Sources reviewed 2026-09-07:
[Flutter testing](https://docs.flutter.dev/testing/overview),
[architecture testing](https://docs.flutter.dev/app-architecture/recommendations#testing),
[accessibility testing](https://docs.flutter.dev/ui/accessibility/accessibility-testing).
