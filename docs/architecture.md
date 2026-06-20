# Architecture

Planthor uses **Feature-first Clean Architecture** with Riverpod state management.

## Layer Overview

```
lib/
├── core/                   # Shared across features
│   ├── config/             # AppConfig (env-aware endpoints)
│   ├── layout/             # Responsive layout — AdaptiveLayout, breakpoints, AppSpacing
│   ├── network/            # Dio HTTP client with auth interceptor
│   ├── router/             # GoRouter config — Auth Stack vs Main Stack, redirect guard
│   ├── storage/            # LocalStore interface + SharedPreferences impl
│   ├── theme/              # AppColors, AppTheme
│   ├── services/           # Shared services (Phase 2+)
│   ├── utils/              # Shared utilities (Phase 2+)
│   └── widgets/            # Shared UI components — PlanthorAppBar, PlanthorBottomNav
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
│       ├── bloc/           # FutureProvider declarations (no codegen)
│       ├── screens/        # Full-page ConsumerWidgets
│       └── widgets/        # Feature-scoped UI components (e.g. PlanCard, PlanProgressRing)
│
└── main.dart               # Entry point — ProviderScope + MaterialApp.router
```

## Data Flow

```
UI (ConsumerWidget)
  └─ watches provider
       └─ calls Repository interface (domain)
            └─ delegates to Datasource (data)
                 └─ talks to external system (API / secure storage / OAuth)
```

Dependency direction: `data → domain ← presentation`. The domain layer has zero framework or platform dependencies.

## Network Layer

`lib/core/network/api_client.dart` exposes `apiClientProvider` — a plain `Provider<Dio>` that:

- Sets `AppConfig.apiBase` as the base URL
- Adds an **auth interceptor** that reads the current access token from `authProvider` at request time and injects `Authorization: Bearer <token>` into every outgoing request
- Adds a **log interceptor** that prints `[API]`-prefixed lines to the console (remove before production)

Any feature provider that needs to call the backend watches `apiClientProvider` and calls `dio.get(...)` / `dio.post(...)` etc.

## Riverpod Providers

Two patterns are used — see `docs/state-management.md` for full details.

```
authProvider           (AsyncNotifier<AuthToken?>) — @riverpod class
  └─ AuthRepositoryImpl
       └─ KeycloakAuthDatasource

navigationProvider     (Notifier<int>)             — @riverpod class
  └─ tracks selected bottom nav tab index (0=Home, 1=Plans, 2=Settings)

appThemeProvider       (Notifier<ThemeData>)       — @riverpod class

appRouterProvider      (Provider<GoRouter>)        — plain Provider, no codegen
  └─ reads authProvider for redirect guard
  └─ Auth Stack: /sign-in
  └─ Main Stack (ShellRoute): /home, /plans, /settings

localStoreProvider     (FutureProvider<LocalStore>) — plain FutureProvider
  └─ SharedPreferences-backed key-value store for offline-capable data

stravaConnectionProvider (AutoDisposeNotifier<StravaConnectionStatus>) — @riverpod class
  └─ states: disconnected → connecting → connected
  └─ connect() / disconnect() — OAuth stubbed, TODO: real Strava OAuth

apiClientProvider      (Provider<Dio>)             — plain Provider, no codegen
  └─ reads authProvider for token injection

personalPlansProvider  (FutureProvider<List<PersonalPlan>>) — plain FutureProvider
  └─ watches apiClientProvider
  └─ GET /v1/members/me/PersonalPlans
  └─ NOTE: provider is watched eagerly in MainScaffold to trigger JIT provisioning;
           not yet wired to PlansScreen UI (renders demo data)
```

Generated files (`*.g.dart`) are produced by `build_runner`. Never edit them manually.

## Navigation Flow

Routing is handled by **GoRouter** (`lib/core/router/app_router.dart`). See `docs/navigation.md` for full details.

```
main.dart
  └─ MaterialApp.router (appRouterProvider)
       │
       ├─ /              → _SplashScreen (shown while authProvider is loading)
       │
       ├─ Auth Stack
       │   └─ /sign-in  → SignInScreen
       │
       └─ Main Stack (ShellRoute → MainScaffold shell)
           ├─ /home      → DiscoveryScreen  (tab 0)
           ├─ /plans     → PlansScreen      (tab 1)
           └─ /settings  → ProfileScreen    (tab 2)
                               ├─ rootNavigator push → PersonalInformationScreen
                               └─ rootNavigator push → ConnectAppsScreen
```

GoRouter redirect guard enforces auth: unauthenticated requests redirect to `/sign-in`; authenticated requests on `/sign-in` redirect to `/home`. After sign-in, `authProvider` state change triggers the redirect automatically — no manual `Navigator.push` needed.

Sub-screens pushed from inside the shell use `Navigator.of(context, rootNavigator: true).push(...)` to cover the full screen above `MainScaffold`.

## Feature Status

| Feature | Status | Notes |
|---------|--------|-------|
| `auth` | Complete | Keycloak OAuth, token storage, session restore, ProfileScreen, PersonalInformationScreen |
| `navigation` | Complete | 3-tab bottom nav (`PlanthorBottomNav`), GoRouter ShellRoute, Riverpod tab index |
| `plans` | In Progress | PlansScreen dashboard, PlanCard, PlanProgressRing — demo data only; API wiring pending |
| `connect_apps` | In Progress | ConnectAppsScreen + `StravaConnectionProvider` — UI complete, OAuth stubbed |
| `my_garden` | In Progress | Active Plans fetch from API; create/edit/delete not yet built |
| `plant_discovery` | Stub | Placeholder screen only |

### Mock / Demo Data

The following screens display placeholder values until real API endpoints are wired (next stage):

| Location | Data | Placeholder shown |
|----------|------|-------------------|
| `profile_screen.dart` → `_StatsGrid` | Avg completion, total workouts, current streak | `'—'` |
| `profile_screen.dart` → `_ProfileHeader` | Member join date | Removed (no API field yet) |
| `plans/presentation/plans_screen.dart` | Plan list | 5 hardcoded `PersonalPlan` objects |

## Responsive Layout System

`lib/core/layout/` provides three utilities for Material 3 adaptive layouts:

| File | Purpose |
|------|---------|
| `breakpoints.dart` | `WindowClass` enum (compact < 600, medium < 840, expanded ≥ 840). `BuildContext` extensions: `.windowClass`, `.isCompact`, `.isMedium`, `.isExpanded`, `.useSideNav` |
| `app_spacing.dart` | Token constants (`AppSpacing.xs=4` … `xxl=48`) + context helpers: `.pageMargin()`, `.maxContentWidth()`, `.pagePadding()` |
| `adaptive_layout.dart` | `AdaptiveLayout(compact:, medium:, expanded:)` widget — falls back to compact if medium/expanded not provided |

## Design System / Fonts

- **Plus Jakarta Sans** (headings) and **Inter** (body) via `google_fonts: ^6.2.1`
- Montserrat still used in some legacy widgets; new screens use Plus Jakarta Sans + Inter
- `AppColors` plan palette: `planBlue (#1877F2)`, `planBlueDark (#0058BC)`, `planGreen (#16A34A)`, `planTextDark (#191C1E)`, `planTextSub (#414754)`, `planChip (#ECEEF0)`
- Plan status tokens: `planOverdue`, `planUpcoming`, `planActiveLight`, `planGreenLight`
- Integration token: `stravaOrange (#FC4C02)`

## Adding a New Feature

1. Create `lib/features/<name>/` following the structure above
2. Define domain entity with `fromJson` factory first
3. Create a `FutureProvider` in `bloc/` that watches `apiClientProvider`
4. Build the screen as a `ConsumerWidget` using `plansAsync.when(loading:, error:, data:)`
5. If you need mutable state or actions, use a `@riverpod` class instead and run `build_runner`
6. Add a GoRoute inside the `ShellRoute` in `lib/core/router/app_router.dart` and a tab entry in `PlanthorBottomNav._items` + `MainScaffold._tabRoutes`
7. Add a widget test in `test/`
