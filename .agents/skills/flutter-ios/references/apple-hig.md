# Apple HIG in Flutter

Reviewed 2026-09-07. Read the relevant official source for the task and recheck
when platform expectations change. Shared measurable requirements live in
[accessibility guidance](../../../../docs/accessibility.md).

| Apple guidance | Practical Planthor application |
| --- | --- |
| [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility) | VoiceOver names, values, order and states; Dynamic Type; assistive input; non-color meaning; Reduce Motion. Verify complete tasks. |
| [Typography](https://developer.apple.com/design/human-interface-guidelines/typography) | Keep hierarchy at large accessibility sizes. Brand fonts can remain; use system text scaling and flexible layout. |
| [Layout](https://developer.apple.com/design/human-interface-guidelines/layout) | Respect safe areas, orientations, readable widths, keyboard insets, and reachable actions. The Figma canvas is one viewport. |
| [Navigation and search](https://developer.apple.com/design/human-interface-guidelines/navigation-and-search) | Predictable hierarchy, consistent tabs, and back behavior using the existing GoRouter shell. |
| [Sheets](https://developer.apple.com/design/human-interface-guidelines/sheets) and [alerts](https://developer.apple.com/design/human-interface-guidelines/alerts) | Clear cancellation/destruction, modal focus, background interaction blocking, and focus restoration. |
| [Motion](https://developer.apple.com/design/human-interface-guidelines/motion) | Explain state with restrained motion; retain understandable feedback when motion or haptics are unavailable. |

Project target for future controls: at least 44×44 Flutter logical-pixel hit regions
on iOS, preferably 48×48 for shared controls, with nonoverlapping padding.
This uses Flutter's iOS target guideline; it is not WCAG's CSS-pixel definition.

Preserve brand styling when it meets the requirements. When a Figma specification
conflicts, prepare the smallest concrete correction for the user's design decision.
Do not automatically replace fonts, colors, layouts, or controls during skill setup.
