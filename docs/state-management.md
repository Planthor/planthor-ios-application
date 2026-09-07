# State management

Planthor uses Riverpod **2**, with plain providers for read-only queries and
generated notifiers for actions. Check `pubspec.lock` before using documentation
examples: APIs from Riverpod 3 may not apply.

## Current code

| Provider | Responsibility |
| --- | --- |
| `authProvider` | Async token/session state and sign-in/out/refresh actions |
| `appRouterProvider` | Auth-aware GoRouter; redirect refresh subscription |
| `appThemeProvider` | Application theme |
| `stravaConnectionProvider` | Async backend connection status, connect and disconnect |
| `personalPlansProvider` | Fetch and parse personal plans |
| `activityLogsProvider(planId)` | Fetch and parse a plan's activity ledger |
| `sportTypesProvider` | Read available sport types |
| `localStoreProvider` | SharedPreferences-backed local store |
| `navigationProvider` | Legacy tab-index state; shell derives current tab from routing |

Plans providers live under `lib/features/plans/presentation/providers/`.
Other feature providers retain their historical locations.

## Usage conventions

Use `ref.watch` for render dependencies, `ref.read(provider.notifier)` in action
callbacks, and `ref.listen` for appropriate reactions. Do not start navigation or
requests as side effects of a widget's build. Use `AsyncValue` loading/data/error
states explicitly, check mounted after async widget work, and dispose owned resources.

For future boundary migrations, expose repositories through composition providers;
query/action providers depend on contracts, and successful actions invalidate
affected reads. Current plans providers still perform HTTP directly and screens
still coordinate mutations. This initial folder change preserves those behaviors.

Generated action providers use `@riverpod`. After changing generation inputs:

```sh
dart run build_runner build --delete-conflicting-outputs
```

Do not edit `*.g.dart`. The current quality script runs `flutter analyze`;
`custom_lint`/`riverpod_lint` are dependencies but a separate CI lint gate is future
work. Do not claim it already runs.

## Tests

Use fresh, disposed ProviderContainers/ProviderScopes per test. Override providers
for isolated rendering tests; future feature tests should preserve the feature's
real state/repository path and replace external boundaries.
See [testing](testing.md) and [Riverpod testing guidance](https://riverpod.dev/docs/how_to/testing).
