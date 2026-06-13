# Architecture

Planthor uses **Feature-first Clean Architecture** with Riverpod state management.

## Layer Overview

```
lib/
├── core/                   # Shared across features
│   ├── config/             # AppConfig (env-aware endpoints)
│   ├── layout/             # Responsive layout — AdaptiveLayout, breakpoints, AppSpacing
│   ├── network/            # Dio HTTP client with auth interceptor
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
└── main.dart               # Entry point — ProviderScope + auth-aware routing
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
  └─ tracks selected bottom nav index

appThemeProvider       (Notifier<ThemeData>)       — @riverpod class

stravaConnectionProvider (AutoDisposeNotifier<StravaConnectionStatus>) — @riverpod class
  └─ states: disconnected → connecting → connected
  └─ connect() / disconnect() — OAuth stubbed, TODO: real Strava OAuth

apiClientProvider      (Provider<Dio>)             — plain Provider, no codegen
  └─ reads authProvider for token injection

personalPlansProvider  (FutureProvider<List<PersonalPlan>>) — plain FutureProvider
  └─ watches apiClientProvider
  └─ GET /v1/members/me/PersonalPlans
  └─ NOTE: GardenScreen currently renders mock data; provider is watched eagerly
           in MainScaffold to trigger JIT provisioning but not yet wired to UI
```

Generated files (`*.g.dart`) are produced by `build_runner`. Never edit them manually.

## Navigation Flow

```
main.dart (watches authProvider)
  ├─ AsyncLoading  → CircularProgressIndicator
  ├─ AsyncError    → SignInScreen
  ├─ null token    → SignInScreen
  └─ token present → MainScaffold (PlanthorBottomNav — 4 tabs)
                        ├─ index 0 → DiscoveryScreen (Home)
                        ├─ index 1 → PlansScreen
                        ├─ index 2 → CommunityScreen (stub)
                        └─ index 3 → ProfileScreen
                                        ├─ push → PersonalInformationScreen
                                        └─ push → ConnectAppsScreen
```

After login via `SignInScreen`, a `ref.listen` on `authProvider` triggers `Navigator.pushReplacement` to `MainScaffold(showWelcome: true)` which shows a "Login successful!" snackbar.

## Feature Status

| Feature | Status | Notes |
|---------|--------|-------|
| `auth` | Complete | Keycloak OAuth, token storage, session restore, ProfileScreen, PersonalInformationScreen |
| `navigation` | Complete | Four-tab bottom nav (`PlanthorBottomNav`) with Riverpod state |
| `plans` | In Progress | PlansScreen dashboard, PlanCard, PlanProgressRing — demo data only; API wiring pending |
| `connect_apps` | In Progress | ConnectAppsScreen + `StravaConnectionProvider` — UI complete, OAuth stubbed |
| `my_garden` | In Progress | Active Plans fetch from API; create/edit/delete not yet built |
| `plant_discovery` | Stub | Placeholder screen only |

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
6. Add the screen to `MainScaffold` bottom nav items
7. Add a widget test in `test/`
