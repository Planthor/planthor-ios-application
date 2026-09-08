---
name: flutter-architecture
description: Structure and review Planthor Flutter features and dependencies. Use when adding features, organizing application or test folders, introducing repositories, or moving responsibilities.
---
# Feature-first architecture

Read [architecture](../../../docs/architecture.md) and [testing](../../../docs/testing.md).
Use `plans` for folder placement; read the documented legacy exceptions before
treating it as a behavioral implementation template.

- Organize by feature, then domain/data/presentation. Use `providers`, not `bloc`,
  for Riverpod. Mirror feature names under `test/unit/features` and
  `test/widget/features`; shared checks belong under `core`.
- In new/deliberately migrated code, domain uses plain Dart; data implements domain
  contracts; screens invoke providers. Composition is where concrete data
  implementations are selected. Keep JSON/HTTP in data and visual formatting in UI.
- Create only useful layers. A datasource owns a meaningful I/O boundary; a use case
  owns substantial or reused orchestration. Do not generate empty templates.
- Keep feature-specific code local; move it to `core` only when actually shared.
- For a folder-only task, move existing files and update imports; preserve all
  behavior, tests, payloads, and dependencies. Verify that the diff contains only
  those path edits. Do not invent interfaces, migrations, or test frameworks.
- Functional boundary migration is a separate scoped task with regression tests.
