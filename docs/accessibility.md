# Apple HIG and WCAG guidance for Planthor

Status: **guidance only in the initial skills/folder adoption**. No visual,
WCAG-remediation, semantics, motion, or runtime changes are included. Current
screens have not been assessed for full conformance.

Target future UI work at applicable **WCAG 2.2 Level A and AA** criteria plus Apple
Human Interface Guidelines. Use WCAG2ICT to interpret criteria for native software;
WCAG2Mobile is supplementary draft guidance, not a separate normative standard.

## Practical implementation requirements

| Area | Guideline for scoped future work |
| --- | --- |
| Text contrast | 4.5:1 for ordinary text; 3:1 only for qualifying large text. Measure actual rendered pairs and opacity; apply criterion exceptions correctly. |
| Non-text contrast | 3:1 for visual information needed to identify controls/states and meaningful graphics, subject to WCAG exceptions. |
| Meaning | Never rely solely on color, sound, position, or gestures. Give plan status/progress meaningful text and semantics. |
| Targets | Project default: at least 44×44 Flutter logical pixels on iOS, preferably 48×48 shared controls, with nonoverlapping hit padding. |
| Typography | Respect system text scaling/Dynamic Type, wrapping and scrolling. Keep actions and essential content available at large accessibility sizes. |
| Semantics | Names, roles, values, states, reading order, and no duplicated decorative announcements. Accessible names include visible labels. |
| Forms | Persistent associated labels, helpful instructions/errors, input preservation, appropriate keyboards, and accessible async feedback. |
| Focus | Logical order, visible keyboard focus, modal containment/restoration, no traps, and controls reachable above the keyboard. |
| Navigation | Predictable tabs/back/dismiss behavior; clear destructive consequences and confirmation or recovery where applicable. |
| Gestures | Offer ordinary controls for drag/swipe/motion actions; do not make an essential task gesture-only. |
| Motion | Honor Reduce Motion, avoid unnecessary movement/flashing, and keep feedback understandable without motion or haptics. |
| Layout | Safe areas, supported orientations, narrow screens, flexible heights, keyboard insets, and supported theme contrast. |
| Authentication | Preserve password-manager/autofill/paste support where applicable; include external auth surfaces in release review with ownership identified. |

The iOS target rule is a project default informed by Flutter's iOS guideline.
WCAG 2.2 AA target sizing uses a 24 CSS-pixel minimum with specified exceptions;
CSS pixels, iOS points, and Flutter logical pixels must not be conflated.

Maintain Planthor fonts and visual identity where compatible. HIG does not require
replacing the app's widget stack with Cupertino or adding a new theme.

## Figma conflicts: decision before visual changes

The user's chosen policy is **flag for a design decision**.

1. Identify the screen/control, Figma node, relevant criterion/HIG recommendation,
   measured evidence, and affected state.
2. Prepare the smallest concrete correction and its visual impact.
3. Record the finding here and in the PR, and ask for the user's design decision
   before applying the conflicting visual change. Continue independent work.
4. After a decision, update implementation, design contract, and verification together.
5. Keep unresolved findings visible. Do not suppress tests, bless defects in golden
   updates, or describe pending work as conformance.

## Initial observations — not a completed audit

Calculated from `DESIGN.md` opaque token values against white:

| ID | Potential usage | Evidence | Proposed design option | State |
| --- | --- | --- | --- | --- |
| A11Y-001 | White ordinary text on `brand #1877F2` | 4.23:1, below 4.5:1 | Use an approved darker action token such as existing brandDark, retaining bright brand for suitable uses | Design decision pending; unchanged |
| A11Y-002 | `inactive #94A3B8` for selectable navigation or input hints on white | 2.56:1; insufficient for ordinary text and required non-text cues | Approve a darker semantic foreground for these enabled/meaningful states | Design decision pending; unchanged |
| A11Y-003 | Small success text `#16A34A` on white | 3.30:1, below ordinary-text requirement | Approve darker success foreground while retaining container/graphic branding | Design decision pending; unchanged |

Validate actual component backgrounds, font classification, state, and applicable
exceptions before attributing failure. An unselected tab is still interactive;
a disabled control has different exceptions. These token observations are not
a claim that every use of a brand color fails.

## Verification for future UI work

Use the checks described in [testing](testing.md), including automated Flutter
guidelines, actual color pairs, semantics, scaling/layout, and manual assistive
technology. Assess complete journeys and error/loading/modal states.

For an assessment record: criterion/HIG source, flow/component, applicability
(or justified non-applicability), method, result, evidence, owner, and open decision.
Assess all applicable A/AA criteria, not just the practical shortlist above.
Do not claim app-wide AA based on a few passing automated checks.

## Sources

Reviewed 2026-09-07:

- [Apple HIG](https://developer.apple.com/design/human-interface-guidelines)
  and [accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility).
- [WCAG 2.2 Recommendation](https://www.w3.org/TR/WCAG22/).
- [WCAG2ICT](https://www.w3.org/TR/wcag2ict-22/) — informative native-software mapping.
- [WCAG2Mobile](https://www.w3.org/TR/wcag2mobile-22/) — draft, informative guidance.
- W3C explanations of [text contrast](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html),
  [non-text contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html),
  and [target size](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html).
- [Flutter accessibility testing](https://docs.flutter.dev/ui/accessibility/accessibility-testing).
