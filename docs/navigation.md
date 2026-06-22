# Navigation

Planthor uses **GoRouter** (`go_router: ^14.0.0`) for declarative, auth-aware routing.

## Route Map

```
/                  → _SplashScreen        (loading state only — redirect fires immediately)

Auth Stack
  /sign-in         → SignInScreen

Main Stack (ShellRoute wrapping MainScaffold)
  /home            → DiscoveryScreen      tab 0
  /plans           → PlansScreen          tab 1
  /settings        → ProfileScreen        tab 2

Full-screen sub-screens (pushed above the shell via rootNavigator)
  PersonalInformationScreen
  ConnectAppsScreen
```

## Auth Redirect Guard

Defined in `lib/core/router/app_router.dart`. Runs on every navigation event and whenever `authProvider` changes.

| Condition | Redirect |
|-----------|---------|
| `authProvider` is loading | `/` (splash) |
| Not authenticated + not on `/sign-in` | `/sign-in` |
| Authenticated + on `/sign-in` or `/` | `/home` |
| Otherwise | no redirect |

The guard re-evaluates automatically because `appRouterProvider` wraps `authProvider` in a `ChangeNotifier` (`_AuthRefreshNotifier`) and passes it to GoRouter's `refreshListenable`. No manual navigation calls are needed after sign-in or sign-out. The `ref.listen` subscription and the notifier itself are both disposed via `ref.onDispose` when the provider is torn down.

## Main Stack Shell

`ShellRoute` renders `MainScaffold(child: child)` as a persistent wrapper. `MainScaffold` provides:

- `PlanthorAppBar` (top bar)
- `PlanthorBottomNav` (3-tab bottom navigation)
- `widget.child` — the currently routed screen

`MainScaffold` derives the active tab index directly from `GoRouterState.of(context).matchedLocation`, so the bottom nav highlight stays correct after deep-links, Android back-button presses, and any programmatic `context.go(...)` call. Tab taps call `context.go(route)`; no separate index state is maintained.

## Adding a New Tab

1. Add a `GoRoute` inside the `ShellRoute` routes list in `lib/core/router/app_router.dart`
2. Add a `_NavItemData` entry to `PlanthorBottomNav._items` (`lib/core/widgets/planthor_bottom_nav.dart`)
3. Add the route path to `MainScaffold._tabRoutes` (`lib/features/navigation/presentation/main_scaffold.dart`)

## Sub-Screen Navigation (from inside the shell)

Sub-screens pushed from a shell child **must** use the root navigator to cover the full screen (including bottom nav and `MainScaffold`'s app bar).

```dart
// Correct — covers full screen above MainScaffold
Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute<void>(builder: (_) => const PersonalInformationScreen()),
);

// Wrong — pushes inside the shell; MainScaffold app bar stays visible → duplicate header
Navigator.of(context).push(...);
```

Sub-screens that need their own `Scaffold` + `PlanthorAppBar(showBack: true)` work correctly when pushed via `rootNavigator: true`.

## Known Gotchas

### GlobalKey conflict with tab animation

Never render two GoRouter-managed screens in the same widget tree simultaneously (e.g. Stack with old + new child). GoRouter's navigator uses `GlobalKey`s internally — two instances trigger:

```
Multiple widgets used the same GlobalKey
```

Tab transition animations must be applied via GoRouter's `pageBuilder` + `CustomTransitionPage` at the individual route level, not by stacking screen widgets in `MainScaffold`.

### Shell inner navigator vs root navigator

`Navigator.of(context)` inside a `ShellRoute` child resolves to GoRouter's inner shell navigator, not the root. Screens pushed this way appear inside `MainScaffold`'s body area — `MainScaffold`'s `Scaffold.appBar` stays visible. Always use `rootNavigator: true` for full-screen destinations.
