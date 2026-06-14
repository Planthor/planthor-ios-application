# Planthor: Project Brief & Product Requirements Document (PRD)

## 1. Project Overview
**Planthor** is a high-performance fitness tracking and training plan management application designed for athletes (e.g., Alex Rivers). The platform focuses on goal-oriented training, performance density, and seamless integration with third-party fitness ecosystems like Strava.

### Design Philosophy: "Planthor Performance System"
- **Visual Language:** High contrast, data-dense, and professional.
- **Key Characteristics:** 
  - Structural clarity and information density.
  - Performance-focused color signaling (success/warning).
  - Streamlined, minimalist navigation.

---

## 2. Design System & Visual Identity
The project uses the **Planthor Performance System** (Design System {{DATA:DESIGN_SYSTEM:DESIGN_SYSTEM_2}}).

### Color Palette
- **Primary:** `Planthor Blue (#18A0FB)` — Used for primary actions, active navigation states, and progress.
- **Success:** `Achievement Green (#34D399)` — Used for completed goals, connected states, and positive streaks.
- **Error/Alert:** `Missed Deadline Red (#BA1A1A)` — Reserved for missed deadlines and critical performance alerts.
- **Surface:** `F8F9FA` (Light) with high-contrast text for maximum readability.

### Typography
- **Headlines:** `Plus Jakarta Sans` — Chosen for its modern, athletic feel.
- **Body & Metrics:** `Inter` — Optimized for legibility in data-heavy views.

### UI Tokens
- **Roundness:** `ROUND_EIGHT` (8px corner radius) for cards and buttons.
- **Spacing:** Structured grid with consistent `container-margin` and `stack-gap` tokens.

---

## 3. Core User Flows & Screens

### 3.1. Active Plans Dashboard
The central hub where athletes monitor their current goals.
- **Layout:** Dense, vertical cards showing metrics (current/total), progress rings, and achievement status.
- **Visual Logic:** Progress rings are positioned on the right for balanced hierarchy.
- **States:** 
  - **Active:** Real-time tracking of runs, cycles, and streaks.
  - **Missed Deadline:** High-visibility red signaling for goals falling behind.
  - **Empty State:** Motivational onboarding view encouraging plan creation.

### 3.2. Connectivity & Integration
Integration with Strava to sync activities automatically.
- **States:** Not Connected, Connecting (with status feedback), and Connected (with success verification).
- **Navigation:** Streamlined header with logo on the left and notification bell on the right. No back arrows or profile buttons to maintain flow focus.

### 3.3. User Profile & Settings
Personalized athlete dashboard.
- **Metrics:** Average completion rate, total workouts, and current streaks.
- **Personal Information:** Editable fields for name, email, and phone, aligned with the high-density material system.

---

## 4. Component Library
- **TopAppBar:** Minimalist sticky header containing the "Planthor" brand wordmark (left) and notification bell (right).
- **BottomNavBar:** Persistent navigation for Home, Plans, and Stats/Profile. Uses a high-contrast active state with rounded backgrounds.
- **Performance Cards:** Container for metrics with integrated SVG progress rings and status badges.
- **Selection Controls:** Standardized toggle switches and radio-style cards for units (Kilometers vs. Miles).

---

## 5. Accessibility Standards
Targeting **WCAG 2.1 Level AA** compliance.
- **ARIA Implementation:** `aria-live` for status changes (e.g., "Connecting"), `aria-current` for navigation, and `aria-label` for icons.
- **Contrast:** High-contrast status badges ensuring clarity for color-blind users.
- **Semantic HTML:** Strict use of buttons, links, and list structures.

---

## 6. Roadmap & Future Explorations
- **Stats Dashboard:** Detailed performance analytics and historical trend visualization.
- **Dark Mode:** A high-contrast version of the system for low-light environments.
- **Community Feed:** Social features for sharing achievements and plan discoveries.
