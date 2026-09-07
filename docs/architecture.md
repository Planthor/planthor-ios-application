# Flutter architecture and folder conventions

Planthor targets feature-first Clean Architecture with Riverpod 2, Dio, and GoRouter.
This adoption step normalizes the **plans folders and existing test placement only**.
It does not change business behavior, data contracts, state management, or visuals.

## Application layout

```text
lib/
├── main.dart
├── core/                       # Existing config, router, network, storage, layout, theme, widgets
└── features/<feature>/
    ├── domain/
    │   ├── entities/
    │   └── repositories/       # When the feature defines domain contracts
    ├── data/
    │   ├── repositories/
    │   ├── datasources/        # When a separate I/O boundary is useful
    │   └── models/             # When wire/domain models need separation
    └── presentation/
        ├── providers/          # Both plain and generated Riverpod providers
        ├── screens/
        └── widgets/
```

Create folders when they contain actual work; Git does not need placeholders for
every possible layer. Add use cases only for substantial or reused orchestration.

The `plans` feature now places its three query providers in
`presentation/providers`, its three screens in `presentation/screens`, and its
existing concrete repository in `data/repositories`. Entities and widgets remain
in their existing folders. Imports are updated without changing implementations.

Other features keep their current layouts until a task requires migration:
`auth` already has domain contracts/data sources; `connect_apps` has providers
at feature level; navigation has provider/screen files directly in presentation.
The legacy `plant_discovery` name represents a Home placeholder, not a product domain.

## Target boundaries for future code

```text
screen → presentation provider → domain repository contract
                                     ↑
                              data implementation → HTTP/platform
```

Data depends on domain. Screens render state and dispatch actions; providers
coordinate state using contracts. Composition providers construct implementations.
Domain code uses plain Dart; presentation owns icons, colors, and formatted text.
Data owns transport serialization. Do not add pass-through classes just to fill layers.

## Current exceptions: not part of this folder change

- Plans query providers call the shared Dio client directly and parse responses.
- `PlanRepository` is a concrete mutation repository accepting maps.
- Plans screens still coordinate mutation requests and invalidation.
- `PersonalPlan` combines data with Flutter icons and display formatting.
- Auth constructs its repository internally; the API client depends on auth state.
- Some other features use historical folder conventions.

These are explicit future refactoring candidates, not claims that current code
already enforces the target dependency graph. Preserve them in organizational tasks.
A functional migration needs its own scope and behavior tests.

## Existing behavior

Auth restores sessions through Keycloak; the router separates authentication from
the Home/Plans/Settings shell. Plans list/create/edit/details/delete and activity
presentation are implemented. Connection management uses the backend BFF.
Retain current endpoint paths, payloads, response compatibility, and error behavior.

Generated `*.g.dart` files stay with their annotated source files. Regenerate only
when source annotations/providers change. Do not hand-edit generated output.

## Test layout

```text
test/
├── helpers/                    # Existing shared fakes
├── unit/
│   ├── features/plans/         # Existing model/parser tests
│   └── *_test.dart             # Other existing tests; migrate when touched
├── widget/
│   ├── features/plans/         # Existing screens/cards/dialog/progress tests
│   └── *_test.dart             # Existing shared/other-feature tests
└── widget_test.dart            # Existing app smoke test
```

For new tests use `test/<type>/features/<feature>/`; shared component tests use
`test/<type>/core/`. Mirror relevant source subfolders when it aids navigation.
Future `test/feature/`, `test/golden/`, and `integration_test/` directories are
created when those suites are implemented. See [testing](testing.md).

Source: [Flutter architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations),
reviewed 2026-09-07. Flutter's guidance is adapted to the existing stack; use-case
layers are conditional rather than mandatory.
