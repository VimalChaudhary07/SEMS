# SEMS local mock data

Phase 4 adds an offline-only data layer. It does not make HTTP, Firebase,
Bluetooth, Google Drive, or other server/service calls.

## Storage and repository flow

`MockDatabase` (`lib/data/local/mock_database.dart`) uses Drift and SQLite.
Native app builds keep `sems_mock.sqlite` in the application documents folder;
tests can inject an in-memory executor. The `mock_records` table is a
collection-scoped JSON record store with `(collection, record_id)` as its
composite primary key. `DriftJsonRepository` provides the collection contract,
while `TypedJsonRepository<T>` decodes immutable Freezed domain records.
`MockRepositories` exposes one repository per domain area and typed accessors
for the currently modeled records.

Riverpod exposes the database through `mockDatabaseProvider`. The first
`mockDataStoreProvider` read seeds JSON assets in a transaction; errors are
propagated rather than replaced with fallback data. `MockSeeder.seedIfNeeded`
checks `_meta/seedVersion`; `MockSeeder.reset` replaces local mock data with the
checked-in baseline. A seed-version upgrade adds records that are missing from
the new baseline without overwriting existing local edits.

## Seed assets

| Asset | Collection | Contents |
|---|---|---|
| `assets/mock/users.json` | users | Owner and Family demo accounts |
| `assets/mock/sockets.json` | sockets | Three claimed sockets and one unclaimed pairing socket |
| `assets/mock/appliances.json` | appliances | Heater, fan, refrigerator, and archived water-heater records |
| `assets/mock/sessions.json` | sessions | Active meter sessions; session kWh is the meter difference |
| `assets/mock/schedules.json` | schedules | Weekday heater and overnight fan schedules |
| `assets/mock/alerts.json` | alerts | Electrical, energy, connectivity, and automation examples |
| `assets/mock/backup.json` | backup | Initial optional Drive status |
| `assets/mock/billing.json` | bills | July–September 2026 bill records |
| `assets/mock/tariff.json` | tariffs | INR slab rates, fixed charge, duty, budget, and billing day |
| `assets/mock/ai.json` | ai | Estimated savings and insight examples |
| `assets/mock/identities.json` | identities | Claimed and unclaimed local socket identities/claim codes |
| `assets/mock/history.json` | history | Coverage, dashboard aggregates, and sample daily history |
| `assets/mock/telemetry.json` | telemetry | Initial timestamped socket telemetry samples |
| `assets/mock/family.json` | family | Family member and demo permissions |
| `assets/mock/settings.json` | settings | Theme, notification, quiet-hours, and retention preferences |
| `assets/mock/scenarios.json` | scenarios | The available demo scenario catalog |
| `assets/mock/scenario_overrides.json` | N/A | Scenario-specific local record overrides |

The example tariff calculates 232 kWh as ₹1,704 energy charges, ₹120 fixed
charge, and ₹36.48 duty, for an estimated total of ₹1,860.48. Billed values in
the seeded records remain separate from estimates.

## Simulators and domain rules

- `TelemetrySimulator.emitOnce()` writes a typed sample for each online socket;
  `start()` schedules it at the ten-second demo cadence. It keeps per-socket
  sequence numbers and uses cumulative meter kWh, not the separate today total.
- `CommandSimulator` emits `pending → acknowledged → executed`; failed and
  expired commands do not change the relay, offline sockets reject the command,
  and a safety trip blocks ON. Emergency OFF is recorded with high priority.
  It reads the `_meta/commandMode` override when a scenario repository is
  supplied.
- `PairingSimulator` models the eight pairing steps and eight error outcomes.
  `QrClaimService` validates six-digit codes against the seeded developer
  identity repository before pairing continues.
- `BackupSimulator` reports upload/restore progress and account, upload,
  schema, checksum, and no-backup outcomes. It simulates Drive only.
- `AiEngine` enforces learning (<3 days), anomaly (3–6), forecast (7–29),
  monthly forecast (30–59), and pattern (60+) gates. Every analysis is marked
  estimated.
- `estimateBill` applies progressive tariff slabs, fixed charge, then duty.
- `validateScheduleWindows` checks time/day validity and overlapping intervals,
  including overnight windows crossing to the next day.
- Scheduling UI saves typed `ScheduleRecord` values to the local Drift
  collection, including multiple intervals, one-time dates, countdown duration,
  overnight next-day semantics, and manual-override preference. Holiday pause
  state is stored in a separate local collection; socket `clockSynced` state
  drives the editor's waiting-for-time-sync banner. Countdown expiry submits
  an OFF action through the existing local command simulator and persists its
  completion/failure; recurring windows are not auto-executed.

## Scenario presets

`MockScenarioController.activate` reloads the baseline dataset and then applies
the selected override so presets do not leak state into one another.

| Preset | Demonstrates |
|---|---|
| `normal` | Default owner and connected devices |
| `socketOffline` | Offline socket values and last-seen banner |
| `safetyTrip` | Relay locked off with a trip reason/countdown |
| `learning2Days` | Learning-only AI gate |
| `basic5Days` | Anomaly-check gate |
| `good10Days` | Forecast gate |
| `strong45Days` | Monthly forecast gate |
| `emptyNoSockets` | Empty socket list |
| `emptyNoAppliances` | Empty appliance list |
| `driveNotConnected` | Optional backup not connected |
| `driveFailed` | Backup failure with pending items |
| `commandFails` | Next command fails |
| `commandExpires` | Next command expires |
| `familyUser` | Family demo identity selected |
| `ownerUser` | Owner demo identity selected |

### Adding a seed record or scenario

1. Add a record with a unique non-empty `id` to the appropriate JSON asset.
2. If the shape changes, update its Freezed model and regenerate with
   `dart run build_runner build`.
3. For a scenario, add its catalog record to `scenarios.json`, add its enum
   value to `MockScenario`, and define collection/id overrides in
   `scenario_overrides.json`. Use `null` to remove a seeded record.
4. Add a focused test in `test/data/mock_data_test.dart`, then run the
   targeted tests, `flutter analyze`, and the full test suite.

## Feature integration status

The five-tab app shell resolves one Drift-backed `SemsRepository` for the
Dashboard, Devices, History, Alerts, and More tabs. Devices reads seeded
telemetry and local socket status; safety limits are stored on the socket
record. Pairing uses `identities` to validate and claim the existing unclaimed
socket without creating a duplicate ID. Appliances use the `appliances` and
`sessions` collections for assignment, archive, and meter-boundary movement.
Remote control uses `CommandSimulator`, and timer expiry submits a local OFF
command. History range series are seeded in `history.json`; alert records and
alert preferences/acknowledgements persist locally in Drift. History exports
copy generated CSV/Excel-compatible CSV/JSON or printable summary text to the
clipboard. Other destinations may still use local preview values. The data
integration and tests do not constitute full Figma screen parity; see
`SCREEN_MAP.md`.
