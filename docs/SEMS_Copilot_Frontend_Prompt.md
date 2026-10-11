# SEMS Flutter Frontend: Master Prompt for GitHub Copilot Agent

Paste everything below the line into Copilot Agent. Keep this file in the repo as `docs/COPILOT_PROMPT.md` so the agent can re-read it.

---

## 0. Your role and the problem to solve

You are a senior Flutter engineer. You are building the **Android frontend only** of SEMS (Smart Energy Management System), an app that monitors and controls smart electricity sockets.

The current code does not match the Figma design. Known problems:
1. Screens look slightly different from Figma (spacing, colours, radii, text sizes, button placement).
2. **Developer mode** is missing.
3. **Family role** (restricted permissions) is missing.
4. Many components, states, sheets, dialogs and error screens are missing.
5. The code is not organised folder by folder and file by file.
6. Mock data is hard-coded inside widgets.

Your job is to fix all six. **Do not build any backend.** The server decision has not been made. Everything the app needs from a server must come from a **mock data layer** behind interfaces, so a real backend can replace it later without touching the UI.

### How to work (follow strictly)
1. **Audit first, code second.** Read the existing codebase and the Figma file. Write `docs/GAP_REPORT.md` listing every screen, component and feature that is missing or different. Show it to me before large changes.
2. **Work in the phases in section 14.** Finish and verify one phase before starting the next. After each phase, list the files you changed and tick the checklist in section 15.
3. **Never guess a design value.** Read it from Figma with the Figma MCP (section 2). If Figma and this document disagree, Figma wins for visuals, this document wins for behaviour. Tell me about the conflict.
4. **Never put data in widgets.** No hard-coded names, numbers, lists or colours inside screen files (sections 4 and 6).
5. **One screen = one file** (plus small widgets in its own `widgets/` folder). No file over about 300 lines. Split it if it grows.
6. Run `flutter analyze` and `flutter test` after every phase. Fix every warning.

---

## 1. The Figma file

- File: https://www.figma.com/design/iCztQCU9fzB7OITQ0fdxtC/SEMS-App-V1--Design---Prototype-
- File key: `iCztQCU9fzB7OITQ0fdxtC`
- Screen size: 390 px wide (phone). Tall frames show the full scroll length, so build them as scrollable screens, not clipped screens.
- Sheets and dialogs are drawn as full-screen frames with a dark scrim. In Flutter, build them as a **modal bottom sheet** or **dialog over the previous screen**, not as separate full pages.

### Pages in Figma
| Page | Content |
|---|---|
| Cover, 00 Flows | Overview, 10 flow maps, page index, design notes. **Read 00 Flows first.** |
| Design System | Colour variables, radius variables, Button, Status badge, Bottom navigation, Metric tile, Device card |
| 01 Auth | Splash, onboarding, sign in/up, errors, forgot password, verify email |
| 02 Dashboard | Dashboard (light, dark, learning, empty, safety trip, filters sheet, heads-up alert), More tab |
| 03 Devices | Devices list, device detail states, manage sheets, safety limits, **add-socket flow and errors** |
| 04 Appliances | List, add, overview states, archive, move wizard |
| 05 Control | Remote control states, timer sheet, emergency OFF dialog |
| 06 Scheduling | Schedules list, pause, editor variants, validation |
| 07 History | Hour/Day/10 s charts, telemetry gap, filter, export sheet |
| 08 Alerts | Alert tabs, AI alerts, detail sheets, alert settings |
| 09 Billing | Tariff, bills, estimate vs billed, validation |
| 10 AI | AI Energy by data coverage, insight sheet, AI settings |
| 11 Backup | Google Drive backup states, restore wizard, errors |
| 12 Settings | Profile, notifications, family and permissions, storage, privacy, dialogs |
| 13 Family variants | The same screens as a Family member sees them |
| 14 Developer | Developer mode (socket identities) |
| 15 Prototype (clickable) | All 164 screens wired together. **Use this page to learn navigation.** |

---

## 2. How to use the Figma MCP (this is how you get exact visuals)

For each screen you build:
1. `get_metadata` with `fileKey` and no `nodeId` to list pages. Then `get_metadata` with a page id to list its frames and node ids.
2. For the frame you are building, call `get_design_context` (load the figma design-to-code guidance first, as the tool requires). Also call `get_screenshot` for that frame and keep it as the visual target.
3. Call `get_variable_defs` once to get the colour and radius variables (Light and Dark). Generate `AppColors` from them. Do not copy hex values by hand.
4. Translate the returned React/CSS reference into **Flutter widgets using our own components** (section 4). The returned code is a reference, not code to paste. Do not use absolute positioning. Use `Column`, `Row`, `Padding`, `Expanded`, `SizedBox`.
5. After building, compare your running screen with the Figma screenshot. Fix every visible difference in spacing, size, colour, weight, radius and alignment before moving on.
6. Frame names in Figma are the screen names. Use them in file names, routes and tests (section 7).

Rules:
- The same frame name exists on its feature page and on page 15. They are identical. Use the feature page.
- Layer names use `Button/primary`, `Chip/Day`, `Row/Safety limits`, `Appliance card/Heater`, `Action/plus`, `Back`. They tell you which component and which action to implement.

---

## 3. Tech decisions (do not change without asking)

| Topic | Decision |
|---|---|
| Platform | Android first. Keep UI and domain iOS-ready: no Android-only code there. |
| Language / SDK | Dart 3, latest stable Flutter, null safety, `flutter_lints` |
| State management | **Riverpod** (`flutter_riverpod`). One providers folder per feature. |
| Navigation | **go_router**, route names in one file, role-guarded redirects |
| Local DB (mock database) | **drift** (SQLite) seeded from JSON (section 6) |
| Models | `freezed` + `json_serializable` (immutable) |
| Charts | `fl_chart` (bar, area, shaded forecast band, dashed line) |
| Fonts | Inter (text) and JetBrains Mono (IDs, claim codes, credentials), bundled in assets |
| Icons | Line icons, 2 px stroke (Lucide style) |
| Money / dates | `intl`, INR `₹` default |
| Tests | `flutter_test`, golden tests for key screens, unit tests for calculators and role rules |

---

## 4. Design system → Flutter theme and components

### 4.1 Tokens (generate from Figma variables, never hard-code in screens)
Create `lib/core/theme/`:
- `app_colors.dart`: `ThemeExtension<AppColors>` with Light and Dark. Map these Figma variables: `surface/background`, `surface/card`, `surface/raised`, `text/primary`, `text/secondary`, `border/subtle`, `brand/primary`, `brand/on-primary`, `brand/tint`, `status/ok`, `status/warning`, `status/fault`, `status/offline`, `status/pending`, `status/ai`, `status/yellow`, `status/orange`, and the `-tint` version of each status colour.
- `app_radii.dart`: card 12, button 12, input 8, chip/badge pill 999, bottom sheet top 20, dialog 16, icon tile 8 to 12.
- `app_spacing.dart`: screen padding 16, section gap 16, card padding 14 to 16, list gap 10, row min height 56.
- `app_text.dart`: Inter sizes 11, 12, 13, 14, 15, 17, 20, 22, 28, 40; weights Regular, Medium, SemiBold, Bold; Mono 12 to 13. Section titles: 13 px semibold, uppercase, secondary colour.
- `app_shadows.dart`: card shadow (two soft layers, light theme).
- `app_theme.dart`: `ThemeData` light and dark. Dark is shown on the frame "Dashboard - dark".

### 4.2 Shared components (`lib/shared/widgets/`, one file each)
Build **all** of these before screens. Each gets a golden test.

| Component | File | Variants / notes |
|---|---|---|
| AppButton | `app_button.dart` | primary, secondary (outlined), tonal, danger, text; small (40 px) and regular (48 px); optional leading icon; disabled (45% opacity); full width by default |
| AppChip | `app_chip.dart` | selected / unselected, optional icon, optional count bubble; scrollable rows |
| AppSegmented | `app_segmented.dart` | e.g. Sign in / Sign up |
| AppToggle | `app_toggle.dart` | 46×28 switch |
| AppCheckbox, AppRadioCard | `app_checkbox.dart`, `app_radio_card.dart` | radio card has tinted selected state |
| AppTextField | `app_text_field.dart` | label, leading icon, unit suffix, hint, error (red border + icon + text), disabled, focus, password with "Show" |
| StatusBadge | `status_badge.dart` | tones: ok, warn, fault, off, pend, ai, brand, mute, yellow, orange; optional icon |
| RoleBadge | `role_badge.dart` | Owner (brand tint), Family (pending tint) |
| AppBanner | `app_banner.dart` | tones ok/warn/fault/off/pend/ai; title, body, optional action text |
| AppCard | `app_card.dart` | border + soft shadow; variant with left accent bar (alerts, AI insights) |
| SettingsGroup, AppRow | `settings_group.dart`, `app_row.dart` | grouped rows with dividers; icon tile, title, subtitle, right widget, chevron, danger, dimmed |
| SectionHeader | `section_header.dart` | caps title + optional action |
| MetricTile | `metric_tile.dart` | **measured** (solid border), **estimated** (dashed border + sparkle), **billed** (raised background + receipt icon) |
| EstimatedBadge | `estimated_badge.dart` | purple "Estimated" with sparkle |
| AppProgressBar | `app_progress_bar.dart` | tones |
| SignalBars | `signal_bars.dart` | 0 to 4 bars |
| ApplianceIcon | `appliance_icon.dart` | categories: Heater, Fan, Refrigerator, Water heater, Air conditioner, Lighting, Television, Other; dim when offline |
| AppTopBar | `app_top_bar.dart` | back, title, subtitle, action icons, **RoleBadge on the right** |
| AppBottomNav | `app_bottom_nav.dart` | 5 tabs: Dashboard, Devices, History, Alerts, More; selected tab has a pill |
| AppBottomSheet | `app_bottom_sheet.dart` | grab handle, title, close X, top radius 20 |
| AppDialog | `app_dialog.dart` | title, body, Cancel + confirm (danger variant) |
| AppToast | `app_toast.dart` | dark pill with icon |
| EmptyState | `empty_state.dart` | 96 px circle icon, title, text, button |
| ErrorState | `error_state.dart` | 80 px red circle with alert, title, text, 1 to 2 buttons |
| StepBar | `step_bar.dart` | N-segment progress (7 add socket, 4 restore, 3 move) |
| PowerControl | `power_control.dart` | big circular ON/OFF button in a ring; states on, off, pending (spinning arc), failed, offline, blocked |
| LoadBars | `load_bars.dart` | 24 hourly bars; past solid, future faint |
| EnergyBarChart, EnergyAreaChart | `energy_charts.dart` | bar (hour/day), area (10 s), forecast with shaded band + dashed line; **data-gap overlay** "No data received" |
| AlertCard | `alert_card.dart` | severity badge, acknowledged badge, time, title, device, "Occurred/received", cause, next step, Acknowledge |
| InsightCard | `insight_card.dart` | AI insight with severity INFO, LOW, WARNING, HIGH + Estimated badge |
| QrScannerView | `qr_scanner_view.dart` | camera placeholder in mock mode |
| PermissionGate | `permission_gate.dart` | section 9 |

Icon names in the design (map to your icon set): home, socket, clock, bell, grid, chevR, chevL, chevD, power, plus, minus, code, eye, eyeOff, wifi, wifiOff, search, zap, flame, fan, fridge, droplet, snow, bulb, tv, check, checkC, x, xC, alert, sliders, user, users, cloud, cloudOff, shield, calendar, moon, sun, download, upload, scan, bluetooth, trend, sparkle, receipt, lock, refresh, trash, edit, info, file, pause, timer, mail, logout, swap, key, archive, layers, bars, qr, copy, sunrise, more.

Three kinds of numbers must always look different: **Measured** (plain), **Estimated** (dashed outline + sparkle + "Estimated"), **Billed** (raised grey background + receipt icon). Never mix them.

---

## 5. Folder structure (create exactly this, feature-first)

```
lib/
  main.dart
  app/
    app.dart                  # MaterialApp.router, theme, ProviderScope
    router/
      app_router.dart         # GoRouter + redirects
      routes.dart             # route names/paths as constants
      route_guards.dart       # auth, role, developer guards
  core/
    theme/                    # app_colors, app_text, app_radii, app_spacing, app_shadows, app_theme
    constants/                # asset paths, durations, limits
    errors/                   # AppException, Result type
    utils/                    # formatters (money, kWh, W, dates), validators
    services/                 # clock, id generator
  shared/
    widgets/                  # all components from section 4.2
    layout/                   # app_scaffold.dart, scrollable_screen.dart, sheet helpers
  domain/                     # PURE Dart, no Flutter imports
    models/                   # user, socket_device, appliance, session, telemetry_sample, schedule, alert, bill, tariff, ai_insight, backup_info, identity, command
    enums/                    # role, relay_state, command_state, alert_severity ...
    repositories/             # abstract interfaces only (section 6)
    services/                 # abstract: telemetry_stream, command_service, ai_engine, backup_service
    usecases/                 # session_energy, bill_estimator, ai_coverage, schedule_validator, permission_rules
  data/
    local_db/                 # drift database, tables, DAOs
    mock/
      mock_*_repository.dart  # implementations of the domain repositories
      mock_seeder.dart        # loads assets/mock/*.json
      simulators/             # telemetry, command, pairing, backup
      scenarios/              # scenario presets
  features/
    auth/  dashboard/  more/  devices/  add_socket/  appliances/  control/
    scheduling/  history/  alerts/  billing/  ai/  backup/  settings/  developer/
assets/
  fonts/  icons/  mock/       # mock JSON seed data lives here, not in Dart code
test/
  unit/  widget/  golden/
docs/
  COPILOT_PROMPT.md  GAP_REPORT.md  ARCHITECTURE.md  MOCK_DATA.md  SCREEN_MAP.md
```

Every feature folder has the same shape:
```
features/<feature>/
  presentation/
    screens/       # one file per screen, e.g. device_detail_screen.dart
    widgets/       # widgets used only by this feature
    sheets/        # bottom sheets and dialogs of this feature
  providers/       # Riverpod providers for this feature
  models/          # view models only (domain models stay in domain/)
```
Rules:
- Dependencies point inward: `presentation → providers → domain ← data`. A screen never imports from `data/`.
- Screens contain layout only. Logic lives in providers and use cases.
- Every file starts with a one-line comment: what it is and the **Figma frame** it implements, e.g. `// Implements Figma frame: "Device detail"`.
- File names `snake_case`, classes `PascalCase`, one public class per file.

---

## 6. Mock database (mandatory, no data in widgets)

Do **not** write names, numbers or lists in widgets or providers. Build a mock backend that behaves like a real one.

### 6.1 Layers
1. `domain/repositories/` defines abstract interfaces: `AuthRepository`, `SocketRepository`, `ApplianceRepository`, `SessionRepository`, `TelemetryRepository`, `CommandRepository`, `ScheduleRepository`, `AlertRepository`, `BillingRepository`, `AiRepository`, `BackupRepository`, `FamilyRepository`, `SettingsRepository`, `DeveloperIdentityRepository`.
2. `data/mock/mock_*_repository.dart` implement them on a **local SQLite database (drift)**.
3. Seed data lives in `assets/mock/*.json` (users, sockets, appliances, sessions, schedules, alerts, bills, tariff, identities, history aggregates). `MockSeeder` loads it on first launch and on "Reset mock data".
4. Providers get repositories only through `xxxRepositoryProvider`. The real backend later = one new implementation + one provider override. **No UI change.**

### 6.2 Simulators
- `TelemetrySimulator`: emits a sample for each online socket **every 10 seconds**: `timestamp, device_id, sequence, relay, voltage_v, current_a, power_w, energy_kwh, frequency_hz, power_factor, quality`. Writes to the local DB and updates the dashboard stream.
- `CommandSimulator`: ON/OFF goes `PENDING → ACKNOWLEDGED → EXECUTED`. Must also return `FAILED`, `EXPIRED`, and **blocked by safety trip**. The UI never shows success before `EXECUTED`.
- `PairingSimulator`: runs the 8 add-socket steps with delays and can return each of the 8 error cases.
- `BackupSimulator`: upload progress, pending count, failure, verify result, restore validation (schema mismatch, checksum failure, account unavailable).
- Mock `AiEngine`: computes forecast, anomalies, wastage and savings from seeded history with simple rules, returning the same models a real engine would. Respect the coverage gates in section 10.

### 6.3 Scenario switcher (needed for demos and tests)
Create `MockScenario` presets and a hidden **Mock controls** screen inside Developer mode (section 8). Presets: `normal`, `socketOffline`, `safetyTrip`, `learning2Days`, `basic5Days`, `good10Days`, `strong45Days`, `emptyNoSockets`, `emptyNoAppliances`, `driveNotConnected`, `driveFailed`, `commandFails`, `commandExpires`, `familyUser`, `ownerUser`. Every state frame in Figma must be reachable with one preset.

### 6.4 Seed values (put in `assets/mock/`, from the Figma example data)
- Owner: Asha Verma, owner@sems.app. Family: Rohan Verma, rohan@sems.app.
- Sockets: SEMS-000001 Living room (Heater, online, 2,200 W now, usual 1,500 W); SEMS-000002 Bedroom (Fan, 55 W); SEMS-000003 Kitchen (Refrigerator, offline 14 min); SEMS-000004 unclaimed (add-socket demo).
- Dashboard: 2,255 W now, Today 4.9 kWh, This period 168 kWh, Bill so far ₹1,292 (Estimated), peak 1,890 W at 19:42.
- Tariff: INR ₹; slabs 0 to 100 kWh ₹6.00, 100 to 200 ₹8.00, above 200 ₹9.50; fixed ₹120; duty 2%; budget ₹1,900; billing day 1.
- Bills: Sep 2026 232 kWh ₹1,860 (₹8.02/kWh), Aug 251 kWh ₹2,043, Jul 214 kWh ₹1,679.
- Heater: session started yesterday 22:41 at meter 145.80, meter now 150.00, session 4.20 kWh, today 3.10, lifetime 14.2.
- Schedules: "Evening heater" 18:00 to 22:00 Mon to Fri; "Night fan" 23:00 to 06:00 daily.
- Alerts, AI insights and their numbers: copy from Figma frames "Alerts - All", "Alerts - AI", "AI Energy - 45 days (strong)".

Document all of this in `docs/MOCK_DATA.md` (tables, files, how to add a scenario).

---

## 7. Screen inventory (build every one; Figma frame name = screen)

Files are under `lib/features/<feature>/presentation/screens/` unless noted. States listed after a screen are separate Figma frames. Implement them as states of the **same screen**, not copies.

### 7.1 Auth (`auth`)
| Figma frame | Route | File |
|---|---|---|
| Splash | `/splash` | `splash_screen.dart` (checks DB and session, then routes) |
| Onboarding 1 to 5 | `/onboarding` | `onboarding_screen.dart` (PageView, Skip, dots, Next / Get started, "Use without Drive for now") |
| Sign in | `/sign-in` | `sign_in_screen.dart` |
| Sign up | `/sign-up` | `sign_up_screen.dart` |
| Sign in: field errors / wrong password / email not verified / no network | same | error states with `AppBanner` |
| Forgot password: enter email / sent | sheet | `forgot_password_sheet.dart` |
| Verify email | `/verify-email` | `verify_email_screen.dart` (resend countdown) |

Hidden: **long-press the logo on Sign in** opens `/developer/login`.

### 7.2 Dashboard and More (`dashboard`, `more`)
| Figma frame | Route | File |
|---|---|---|
| Dashboard | `/home/dashboard` | `dashboard_screen.dart` (greeting, offline banner, total power + load bars, 3 metric tiles, AI insights, room chips, appliance cards with power button, overview tiles, AI tip, Drive sync row) |
| Dashboard - dark | same | dark theme |
| Dashboard - learning (2 days) | same | AI cards replaced by "2 of 7 days" progress |
| Dashboard - empty (no sockets) | same | `EmptyState` |
| Dashboard - safety trip | same | trip banner with countdown |
| Dashboard - filters sheet | sheet | `dashboard_filters_sheet.dart` (room, socket, appliance, date range) |
| Dashboard - alert heads-up | overlay | `alert_heads_up.dart` |
| More | `/home/more` | `more_screen.dart` (profile card, 6 menu rows, dark toggle, sign out) |

### 7.3 Devices (`devices`)
| Figma frame | Route | File |
|---|---|---|
| Devices list / empty | `/home/devices` | `devices_screen.dart` (search, room chips, socket cards with status, relay, signal, last seen) |
| Device detail / offline / safety trip / Family role | `/devices/:id` | `device_detail_screen.dart` (summary, Remote control button, 6 live readings, device info, diagnostics, manage group) |
| Device - rename sheet | sheet | `rename_socket_sheet.dart` |
| Device - assign room sheet | sheet | `assign_room_sheet.dart` |
| Device - socket buttons sheet | sheet | `socket_buttons_help_sheet.dart` (NAV/OK buttons, config menu list) |
| Device - change Wi-Fi (confirm / details) | sheet | `change_wifi_sheet.dart` |
| Device - transfer ownership sheet | sheet | `transfer_ownership_sheet.dart` |
| Device - remove dialog (online / offline) | dialog | `remove_device_dialog.dart` |
| Safety limits / validation error / Family read-only | `/devices/:id/limits` | `safety_limits_screen.dart` |

### 7.4 Add socket (`add_socket`): 8 steps + 8 errors
Route base `/add-socket`, `StepBar` of 7 segments. Files: `scan_qr_screen.dart`, `confirm_socket_screen.dart`, `pairing_security_screen.dart`, `wifi_details_screen.dart`, `pairing_mode_screen.dart`, `connecting_screen.dart`, `claiming_screen.dart`, `name_socket_screen.dart`.
Errors (one `AddSocketErrorScreen` with a type enum): invalid QR, Bluetooth not found, socket could not join Wi-Fi, claim code used, already claimed, too many attempts, pairing window closed, claim failed.
The QR claim code is never shown on screen and the app never asks for a broker password.

### 7.5 Appliances (`appliances`)
| Figma frame | File |
|---|---|
| Appliances list / empty | `appliances_screen.dart` (Active + Archived sections) |
| Add appliance / name required / Family denied | `add_appliance_screen.dart` (name, 8 category tiles, rated power, socket radios, "will be unassigned" warning) |
| Appliance overview: Heater / offline / archived / Family | `appliance_overview_screen.dart` (power now, separate energy tiles, runtime/peak/cost, session, AI analysis, historical, suggestions, related, manage) |
| Appliance - archive dialog | `archive_appliance_dialog.dart` |
| Move 1 to 4 | `move_appliance_wizard.dart` + 4 step widgets (close session, choose socket, review, done) |

### 7.6 Control (`control`): `remote_control_screen.dart`
One screen with a `ControlState` enum: ON idle, pending, acknowledged, executed OFF, failed, expired, timer running, socket offline, blocked by safety trip, Family role. Plus `timer_sheet.dart` and `emergency_off_dialog.dart`. Sections: control ring, status message, Timer + Emergency OFF buttons, Last command, Control history.

### 7.7 Scheduling (`scheduling`)
`schedules_screen.dart` (list, paused banner, empty, "Pause all"), `pause_schedules_sheet.dart`, `schedule_editor_screen.dart` (types Countdown, One-time, Daily, Weekly, Multiple intervals, Overnight; day circles; interval cards; "Ends next day"; overlap error; manual-override radios; enabled toggle; delete; **waiting for time sync** banner), `delete_schedule_dialog.dart`.

### 7.8 History (`history`): `history_screen.dart`
Range chips 10 s / 1 min / Hour / Day / Week / Month, appliance chips, chart card, telemetry-gap banner + gap overlay, 3 metrics, coverage bar, sessions list, `export_sheet.dart` (CSV, Excel-compatible CSV, JSON, PDF), empty state.

### 7.9 Alerts (`alerts`): `alerts_screen.dart`
Category chips with counts (All, Electrical, Energy, Connectivity, Automation, AI). The AI tab has two banners (estimated + quiet hours). `alert_detail_sheet.dart` (critical and AI variants), `alert_settings_sheet.dart` (overall limit, per-appliance limits, quiet hours), empty state.

### 7.10 Billing (`billing`): `billing_screen.dart`
Legend (Measured / Estimated / Billed), current period, budget progress, last bill vs estimate, bill records, tariff group, `edit_billing_sheet.dart` (currency, slabs, fixed, duty, budget, billing day, validation), `add_bill_sheet.dart`. Family sees it **read-only**.

### 7.11 AI (`ai`): `ai_energy_screen.dart`
Coverage card, forecast with band, peak periods, insights, appliance baselines, savings total, footer note. Variants by data coverage (45, 10, 5, 2 days). `insight_details_sheet.dart`, `ai_settings_sheet.dart`.

### 7.12 Backup (`backup`)
`backup_screen.dart` states: not connected, connected, syncing, failed, Drive account unavailable, Family (Owner only). Sheets: `drive_account_sheet.dart`, `manual_backup_sheet.dart`, `verify_result_sheet.dart`. Restore wizard `restore_wizard_screen.dart` (find, validating, review with merge / import-as-new, restoring, done) and `RestoreErrorScreen` (no backup, schema mismatch, checksum failed, account unavailable).

### 7.13 Settings (`settings`)
`settings_screen.dart` (Owner and Family variants), `profile_screen.dart`, `notification_rules_screen.dart`, `family_permissions_screen.dart` (members, **permission table Owner vs Family**), `invite_member_sheet.dart`, `remove_member_dialog.dart`, `storage_retention_screen.dart`, `privacy_data_screen.dart`, `sign_out_dialog.dart`, `delete_account_dialog.dart`.

### 7.14 Developer mode (`developer`): see section 8.

---

## 8. Developer mode (currently missing; implement fully)

Purpose: generate and manage **socket identities** that firmware developers hard-code into sockets, saved through the mock DB now and the cloud later. **Nothing else** belongs here, except the Mock controls screen (section 6.3).

- Entry: long-press the logo on Sign in → `/developer/login`. Not shown anywhere else.
- Login: developer ID + passcode. Credentials live in **one config file** `lib/features/developer/data/developer_credentials.dart` behind `DeveloperAuthRepository`, so they can move to cloud login later. A wrong login shows the red banner.
- Screens (Figma page "14 Developer"): `developer_login_screen.dart`, `identities_screen.dart` (badges Unclaimed / Claimed / Revoked), `create_identity_screen.dart`, `identity_created_screen.dart` (device ID, claim code, MQTT username and password with copy buttons; "secrets are shown once" banner), `identity_detail_screen.dart` (regenerate claim code, revoke, delete), `delete_identity_dialog.dart`, plus `mock_controls_screen.dart`.
- Data: `DeveloperIdentityRepository` (create, list, update, revoke, delete). Identity = device_id (next `SEMS-00000N`), serial, model `SEMS-S1`, claim code, MQTT credentials, status, created date.
- The add-socket flow validates the scanned code against these identities (mock): valid unclaimed proceeds; used → "claim code used"; claimed → "already claimed"; unknown → "invalid QR".
- The firmware does **not** generate identities. They only come from here.

---

## 9. Family role and permissions (currently missing; implement fully)

Two roles only in V1: **Owner** and **Family**.

| Permission | Owner | Family |
|---|---|---|
| View dashboard, history | ✓ | ✓ |
| ON/OFF control | ✓ | ✓ |
| Edit schedules | ✓ | ✓ |
| Add appliance | ✓ | ✗ |
| Add socket | ✓ | ✗ |
| Change tariff | ✓ | ✗ |
| Backup account | ✓ | ✗ |
| Transfer ownership | ✓ | ✗ |
| Delete account | ✓ | ✗ |

Implementation:
1. `domain/usecases/permission_rules.dart`: `bool can(Role role, Permission p)`. Unit-test every cell of the table.
2. `currentRoleProvider` from the signed-in user.
3. `PermissionGate(permission: ..., child: ..., fallback: ...)` used everywhere. Figma shows four behaviours; copy them:
   - **Hidden:** plus action in Appliances/Devices top bar, "Add bill", "Edit billing settings", Transfer ownership / Remove device / Change Wi-Fi rows.
   - **Dimmed with explanation:** Move to another socket, Archive appliance ("Only the Owner can change this").
   - **Replaced screen:** Backup and Add appliance show the lock empty state "Only the Owner can do this".
   - **Read-only:** Safety limits, Billing tariff, Family list.
4. `RoleBadge` in the top bar shows Owner or Family on every screen.
5. Route guard: Family cannot open owner-only routes even by deep link; redirect to the lock screen.
6. Mock repositories also **enforce** the rules and return `PermissionDenied`, as a real backend would. Hiding a button is not enough.
7. Check Figma page **13 Family variants** and the "Family" frames on pages 03, 04, 05, 09, 11, 12.

---

## 10. Behaviour rules (logic not visible in static frames)

**Remote control.** Tap → `PENDING` (ring turns blue with spinner, button locked, text "Control locked until the socket confirms") → `ACKNOWLEDGED` → `EXECUTED` (only now show the new ON/OFF state). `FAILED` and `EXPIRED` show a retry message and change nothing. Offline disables control. A safety trip blocks ON and shows the reason. Emergency OFF is a high-priority OFF behind a confirm dialog. Timer is a countdown OFF.

**Energy values are never mixed.** Meter lifetime kWh (socket) ≠ Session kWh (current meter − session start meter) ≠ Appliance lifetime (sum of sessions) ≠ Today ≠ Billing-period. Use separate tiles and labels.

**Move appliance.** Closes the old session at the current meter, opens a new session at the new socket's meter. Old history stays. One active session per appliance. Heater example: 145.80 → 150.00 = 4.20 kWh.

**Bill estimate.** Slab cost + fixed charge, then duty %. Effective rate = billed amount / billed kWh. Always label Estimated vs Billed. Show the estimated-vs-billed difference on Billing.

**AI data-coverage gates** (`ai_coverage.dart`): under 3 days: measured stats and a learning card only; 3 to 7 days: anomaly checks; 7 days or more: forecast with range; 30 days or more: stronger monthly forecast; 60 to 90 days: pattern comparison. AI severities: INFO, LOW, WARNING, HIGH. "Critical" is only for socket safety trips. Everything AI is labelled **Estimated**.

**Schedules.** Types: countdown, one-time, daily, weekly, multiple intervals, overnight (end stored as next day). Validate overlaps and require at least one day. Show "Waiting for time sync" when the socket has no valid clock. Pause/holiday suspends schedules. Manual override: resume at next interval, or stay overridden.

**History.** Ranges 10 s, 1 min, Hour, Day, Week, Month. Missing data is drawn as a gap, never interpolated.

**Backup.** Local DB is primary storage. Drive is optional. Show last sync time and pending count. Restore: validate schema and checksums, show conflicts, merge or import-as-new, skip duplicate batches by `batch_id`. The backup is a normal Drive folder (survives uninstall).

**Offline.** An offline socket shows greyed values, last-seen time and a banner. Local schedules and safety limits still run on the socket (say so in the UI text).

---

## 11. Navigation map

- Bottom tabs (shell route): Dashboard, Devices, History, Alerts, More. The bar is hidden on wizard, editor and error screens, as in Figma.
- Back button pops the stack.
- Source of truth for every tap target: Figma page **15 Prototype (clickable)**. Open it in prototype mode, or read each frame's reactions, and mirror every link.
- Timed transitions in the prototype: Splash → Onboarding (1.2 s); Add socket 6 → 7 → 8; Control pending → acknowledged → executed; Backup syncing → connected; Restore validating → review → restoring → done. Drive these from the simulators, not from `Future.delayed` inside widgets.

---

## 12. Code quality rules

- No business logic in `build()`. No `setState` for shared state.
- No hard-coded strings, colours, sizes or numbers in screens. Use theme tokens, `AppSpacing`, formatters.
- Every list of rows or cards comes from a provider, never from a literal list in the widget.
- Use `const` constructors, small widgets, named parameters, doc comments on public classes.
- Handle loading, empty, error and offline states for every data-backed screen.
- Accessibility: tap targets at least 48 px, contrast per theme, semantic labels on icon buttons.
- `flutter analyze` at zero issues. No `// ignore` without a reason.
- One commit per phase with a clear message.

---

## 13. Tests

- Unit: permission rules (full table), bill estimator, session energy, AI coverage gates, schedule validator, command lifecycle, QR validation against identities.
- Widget/golden: every shared component in every variant, plus these screens in light and dark: Dashboard, Device detail, Remote control (all states), Schedule editor, History, Billing, AI Energy, Settings (Owner and Family).
- Integration: sign in → add socket → control → schedule → backup → restore, and the Family restriction flow.

---

## 14. Phases

1. **Audit and docs:** `GAP_REPORT.md`, `ARCHITECTURE.md`, `SCREEN_MAP.md` (table of section 7 with status per screen).
2. **Foundations:** folder structure, theme tokens from Figma variables, router skeleton, fonts, icons.
3. **Shared components** (section 4.2) with golden tests.
4. **Domain + mock database:** models, repository interfaces, drift DB, JSON seeds, simulators, scenarios, `MOCK_DATA.md`.
5. **Auth + Dashboard + More + bottom nav.**
6. **Devices + Add socket + Safety limits.**
7. **Appliances + Move wizard + Remote control.**
8. **Scheduling + History + Alerts.**
9. **Billing + AI + Backup/Restore + Settings.**
10. **Family role everywhere** (section 9) and **Developer mode** (section 8) including Mock controls.
11. **Polish:** compare every screen with its Figma screenshot, dark theme, empty/error states, accessibility, final tests.

Stop at the end of each phase, summarise, and wait for my "continue".

---

## 15. Definition of done (per screen)

- [ ] Matches the Figma screenshot (spacing, colour, type, radius, icon, button placement), light and dark.
- [ ] All Figma state frames for this screen are reachable through a mock scenario.
- [ ] Uses shared components only; no copy-pasted styling.
- [ ] No data or strings inline; data comes from provider → repository → mock DB.
- [ ] Owner and Family behaviour correct (section 9).
- [ ] Loading, empty, error and offline states handled.
- [ ] File is in the correct feature folder with the "Implements Figma frame" comment.
- [ ] Tests added; `flutter analyze` clean.

---

## 16. First actions (do these now)

1. Read `docs/COPILOT_PROMPT.md` (this file) and Figma page **00 Flows**.
2. Inspect the current codebase. Write `docs/GAP_REPORT.md` with: every Figma screen and its status (missing / wrong / ok), missing components, missing Family and Developer features, where data is hard-coded, and a proposed move/rename plan for the folder restructure.
3. Do **not** change code yet. Show me the report and the plan, then wait for approval to start phase 2.
