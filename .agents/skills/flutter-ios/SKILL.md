---
name: flutter-ios
description: Guide Planthor iOS interaction design and platform integration. Use for Apple HIG behavior, accessible navigation and dialogs, OAuth callbacks, storage, lifecycle, flavors, or iOS build verification.
---
# Flutter on iOS

For interaction work read [Apple HIG](references/apple-hig.md) and
[accessibility guidance](../../../docs/accessibility.md). For verification read
[testing](../../../docs/testing.md).

- Preserve dev/prod schemes and distinct app identities; use dev for verification.
  Read environment setup before changing endpoints, callback schemes, or entitlements.
- Keep custom native code narrow. In future implementation work, isolate platform
  dependencies behind injectable boundaries; do not add them to a folder-only task.
- Prefer existing Flutter/adaptive components with correct iOS interaction behavior.
  HIG adoption does not imply a wholesale Cupertino rewrite.
- Check safe areas, back/dismiss, keyboard/focus, Dynamic Type, VoiceOver, and
  reduced motion whenever the task affects those behaviors.
- Flag Figma conflicts with evidence and a proposed fix; obtain the user's design
  decision before applying conflicting visuals. Initial adoption is guidance only.
- Existing verification is unsigned iOS compilation, not a simulator journey.
  Report native/device/OAuth checks that were not actually completed. Publication
  is a separate operation.
