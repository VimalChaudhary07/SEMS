# SEMS frontend preview

Android-first Flutter UI for the Smart Energy Monitoring System. The frontend is designed to be explored without a backend: socket readings, identities, schedules, alerts, bills, AI insights, backup, and auth are all sample/local states.

## Run the app

Requirements: Flutter 3.47+ and Dart 3.13+.

```sh
flutter pub get
flutter run
```

To preview the frontend in a browser without Android tooling:

```sh
flutter run -d chrome
```

The app opens on onboarding. Use **Skip → Continue as demo user** or finish onboarding and select **Use without an account** to reach the app. The five bottom tabs are Dashboard, Devices, History, Alerts, and More.

## Explore the flows

- **Devices:** search, open a device, run a confirmed simulated socket command, or use the plus action for the setup wizard.
- **More:** open Appliances, Scheduling, Billing and tariff, AI energy, Backup and restore, Settings, Profile, and Help.
- **Settings:** preview family permissions/role, notification rules, tariff and budget editing, storage/privacy/export, and Developer tools (`DEMO` is the local developer preview code).
- Device setup, control, backup, restore, error handling, bill entry, schedules, and exports have local demo interactions; none contact a service or physical device.

## Verify

```sh
flutter analyze
flutter test
flutter build apk --debug
```

Widget tests cover tab navigation, socket state confirmation, device detail, More navigation, pairing, and alert filtering/acknowledgement.

## Figma source

The authenticated Figma MCP is available and was used to inspect the SEMS file metadata, design system, screen screenshots, and prototype flow map. See [docs/screen-inventory.md](docs/screen-inventory.md) for the inspected pages, flows, implementation coverage, and remaining visual gaps.

The UI uses Figma navigation, onboarding, and control SVGs stored under `assets/figma/`. The theme tokens are centralized in `lib/core/theme/app_theme.dart`.

## Backend boundary

`SemsRepository` and `MockSemsRepository` separate screen code from sample data. No Firebase, MQTT, time-series database, Google Drive, push service, QR camera, credentials, or AI model is connected. Most demo state lives in memory and resets when the app restarts. The Developer Identity and auth screens are also local previews only.
