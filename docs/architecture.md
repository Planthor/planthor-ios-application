# Architecture

Planthor uses **Feature-first Clean Architecture** with Riverpod state management.

## Layer Overview

```
lib/
├── core/                   # Shared across features
│   ├── config/             # AppConfig (env-aware endpoints)
│   ├── theme/              # AppColors, AppTheme, AppTypography
│   ├── services/           # Shared services (Phase 2+)
│   ├── utils/              # Shared utilities (Phase 2+)
│   └── widgets/            # Shared UI components (Phase 2+)
│
├── features/<name>/        # One directory per feature
│   ├── domain/
│   │   ├── entities/       # Immutable value objects (no framework deps)
│   │   └── repositories/   # Abstract interfaces (contracts)
│   ├── data/
│   │   ├── datasources/    # Remote/local data sources (API, secure storage)
│   │   └── repositories/   # Concrete implementations of domain interfaces
│   └── presentation/
│       ├── providers/      # Riverpod notifiers (@riverpod annotated)
│       ├── screens/        # Full-page ConsumerWidgets
│       └── widgets/        # Feature-scoped UI components
│
└── main.dart               # Entry point — ProviderScope + auth-aware routing
```

## Data Flow

```
UI (ConsumerWidget)
  └─ watches provider (AsyncNotifier)
       └─ calls Repository interface (domain)
            └─ delegates to Datasource (data)
                 └─ talks to external system (API / secure storage / OAuth)
```

Dependency direction is always inward: `data → domain ← presentation`. The domain layer has zero framework or platform dependencies.

## Riverpod Providers

All providers use `@riverpod` annotation + code generation. Never declare providers manually.

```
authProvider (AsyncNotifier<AuthToken?>)
  └─ AuthRepositoryImpl
       └─ KeycloakAuthDatasource

navigationProvider (Notifier<int>)
  └─ tracks selected bottom nav index

appThemeProvider (Notifier<ThemeData>)
  └─ wraps AppTheme
```

Generated files (`*.g.dart`) are produced by `build_runner` and must not be edited manually.

## Navigation Flow

```
main.dart
  └─ authProvider state
       ├─ loading     → CircularProgressIndicator
       ├─ null token  → SignInScreen
       └─ token       → MainScaffold
                           ├─ index 0 → DiscoveryScreen
                           └─ index 1 → GardenScreen
```

## Adding a New Feature

1. Create `lib/features/<name>/` following the structure above
2. Define domain entities and repository interface first
3. Implement datasource and repository in data layer
4. Create Riverpod notifier with `@riverpod` in presentation/providers/
5. Run `dart run build_runner build --delete-conflicting-outputs`
6. Build screen as `ConsumerWidget` watching the provider
7. Add widget test in `test/`
