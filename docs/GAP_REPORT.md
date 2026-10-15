# SEMS Flutter frontend gap report

## Audit scope and evidence

This is the Phase 1 audit snapshot. The source tree was inspected and the Figma file's
`00 Flows` page and page index were read through Figma metadata. The page index
lists 164 prototype screens across the 15 product pages. The flow map covers:
first launch/sign-in, add socket, remote control, control failures, move
appliance, schedules, history/billing/AI, backup/restore, Family role, and
hidden Developer mode.

Existing screens and interactions were also checked against
[`screen-inventory.md`](./screen-inventory.md). The codebase currently has
27 Dart files, 1 widget-test file, an in-memory mock repository, and no
feature-first/router/domain/database structure. Visual parity is **not
verified**: there has not been a frame-by-frame screenshot comparison against
a running Android build. Consequently, “implemented” below means functional
coverage indicated by the current UI/code and inventory, not pixel-perfect
approval.

### Status key

- **Partial** — some screen or flow behavior exists, but specified states,
  structure, role behavior, or service-independent logic are incomplete.
- **Missing** — no corresponding implementation exists, or the behavior is
  absent.
- **Unverified** — the feature exists but exact visual parity/accessibility has
  not been compared to the Figma frame.

The findings below preserve what the project looked like during the Phase 1
audit; read the implementation update at the end for work completed since then.
All implemented screens remain visually **Unverified** until the Phase 11
comparison. No backend/server code should be introduced.

## Screen and flow gaps

| Figma page / screen set | Current implementation | Gaps and differences |
|---|---|---|
| 00 Flows — ten end-to-end flows | Partial | Figma links splash→auth→dashboard; an eight-step add-socket flow; control acknowledgement; control failure; move; schedules; history/billing/AI; backup/restore; Family restrictions; hidden Developer entry. Most have demo UI routes, but there is no Figma prototype interaction-by-interaction audit, no unified route map, and several transitions/state paths are only previews. |
| 01 Auth — 15 screens | Partial | Splash, five onboarding slides, sign-in/up, local validation, forgot-password, verification, and selectable sign-in error previews exist. Splash uses a local delay and does not inspect persistent session/database state. Developer entry by long-pressing the Sign-in logo is missing. Resend countdown and exact error/banner treatments need verification. |
| 02 Dashboard — 8 screens | Partial | Main, empty-socket, and learning-coverage views exist. Dark theme, safety-trip state/countdown, filter sheet (room/socket/appliance/date range), and alert heads-up overlay are missing or incomplete. Figma dashboard metrics/load bars and visual treatment are not yet confirmed against screenshots. |
| More tab | Partial | More/profile/settings navigation exists. The specified six-row layout, dark-mode toggle, exact sign-out behavior, and visual parity are not verified; current dark theme is absent. |
| 03 Devices — 33 screens | Partial | Search, room chips, socket cards, empty/no-match states, device details with six readings/device/diagnostic/manage sections, local rename/room/remove, safety limits, and pairing preview exist. Offline/safety-trip/Family detail variants, signal/last-seen fidelity, Wi-Fi confirm/details flow, ownership transfer flow, remove online/offline variants, and NAV/OK configuration-menu guidance need work or verification. Pairing is consolidated into a simulated screen rather than the specified 8 screens; each of the eight error cases and claim-code validation against identities are incomplete. |
| 04 Appliances — 14 screens | Partial | Appliance records now drive active/archived lists; the eight-category add form validates names and power, assigns an online socket without creating a socket record, and warns when its occupant will be unassigned. Archive retains energy history and closes the session; moving onto an occupied socket closes both prior sessions and starts the moved appliance at the destination meter. Family gate, every overview variant, and exact frame comparison remain. |
| 05 Control — 12 screens | Partial | The screen now consumes the local command simulator for pending/acknowledged/executed, failed, expired, offline, and safety-blocked outcomes; failed outcomes do not alter relay state. Emergency OFF has its own confirmation and persists high priority. Preset/custom timers count down to local OFF. Family/last-command history fidelity and exact screen-state comparison remain. |
| 06 Scheduling — 14 screens | Partial | Drift-backed list/editor, pause duration/resume, countdown expiry via the local command simulator, one-time dates, repeat types, multiple/overnight intervals, day validation, overlap checks, waiting-for-time-sync, enabled state, delete, and manual-override preference are implemented. One-time and recurring schedule execution, background execution, and exact Figma parity remain open. |
| 07 History — 7 screens | Partial | Range-specific local example data, appliance weighting, selectable chart bars, coverage, sessions, empty state, and CSV/Excel-compatible CSV/JSON/PDF-ready clipboard actions are implemented. Measured gap detection/overlay and exact session/metric calculations remain open; PDF currently copies a printable text summary rather than generating a PDF file. |
| 08 Alerts — 7 screens | Partial | All/Electrical/Energy/Connectivity/Automation/AI filters and counts, AI sample alerts and estimated/quiet-hours notices are implemented. Acknowledgement and overall/per-appliance power limits plus quiet-hour preferences persist in local Drift. Push notifications, live alert generation, complete detail variants and exact visual parity remain open. |
| 09 Billing — 5 screens | Partial | Billing now reads seeded bills and tariff settings through the local Drift repository. Progressive slab/fixed/duty calculation, budget progress, measured/estimated/billed current-period values, last-bill comparison, tariff summary/edit validation, and persisted add-bill records are implemented. Family read-only treatment and exact Figma visual parity remain gaps; no utility or backend integration was added. |
| 10 AI — 6 screens | Partial | Coverage variants (2/5/10/45 days), forecast/insights and preferences are represented. Coverage gates (under 3, 3–7, 7+, 30+, 60–90 days), uncertainty band, peak periods, appliance baselines, estimated labels/severity restrictions, calculations from history, and visual parity need verification. |
| 11 Backup — 18 screens | Partial | Local connect/backup/verify/restore preview and several error states exist. This is not a persistent local DB or Drive simulator; Family lock replacement, last-sync/pending count, Drive account states, validation/checksum/conflicts, merge vs import-as-new, duplicate-batch handling, and full error matrix remain incomplete or unverified. |
| 12 Settings — 12 screens | Partial | Profile, notifications/quiet hours, family settings, storage/privacy/developer navigation, sign-out and delete-account dialogs are represented. Persistent settings state, full Family permission table, invite/remove member dialogs, owner-only delete enforcement, and exact Figma screen/sheet treatments need verification. |
| 13 Family variants — 6 screens | Partial | A mutable owner/member demo role and several hidden/disabled controls exist; safety limits are read-only. No centralized permission rules, repository-level enforcement, route guard, permission table, consistent RoleBadge, or all four specified gate treatments exist. |
| 14 Developer — 7 screens | Partial | A basic DeveloperTools screen with an in-memory identity list/create/revoke preview exists. It is exposed from Settings rather than a hidden Sign-in-logo long press. Developer credentials/repository, identity statuses and serial/model/claim/MQTT credentials, one-time secret reveal, regenerate/revoke/delete lifecycle, confirmation, and Mock controls/scenarios are missing. |
| 15 Prototype (clickable) — 164 screens | Partial | Existing flows can be reached through imperative `Navigator` routes and a bottom-tab shell. No GoRouter route constants/guards or exhaustive prototype reaction audit exists. Screen links and state reachability are not tested comprehensively. |

## Missing or incomplete shared design-system components

The app has basic `AppCard`, `PageHeading`, `SectionTitle`, `MetricCard`, and
`EnergyBars` primitives in one shared file. Some screens still use Material
controls directly. The following components/variants from the master prompt
are missing as reusable components or not complete:

- **Theme/tokens:** `AppColors` ThemeExtension with light/dark states, complete
  status palette/tints, radii, spacing, typography, and shadows. Existing
  `SemsColors`/`SemsSpace` are a small set of static light tokens.
- **Controls:** variant-complete AppButton, AppChip, AppSegmented, AppToggle,
  AppCheckbox, AppRadioCard, AppTextField.
- **Status/content:** StatusBadge, RoleBadge, AppBanner, accent AppCard,
  SettingsGroup, AppRow, SectionHeader, MetricTile (measured/estimated/billed),
  EstimatedBadge, AppProgressBar, SignalBars, ApplianceIcon.
- **Navigation/sheets:** AppTopBar with role badge, AppBottomNav, standard
  AppBottomSheet and AppDialog, AppToast.
- **States/flows:** EmptyState, ErrorState, StepBar, PowerControl as a reusable
  stateful control, LoadBars, EnergyBarChart/AreaChart with forecast band and
  data-gap overlay, AlertCard, InsightCard, QrScannerView, PermissionGate.
- Component-level golden tests and screen light/dark golden tests are absent.

The design calls for Lucide-style line icons. The project has selected Figma SVG
assets, but a complete consistent icon treatment has not been audited.

## Family and Developer

### Family

- `DemoSession` is a global `ValueNotifier` with owner/member values rather
  than a signed-in-user/domain role model.
- Role checks are scattered across widgets; some buttons are disabled/hidden,
  but the policy table is not centralized.
- There is no `PermissionGate`, `can(Role, Permission)`, repository-level
  `PermissionDenied`, or deep-link/route guard.
- Read-only Safety limits exists; Billing, Family list, Backup, Add appliance,
  move/archive, tariff, delete-account, and schedule paths need a complete
  permission audit.
- Consistent Owner/Family badges on all relevant top bars are absent.

### Developer mode

- Existing screen is a basic local demo, not a production-shaped identity
  feature/repository.
- The entry point is incorrectly visible in More; required hidden gesture on
  Sign-in logo is absent.
- No mock controls/scenario switcher or identity-to-pairing validation.
- It must remain a frontend-only mock; no firmware/backend work is requested.

## Data, architecture and hard-coded values

- `MockSemsRepository` stores device data in a Dart list for the process
  lifetime; there is no SQLite/drift DB, JSON mock seed, or reset-mock-data
  flow.
- One `SemsRepository` interface sits beside the mock implementation in the
  data layer. Domain repository/service interfaces and feature providers are
  absent; widgets/screens instantiate or receive the concrete mock.
- Names, IDs, power/energy values, tariff/bill numbers, schedules, categories,
  validation limits, sample alerts, identities, and chart series occur in
  Dart screen/model/repository files instead of `assets/mock/*.json`.
- Screen files own UI state and behavior through `setState`; navigation,
  business rules, and simulations are not separated into use cases/services.
- There are no telemetry, command, pairing, backup, or AI simulators as
  reusable services. Several transitions use timers/delays in screens.
- No app-level error/result convention, clock or ID service, shared formatter
  or validator modules exist.

## Folder and rename plan (no source moves made in Phase 1)

Preserve behavior and public flows while migrating in small, compilable
feature groups. Do not delete or mass-rename files in one operation.

1. **Foundation first:** add `lib/app/` for `SemsApp`, router and route
   constants; split `core/theme/` tokens, constants, errors, utils and service
   contracts. Keep `main.dart` as the bootstrap.
2. **Domain/data boundary:** add pure-Dart `domain/models`, `enums`,
   `repositories`, `services`, and `usecases`; move the current model concepts
   out of `data/models/sems_models.dart`. Introduce mock repository
   implementations in `data/mock/` behind providers. Replace in-memory
   storage with Drift plus JSON seeding only after foundations/tests are ready.
3. **Extract shared widgets:** split `shared/widgets/sems_widgets.dart` by
   component and preserve small compatibility exports during migration to
   avoid broad import breakage.
4. **Migrate features incrementally:** move `features/views/onboarding_screen`
   and auth classes from `auth_screens.dart` to `features/auth/presentation/`;
   shell from `features/shell/` to app navigation; then dashboard, devices +
   pairing + safety, appliances/control, scheduling/history/alerts,
   billing/AI/backup, settings, and developer. Split `more_screens.dart` by
   feature and extract sheets/dialogs to their feature `sheets/`.
5. **Tests alongside each move:** preserve/expand widget coverage, add
   unit/golden/integration tests as responsibilities move, and delete old
   files only after imports and tests point to replacements.

Suggested feature destinations and screen statuses are in
[`SCREEN_MAP.md`](./SCREEN_MAP.md). Current architecture and target boundaries
are documented in [`ARCHITECTURE.md`](./ARCHITECTURE.md).

## Phase 1 audit checklist

Phase 1 deliverables are the three audit documents only:

- [x] Inventory existing screens, data boundaries, and Figma 00 Flows.
- [x] Create this gap report.
- [x] Create architecture baseline/target.
- [x] Create screen-by-screen status map from master prompt section 7.
- [x] User approved phased implementation after the audit.

## Implementation progress through Phase 9

- **Phase 2 — Foundations:** complete. Riverpod scope, GoRouter entry/auth
  routes, theme tokens, fonts, constants, and shared validators/formatters are
  in place. Feature navigation and role guards remain incomplete.
- **Phase 3 — Shared components:** complete. The reusable component library
  and 70 light/dark component goldens are in place. Full-screen parity remains
  unverified.
- **Phase 4 — Domain and local mock data:** complete. Freezed domain records,
  SQLite/Drift storage, JSON seed/reset, typed adapters, local simulators, and
  15 mock scenarios are implemented and tested.
- **Phase 5 — Auth, Dashboard, More, and bottom navigation:** core data
  integration complete. The five-tab shell now receives one Drift-backed
  repository, with persistence tests for device state and edits. Auth remains
  a local preview and some More destinations retain inline sample values;
  complete phase behavior and visual parity are still in progress. Verification
  passes `flutter analyze --no-pub` and all 109 Flutter tests.
- **Phase 6 — Devices, Add socket, and Safety limits:** core local integration
  complete. Device telemetry and socket status hydrate into the UI; safety
  limits persist to local Drift records; pairing validates the seeded identity
  and claims the existing socket. Detailed screen-state and visual parity,
  camera/network integration, and full Family permission enforcement remain
  open. No backend or remote service was added.
- **Phase 7 — Appliances, Move wizard, and Remote control:** core local
  workflows complete and verified. Appliance creation/archive/rename are
  repository-backed; occupied-socket moves preserve both appliance histories
  and close/open meter sessions; remote commands use the existing simulator;
  timer and high-priority emergency OFF are local-only. Exact Figma comparison,
  Family variants, and remaining state-specific visual polish remain open.
- **Phase 8 — Scheduling:** core local workflows complete and verified. The
  schedules list/editor reads and writes persisted Drift records, including
  one-time dates, countdown duration, recurring days, multiple intervals,
  overnight next-day flags, manual-override preference and enabled state.
  Pause durations/resume and per-socket clock-sync state are local as well.
  Countdown expiry uses the local command simulator; recurring schedules are
  stored but not auto-executed. No backend was added.
- **Phase 9 — History and Alerts:** core local UI/data workflows are
  implemented. History has distinct 10-second, minute, hourly, daily, weekly
  and monthly sample series; appliance filtering; chart inspection; metrics,
  coverage; sessions; empty state; and CSV/Excel-compatible CSV/JSON/PDF-ready
  clipboard output. Alerts now includes all six Figma categories, seeded AI
  examples, counts, quiet-hours and estimate banners, locally persisted
  acknowledgements, and persisted alert preferences. Gap detection is not yet
  derived from actual telemetry intervals; PDF output is a printable text
  summary rather than a generated PDF. No backend or push service was added.
- **Backend scope:** unchanged; no server or remote service integration was
  added.
- **Current gate:** Phase 9 implementation is complete and its local behaviors
  and remaining gaps are documented. Do not start Phase 10 until the user asks
  to continue.
