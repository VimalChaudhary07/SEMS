# SEMS screen inventory and navigation

## Figma access

The authenticated Figma MCP was tested successfully. It created a file session, listed metadata, and returned design context with screenshots for the dashboard, onboarding, devices, appliances, schedules, history, alerts, billing, AI, settings, More, and the flow map. The file contains 18 top-level pages: Cover, Design System, Flow map, Auth, Dashboard, Devices, Appliances, Control, Scheduling, History, Alerts, Billing, AI, Backup, Settings, Family variants, Developer, and Prototype. The clickable Prototype page is identified in the Figma flow map as the main place to inspect the end-to-end prototype.

The design system defines Inter typography, a 4 dp spacing grid, 8/12/20 dp corner radii, and light/dark token modes. The Flutter theme includes the inspected light palette and spacing. Figma SVGs for the five bottom navigation icons, onboarding socket illustration, and control power/timer/emergency icons are checked into `assets/figma/` and used locally.

## Prototype flows from the Figma flow map

| Flow | Figma sequence | Frontend entry |
| --- | --- | --- |
| First launch and sign in | Splash → 5 onboarding pages → Sign in / Sign up → Verify email → Dashboard | App launch; Skip or Next; local auth forms; demo entry |
| Add a socket | Scan QR → Confirm → Security → Wi-Fi → Pairing mode → Bluetooth/connect → Claim → Name and room | Devices → plus → eight-step simulated socket setup |
| Remote control | Dashboard/device → Control → Pending → Acknowledged → Executed ON/OFF | Appliance power action or Device detail → Socket control |
| Control failures | Failed / Expired / Offline / Safety trip → retry or reason | Control screen state menu and offline sample device |
| Move an appliance | Overview → Close session → Choose socket → Review → Done | More → Appliances → appliance → overflow menu → Move |
| Schedules | List → New/Edit → Type/days/intervals → overlap check → save | More → Scheduling; create, pause, resume, delete |
| History, billing, AI | Range/appliance filter → Export → Billing → AI coverage and insights | Bottom tabs History; More for billing and AI |
| Backup and restore | Connect → Backup/Verify → Find → Validate → Review → Restore → Done | More → Backup and restore; all states simulated locally |
| Family role | Family sign-in → read/control screens → owner-only actions blocked | Settings → Family and permissions → Preview as family member |
| Developer mode | Hidden login → Identities → Create/Revoke/Delete | Settings → Developer tools; demo code `DEMO` |

## Implemented screens and interactions

- **Onboarding and auth:** five onboarding slides; sign in, sign up, verification, forgot-password sent state, field validation, demo-only sign-in error previews, and enter-as-demo actions.
- **Dashboard:** Figma-style total-power/load card, energy/bill metrics, offline banner, AI insight cards, room filters, appliance controls, and overview/saving cards.
- **Devices and sockets:** searchable device list with room filters, online/offline and power states, empty/no-match states, and an owner-only add entry; device detail with live-reading, device, diagnostic, and manage sections; remote-control navigation; owner-only local rename, room assignment, Wi-Fi setup preview, transfer preview, and remove actions; safety limits and socket-button guidance; eight-step pairing preview with Wi-Fi validation, scan/connect timing, manual entry, and selectable setup errors. Rename, room assignment, removal, and control update only the shared in-memory demo repository.
- **Appliances:** active and archived examples, local add/rename/archive actions, overview/history, and a four-step move flow that updates the in-memory device-appliance association.
- **Control:** tap power, confirm, simulated Pending → Acknowledged → Executed progression, auto-off timer, emergency OFF, offline blocking, and preview controls for Failed, Expired, and Safety trip states.
- **Schedules:** local schedule list, enabled state, pause/resume all, create form, daily/weekday/weekend/one-time repeat, start/end time pickers, overlap feedback, and empty state after deletion.
- **History:** time-range and appliance filters, usage/cost/runtime summaries, sample sessions, device details, and CSV/JSON/PDF export confirmations.
- **Alerts:** All/Electrical/Energy/Connectivity/Schedule filters, critical/warning/info cards, alert details, acknowledgement, settings toggles, and empty states for categories without alerts.
- **Billing:** estimate, editable tariff/budget and billing day, validation, and local actual bill records with an add-bill form.
- **AI Energy:** 45/10/5/2-day coverage states, forecast, peak periods, anomaly/waste/savings detail sheets, appliance baselines, and AI preference controls.
- **Backup and restore:** simulated Drive connect/disconnect, manual backup contents, progress/verify result, five-step restore, and no-backup/schema/checksum/account error previews.
- **More, profile, and settings:** navigation to appliances, schedules, billing, AI, backup, profile, help, notification rules/quiet hours, family permissions, storage/retention, privacy/export, and developer identity screens.
- **Family role:** role preview toggles app state; device add, appliance changes, billing edits, backup, and developer-only actions are restricted in the demo member view.

All service-dependent behavior is an in-memory simulation. There is no Firebase, MQTT, cloud backup, real QR camera, utility account, push notification, persistent local database, or AI inference.

## Remaining differences from the Figma file

The primary product flows and the inspected empty/learning dashboard states are represented in the Flutter frontend, but this is not a claim of exact pixel parity across every frame in the 18-page Figma file. In particular, the dark theme is not implemented, Inter and JetBrains Mono font files are not bundled, and several prototype-only or account/device service flows are local previews rather than connected functions. The device detail screen now includes the live-reading, device, diagnostic, safety, and manage sections; Wi-Fi setup and ownership transfer are clearly presented as previews and do not contact a device or server. Figma references have been inspected, but screenshot comparison against a launched Android build and a complete frame-by-frame visual audit remain outstanding.

## Motion inspection and implementation

`get_motion_context` returned no keyframe/timeline nodes for the Control ON, Pending, Acknowledged, or OFF frames. The Figma flow map describes these as prototype transitions, so the Flutter preview animates the matching state changes locally: the socket halo and button color, a short button pulse, crossfading ON/OFF labels and status banners, the pending ring/progress, onboarding slide changes, dashboard status updates, and chart bar entry. Durations use local Flutter transitions and honor the platform reduced-motion setting; they are not values recovered from a Figma keyframe timeline.

The Figma MCP limitation for Smart Animate is:

> Prototype interactions aren't currently supported in MCP. Keyframes on the canvas are visible, but not the smart animate interactions between frames or their transition settings. Code generated from this selection will represent the start and end states, not the transition between them.
