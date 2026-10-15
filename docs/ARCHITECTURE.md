# SEMS frontend architecture audit

## Phase 1 audit baseline

```text
lib/
  app.dart                     # MaterialApp + light theme + splash
  main.dart                    # Flutter bootstrap
  core/
    session/demo_session.dart  # process-global owner/member ValueNotifier
    theme/app_theme.dart       # static light-only SemsColors/SemsSpace
  data/
    models/sems_models.dart    # device, energy, alert, recommendation models
    repositories/sems_repository.dart
                                # interface and in-memory mock implementation
  features/
    shell/app_shell.dart       # five-tab IndexedStack, shared mock repository
    views/*.dart               # screens and multi-screen feature files
  shared/widgets/sems_widgets.dart
                                # a handful of generic Material wrappers
test/
  widget_test.dart             # main existing widget tests
assets/figma/                  # selected local SVG assets
```

At the Phase 1 audit baseline there were no app router, route constants/guards,
provider, domain, local database, seed-data, simulator, scenario, or
feature-specific provider directories. Navigation was primarily imperative
`Navigator` pushes. The bottom-tab shell created one `MockSemsRepository`, and
several stateful screens owned both view state and demo business behavior.

## Phase 2 foundations (complete)

The app now has a `ProviderScope`, a GoRouter entry-flow skeleton for splash,
onboarding, sign-in/up, verification and the existing app shell, centralized
route names/role redirect foundations, light/dark `AppColors` theme extensions,
typography/radius/spacing/shadow tokens, local Inter and JetBrains Mono font
assets, and shared constants, validators, formatters, clock and ID abstractions.
The entry/auth transitions use the router while existing shell-tab and feature
navigation remain unchanged for later screen-by-screen migration. No backend
or network integration was added.

Figma did not return values for status yellow/orange or every status tint.
Those `AppColors` fields intentionally remain nullable rather than being
invented; exact dark-theme selection is also not wired to a user preference yet.

## Phase 3 shared components (complete)

The Figma shared-widget inventory is implemented as individual files under
`lib/shared/widgets/`, covering button/chip/form controls, badges and banners,
cards/rows/metrics, navigation and modal primitives, empty/error states, charts,
device/appliance controls, and the Family permission gate. The compatibility
library `sems_widgets.dart` exports the new components while preserving the
existing heading, metric-card and chart wrappers for screens not yet migrated.
`test/golden/shared_components_test.dart` provides 35 component fixtures in
both light and dark themes; all 70 component goldens are checked in under
`test/golden/shared_components/`. Existing screens have not yet been migrated
to the individual components as a group; that remains part of their feature
phases. Full-screen Figma screenshot comparison is still pending.

## Phase 4 domain and local mock data (complete)

`lib/domain/` now holds Freezed/JSON immutable records, repository contracts,
and pure-Dart billing, schedule, AI-coverage, and QR-claim rules. Drift stores
collection-scoped JSON records in a local SQLite table; typed repository
adapters decode domain records, and `MockSeeder` loads the checked-in
`assets/mock/*.json` baseline and resets it transactionally. Riverpod exposes
the database-backed mock data store. Local command, telemetry, pairing, and
backup simulators plus 15 scenario presets operate without remote services.
The generic collection table is intentional. Phase 5 now adapts persisted
socket, history, alert, and AI records to the existing `SemsRepository`
contract and injects that adapter into the five-tab app shell. Dashboard and
More navigation therefore share locally persisted data; auth remains a
local-only preview, and several More destination screens still contain sample
values pending their feature phases. Details and seed instructions are in
`docs/MOCK_DATA.md`.

## Phase 5 Auth, Dashboard, More, and navigation (core integration complete)

`DriftSemsRepository` hydrates owned sockets, range-specific history, coverage, alerts,
and AI recommendations from seeded Drift records. Device state, add/remove,
rename, room assignment, appliance rename, and appliance moves write back to
the local store. Unclaimed pairing candidates remain in pairing data but are
not counted as owned devices. `semsRepositoryProvider` seeds and exposes the
adapter; `AppShell` now handles its loading/error states and shares the
resolved repository across Dashboard, Devices, History, Alerts, and More.
There is no backend/network integration.

History range samples and alert records are local JSON/Drift data. Alert
acknowledgements and alert settings use local collections; exports copy
CSV/Excel-compatible CSV/JSON data or a printable text summary to the clipboard.
There is no cloud export, generated PDF, push service, or measured telemetry-gap
detector in this preview.

The existing auth screens are unchanged local previews rather than backed by
the seeded auth collection. More and its destination screens are only partly
data-driven. Screen-by-screen design parity is not signed off; these limits
are tracked in `SCREEN_MAP.md`. Phase 5 verification passes `flutter analyze
--no-pub` and all 109 Flutter tests.

The auth flow, account/demo actions, developer tool, alerts, settings values,
and schedule examples include literals in Dart. Billing records and tariff
settings are seeded from JSON and exposed through typed local Drift
repositories; bill estimates are calculated locally from the persisted slabs.
Most
service-dependent actions are explicitly local previews; no server/backend
integration is part of the current implementation or this project scope.

## Phase 6 Devices, Add socket, and Safety limits (core integration complete)

The UI repository hydrates live telemetry, meter/session totals, signal,
last-seen, safety-trip state, and safety limits from the local Drift records.
Safety-limit edits are validated in the screen and persisted on the existing
socket record. Pairing runs through `PairingSimulator` and validates the
six-digit code against the local developer identity records; a successful
claim updates the seeded socket and identity rather than inserting a duplicate
socket. Offline and safety-trip detail states use the hydrated local values.
No Bluetooth, Wi-Fi, cloud, or backend calls are made.

Phase 6 checks pass `flutter analyze --no-pub` and the focused data/widget test
suites. Detailed Figma screenshot parity, full permission enforcement,
camera/network implementations, and some manage-sheet variants remain open;
see `SCREEN_MAP.md`.

## Phase 7 Appliances, Move wizard, and Remote control (core integration complete)

Appliance list/detail/add/archive/rename state is exposed through
`SemsRepository` and persists in the local Drift collections. Creating an
appliance does not create a socket: an optional existing online socket can be
assigned, and an occupant is detached after its active meter session is closed.
Moves onto occupied sockets close both appliances' prior sessions, preserve
the displaced appliance history, and start the moved appliance at the
destination meter. Remote control consumes `CommandSimulator` progress through
the repository; local pending/acknowledged/executed/failure/expiry/safety states
do not update relay state before execution. Emergency OFF is separately
confirmed and records high priority; timer selections run a local countdown
and issue OFF without a backend.

Phase 7 analyzer and targeted/full tests pass. The web target remains a local
preview only. Family policy coverage and exact frame-by-frame Figma parity
remain tracked in `SCREEN_MAP.md`; no backend or remote-service integration
was added.

## Phase 8 Scheduling (core local workflows complete)

`SchedulesScreen` uses the same local `SemsRepository` adapter as the app shell.
The typed `ScheduleRecord` persists its target appliance/socket, schedule kind,
date or countdown duration, selected weekdays, one or more intervals,
overnight/next-day behavior, enabled state, and manual-override preference.
The editor runs the domain schedule-window validator across intervals and
enabled schedules on the same appliance. Pause-all duration and explicit
resume persist in a separate local Drift collection; socket clock-sync state
drives the waiting-for-time-sync banner.

Countdown expiry sends OFF through the existing local command simulator and
persists completed/failed state; expiry is checked while the schedule screen
is active and when it is reopened. One-time and recurring schedule windows
remain stored and visible but are not automatically executed. No firmware commands,
network calls, or backend integration were added. Exact Figma frame parity and
background recurring execution remain open.

## Target architecture from the master prompt

```text
presentation/screens, widgets, sheets
                 │
                 ▼
feature providers ──► domain use cases/models/repository interfaces
                                      ▲
                                      │
              data/mock repositories + simulators
                         │            │
                         ▼            ▼
                    Drift DB     JSON mock seeds
```

`main.dart` should remain a small bootstrap. An app/router layer owns route
names, shell navigation, auth/role/developer redirects. The domain remains
Flutter-independent. Screens render provider state and forward user actions;
they do not depend on `data/`. Mock repositories enforce the same domain
contracts and permissions intended for a later backend. The only
infrastructure in this target is local/mock; no remote backend is to be added.

## Staged transition plan

1. **Foundation (complete):** add app/router, route constants, theme token extension,
   typography/radii/spacing/shadows, constants, validators, formatters, clock
   and ID abstractions. Preserve the current entry screen and shell while
   routing is introduced.
2. **Shared components (complete):** split the existing shared widget file into the
   specified reusable component files, starting with compatibility exports.
   Add component widget/golden coverage.
3. **Domain and mock data (complete):** define immutable domain types, interfaces and
   usecases. Move seeded examples into JSON; introduce Drift database and
   migrations/seeding; provide repositories through Riverpod providers.
   Add command, telemetry, pairing, backup and AI simulators plus scenarios.
4. **Feature migration:** migrate one phase at a time as listed in the master
   prompt. Keep existing public behavior while relocating screens, view-only
   widgets, sheets and dialogs to their feature.
5. **Permission and visual pass:** centralize Owner/Family decisions and
   enforce them in providers/repositories/routes. Compare every screen with
   its Figma reference in light and dark themes and add accessibility and
   test coverage.

## Constraints and risks

- The prompt describes a broad structural/data migration. Avoid combining
  folder moves with behavioral redesign in one untestable change.
- Preserve the existing app and tests between steps; each phase should remain
  analyzable/runnable.
- Every data-backed screen needs loading, empty, error, offline and role
  states appropriate to its flow.
- Keep all network/firmware/Drive/auth operations simulated. A future backend
  is a replaceable adapter, not a reason to add server code now.
- Exact colors and visual values must be taken from Figma variables/screens,
  not inferred from existing Flutter approximations.
- One prompt conflict was found: it labels Developer mode “currently
  missing,” while the code has a basic local `DeveloperToolsScreen`; audit
  status is therefore **Partial**, not Missing. It is linked in Settings
  rather than using the required hidden entry, and does not meet the required
  identity lifecycle.
