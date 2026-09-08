---
name: flutter
description: Write or change Planthor Dart, Flutter widgets, and Riverpod 2 state. Use for feature implementation and UI fixes, including ordinary UI work requiring accessible styling and behavior.
---
# Flutter implementation

Read [architecture](../../../docs/architecture.md) for actual structure and legacy
exceptions. Retain the current stack and semantic tokens.

- For widgets/interactions read [UI conventions](references/ui-conventions.md)
  and [accessibility guidance](../../../docs/accessibility.md).
- For providers/actions read [state management](../../../docs/state-management.md).
- Follow `analysis_options.yaml` and Effective Dart. Prefer immutable values,
  composition, explicit async states, and small widgets with clear responsibilities.
- Keep controllers/focus local and dispose them. Check `mounted` after awaiting
  before using widget context. Handle loading, empty, error, and success states.
- New/migrated code uses repositories for I/O. The current `plans` feature
  demonstrates folder placement, not fully separated architectural boundaries.
- Add meaningful regression tests for behavior changes; preserve existing behavior
  for organizational changes. Run the checks in [testing](../../../docs/testing.md).
  Do not expand a documentation/folder task into implementation or visual changes.

Source: [Effective Dart](https://dart.dev/effective-dart), reviewed 2026-09-07.
