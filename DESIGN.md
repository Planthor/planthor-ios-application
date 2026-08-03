# Planthor Design Specification

Source: [Planthor Figma](https://www.figma.com/design/yqTi4zKDeLGvZXZiepxFAB/Planthor?node-id=0-1)

This document is the implementation contract between the Figma file and the
Flutter application. Figma node IDs are authoritative references. Prefer shared
tokens and widgets over copying raw values into screens.

## Product structure

The primary mobile canvas is 390 px wide. Main navigation contains Home, Plans,
and Settings. The app uses a shared top bar and a 90 px bottom navigation bar.

| Flow | Figma nodes | Flutter status |
| --- | --- | --- |
| Sign in | `303:45` | Implemented; needs token migration |
| Home/activity | `814:786` | Placeholder |
| Active plans | `717:364`, `60:482`, `75:92` | Current implementation target |
| All plans | `53:2674`, `261:2` | Missing |
| Create/edit plan | `86:2`, `86:80`, `88:397`, `258:2`, `258:90`, `259:173` | Missing |
| Plan details | `114:210`, `142:969`, `170:2` | Missing |
| Delete plan | `172:154`, `224:2` | Missing |
| Connect apps | `305:137`, `731:226` | Partially implemented |
| Settings | `288:4`, `634:178`, `305:869`, `305:917` | Partially implemented |
| Delete account | `770:1287`, `770:1428` | Missing |

Shared Figma references:

- App bars: `808:674`, `808:675` — 390×75.
- Bottom navigation: `305:394`, `305:615`, `305:850` — 390×90.
- Active-plan cards: `717:375`, `717:399`, `717:423`, `717:451`.
- Active-plan navigation instance: `717:502`.

## Foundations

### Color roles

| Token | Value | Usage |
| --- | --- | --- |
| `background` | `#F7F9FB` | Screen canvas |
| `surface` | `#FFFFFF` | Cards, app bar, navigation |
| `textPrimary` | `#191C1E` | Headings and primary values |
| `textSecondary` | `#414754` | Supporting copy and dates |
| `brand` | `#1877F2` | Bright brand and primary actions |
| `brandDark` | `#0058BC` | Strong actions |
| `brandHeader` | `#1D4ED8` | Header/navigation brand |
| `activeContainer` | `#EFF6FF` | Active navigation pill |
| `controlSurface` | `#ECEEF0` | Buttons and quiet controls |
| `metricSurface` | `#F2F4F6` | Metric containers |
| `inactive` | `#94A3B8` | Inactive navigation |
| `success` | `#16A34A` | Completed plans |
| `error` | `#BA1A1A` | Destructive/overdue |
| `errorContainer` | `#FFDAD6` | Destructive background |
| `strava` | `#FC4C02` | Strava brand |

Do not add new direct hex values in product screens. Add semantic tokens to
`AppColors`, then consume them through `ThemeData` or shared widgets.

### Typography

Montserrat is the product typeface. Sign-in retains Inter where required by
node `303:45`.

| Role | Font |
| --- | --- |
| Screen heading | Montserrat 28/42, weight 600, tracking −0.28 |
| Card heading | Montserrat 20/28, weight 700 |
| Large metric | Montserrat 30/36, weight 700 |
| Body/action | Montserrat 14/20, weights 500–700 |
| Caption/date | Montserrat 12/16, weight 500 |
| Eyebrow/status | Montserrat 12/16, weight 600, tracking 1.2, uppercase |
| Bottom navigation | Montserrat 11.2/16.8, weights 500–600 |

### Spacing and geometry

- Spacing scale: 4, 8, 12, 16, 20, 24, 32, 40, 48, 56.
- Compact page horizontal padding: 24.
- Active-plan card: 24 padding, 24 radius, 24 vertical gap.
- Input/button height: 56; radius: 12.
- FAB: 56×56; radius: 16.
- Progress ring: 80×80.
- Bottom navigation: 90 high including safe area; top radius: 16.
- Header: 75 high.
- Sign-in card radius: 48.

### Elevation

- Card: `0 20 20 rgba(25, 28, 30, 0.04)`.
- Header: `0 1 2 rgba(0, 0, 0, 0.05)`.
- Bottom navigation: `0 -4 10 rgba(0, 0, 0, 0.03)`.
- FAB: use Material elevation matching the Figma two-layer shadow.

## Active Plans (`717:364`)

Screen order:

1. Shared app bar with Planthor brand and 40 px profile avatar.
2. “Active Plans” heading.
3. Connection status chip.
4. Four plan cards in the reference state.
5. 56 px create-plan FAB.
6. Shared three-tab bottom navigation.

Runtime behavior must support:

- loading skeleton/progress;
- network error with retry;
- empty state matching `75:92`;
- populated list from `personalPlansProvider`;
- legacy list and cursor-paginated API payloads during backend transition.

Plan card contract:

- 342 px content width on a 390 px canvas;
- 24 px internal padding and radius;
- 80 px progress ring;
- title/date hierarchy from typography table;
- active, completed, and overdue semantic colors;
- accessible tap target and semantic label.

## Assets

Prefer repository-owned SVG/raster exports over temporary Figma URLs. Important
source nodes:

- Planthor logo: `303:50`.
- Facebook mark: `303:61`.
- Strava logo: `305:144`.
- Header/avatar sources: `717:501`, `814:798`, `814:843`, `814:888`, `814:948`.
- Progress activity glyphs: `717:387`, `717:411`, `717:436`, `717:465`.

Temporary Figma export URLs expire. Download approved assets into
`assets/images/`; use `flutter_svg` for SVG. Material icons are acceptable only
when their shape matches the source.

## Engineering rules

- Reuse `AppColors`, `AppSpacing`, `PlanthorAppBar`, `PlanthorBottomNav`,
  `PlanCard`, and `PlanProgressRing`.
- Use Riverpod loading/data/error states explicitly.
- Use GoRouter for product routes.
- Keep compact design exact; adapt medium/expanded layouts with existing
  breakpoints instead of stretching mobile geometry.
- Add widget tests for behavior and targeted golden tests for stable,
  Figma-critical screens.
- Never edit generated `*.g.dart` files manually.

## Delivery order

1. Normalize semantic theme tokens and typography.
2. Align shared app bar and bottom navigation.
3. Align Active Plans and live provider states.
4. Build Home/activity.
5. Add create/edit/details/all-plans routes.
6. Align Settings, Connect Apps, and account deletion.
7. Add golden coverage at 390 px and accessibility checks.

## Known Figma limitations

The file exposes no local variables or published components; styling is encoded
as raw frame properties. Code Connect inventory is unavailable on the current
Starter/View seat. Nine representative screen contexts were inspected before
the Figma MCP call quota was reached.
