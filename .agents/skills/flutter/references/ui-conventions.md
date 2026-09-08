# UI implementation conventions

Read [DESIGN](../../../../DESIGN.md) for the Figma contract and
[accessibility guidance](../../../../docs/accessibility.md) for applicable WCAG A/AA.
For iOS navigation/modal work also read
[Apple HIG guidance](../../flutter-ios/references/apple-hig.md).

- Reuse `AppColors`, `AppSpacing`, app chrome, and feature widgets. Preserve brand
  fonts; put new semantic tokens centrally instead of screen-local hex colors.
- Use system text scaling, safe areas, keyboard insets, wrapping, and reachable
  actions. Do not shrink or clamp text to reproduce a screenshot.
- Prefer standard accessible controls. Custom controls need roles, names, values,
  state, focus/keyboard activation, and adequate nonoverlapping hit areas.
- Associate visible field labels and errors with their controls. Preserve input
  on failure. Exclude decorative icons from duplicate screen-reader announcements.
- Give progress/status meaningful text or semantics beyond color; respect
  reduced motion. Check loading, empty, failure, success, and modal states.
- Measure contrast between actual foreground/background pairs, including opacity.
- For a Figma conflict, record evidence and a concrete proposed correction and
  obtain the user's design decision before changing the conflicting visual.
  Never hide a defect through a golden update or a disabled accessibility test.

These are guidelines for scoped future implementation. The initial skills/folder
adoption does not change the UI or claim existing screens satisfy all requirements.
