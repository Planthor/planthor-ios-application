# Planthor Flutter Application

> From plan to performance.

Planthor is a Flutter application for athletes to create measurable fitness plans,
track progress from activities, and connect external fitness services such as Strava.

> Product requirements, roadmaps, system architecture, and ADRs are maintained in the
> canonical [Planthor Wiki](https://github.com/Planthor/planthor-documentation/wiki).
> This README is authoritative for Flutter setup and repository structure.

## Current capabilities

| Capability | Status |
| --- | --- |
| Keycloak authentication and session restoration | Implemented |
| Auth-aware navigation and responsive shell | Implemented |
| Personal-plan list, create, edit, details, and delete flows | Implemented |
| Plan activity ledger and progress presentation | Implemented |
| Profile, personal information, and account deletion | Implemented |
| Strava connection and disconnection through the backend BFF | Implemented |
| Home activity experience and community features | Placeholder / planned |

The legacy `plant_discovery` folder currently contains the temporary Home placeholder;
it is not a Planthor product domain or roadmap feature.

## Technology

| Area | Choice |
| --- | --- |
| Framework | Flutter 3.44.1 |
| Language | Dart 3.11.5 or newer |
| State | Riverpod 2 with generated notifiers where actions are required |
| Navigation | GoRouter |
| HTTP | Dio |
| Architecture | Feature-first Clean Architecture |

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run --dart-define=ENV=dev
```

Use `ENV=prod` only when intentionally targeting production. Local authenticated
flows require the companion backend and Keycloak configuration described in
[Environment setup](docs/environment-setup.md).

## Repository structure

```text
lib/
├── main.dart
├── core/
│   ├── config/       # environment-aware endpoints
│   ├── layout/       # spacing, breakpoints, adaptive layout
│   ├── network/      # shared authenticated Dio client
│   ├── router/       # auth-aware GoRouter configuration
│   ├── storage/      # local token and preference storage
│   ├── theme/        # semantic colors and typography
│   └── widgets/      # shared navigation and app chrome
└── features/
    ├── auth/         # sign-in, profile, member information
    ├── connect_apps/ # Strava connection state and UI
    ├── navigation/   # application shell
    ├── plans/        # personal plans and activity progress
    ├── community/    # planned community placeholder
    └── plant_discovery/ # legacy Home placeholder pending rename

test/
├── helpers/
├── unit/
└── widget/
```

Do not edit generated `*.g.dart` files. Regenerate them after changing annotated
Riverpod providers or generated models.

## Documentation ownership

- Read [Onboarding](docs/ONBOARDING.md) for the implementation mental model.
- Read [Architecture](docs/architecture.md), [API](docs/api.md),
  [Authentication](docs/authentication.md), and [State management](docs/state-management.md)
  for repository-local implementation details.
- Treat [DESIGN.md](DESIGN.md) and linked Figma nodes as the visual implementation contract.
- Use the [Wiki](https://github.com/Planthor/planthor-documentation/wiki) for accepted
  product behavior, user stories, architecture decisions, and roadmap priorities.

## Quality workflow

```bash
./scripts/ci/quality_checks.sh
```

The command checks formatting, runs static analysis and tests with coverage, and
reports the configured coverage threshold. See [CI/CD](docs/ci-cd.md) and
[Contributing](CONTRIBUTING.md) before opening a pull request.
