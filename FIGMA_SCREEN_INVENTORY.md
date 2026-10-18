# SEMS App V1 - Complete Figma Screen Inventory

**Figma File**: [SEMS-App-V1 (Design + Prototype)](https://www.figma.com/design/iCztQCU9fzB7OITQ0fdxtC/SEMS-App-V1--Design---Prototype-?node-id=0-1&m=dev)

- **Total Canvases / Pages**: 18
- **Total Unique Screens**: 164 screens across 14 functional modules
- **Interactive Prototype**: Canvas `15 Prototype (clickable)` wires all 164 screens together
- **Standard Canvas Frame Width**: 390 px (standard mobile viewport)

## Executive Summary of Screen Classifications

| Category | Count | Key Examples |
| :--- | :---: | :--- |
| **Full Screens** | 97 | Dashboard, Devices List, Device Detail, Settings, History, etc. |
| **Wizard / Multi-Step Flows** | 29 | Add Socket (8 steps), Drive Restore (5 steps), Move Appliance (4 steps), Onboarding (5 steps) |
| **Bottom Sheets (Overlays)** | 16 | Dashboard Filters, Rename Device, Pause Schedule, Export History, Alert Settings |
| **Dialogs / Confirmation Modals** | 9 | Remove Device, Archive Appliance, Emergency OFF, Delete Schedule, Sign Out |
| **Error & Failure States** | 7 | Auth errors, Socket pairing failures (QR, Bluetooth, WiFi), Drive restore errors |
| **Empty States** | 6 | Dashboard empty, Devices empty, Appliances empty, History empty, Alerts empty |
| **Role Variants (Family Mode)** | 18 | Dashboard, Devices, Billing, Settings, Safety Limits in Family permission mode |
| **Theme Showcase (Dark Mode)** | 1 | `Dashboard - dark` (SEMS dark color token mapping showcase) |
| **Splash Screens** | 1 | `Splash` (SEMS animated branding / load screen) |
| **Filter Sheets & Views** | 4 | `Dashboard - filters sheet`, `History - Heater only`, `History - export sheet`, `Alerts tabs` |

---

## Complete List of All 164 Screens by Module

### 01 Auth (15 Screens)

*Splash screen, 5 onboarding slides, email/password authentication, field validation, and recovery flows.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 1 | **Splash** | `11:42` | Full Screen | Light Mode, Splash |
| 2 | **Onboarding 1 - One socket, one appliance** | `11:87` | Full Screen | Light Mode |
| 3 | **Onboarding 2 - See what you really use** | `11:127` | Full Screen | Light Mode |
| 4 | **Onboarding 3 - Control from anywhere** | `11:165` | Full Screen | Light Mode |
| 5 | **Onboarding 4 - Schedules that run offline** | `11:207` | Full Screen | Light Mode, Offline State |
| 6 | **Onboarding 5 - Your data stays yours** | `11:244` | Full Screen | Light Mode |
| 7 | **Sign in** | `11:307` | Full Screen | Light Mode |
| 8 | **Sign up** | `11:368` | Full Screen | Light Mode |
| 9 | **Sign in - field errors** | `11:435` | Error State | Light Mode |
| 10 | **Sign in - wrong password** | `11:502` | Full Screen | Light Mode |
| 11 | **Sign in - email not verified** | `11:563` | Full Screen | Light Mode |
| 12 | **Sign in - no network** | `11:632` | Full Screen | Light Mode |
| 13 | **Forgot password - enter email** | `11:683` | Full Screen | Light Mode |
| 14 | **Forgot password - sent** | `11:758` | Full Screen | Light Mode |
| 15 | **Verify email** | `11:811` | Full Screen | Light Mode |


### 02 Dashboard (8 Screens)

*Primary overview with telemetry widgets, dark mode comparison, learning state, safety trip alerts, and filter sheet.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 16 | **Dashboard** | `13:401` | Full Screen | Light Mode |
| 17 | **Dashboard - dark** | `13:727` | Full Screen | Dark Mode |
| 18 | **Dashboard - learning (2 days of data)** | `13:1013` | Full Screen | Light Mode |
| 19 | **Dashboard - empty (no sockets)** | `13:1091` | Empty State | Light Mode |
| 20 | **Dashboard - safety trip** | `13:1419` | Full Screen | Light Mode, Safety Trip |
| 21 | **Dashboard - filters sheet** | `13:1745` | Bottom Sheet | Light Mode, Filter |
| 22 | **Dashboard - alert heads-up** | `13:2131` | Full Screen | Light Mode |
| 23 | **More** | `13:2327` | Full Screen | Light Mode |


### 03 Devices (33 Screens)

*Socket list, device detail states (online, offline, safety trip), configuration sheets, limits, and full 8-step pairing flow with errors.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 24 | **Devices list** | `14:189` | Full Screen | Light Mode |
| 25 | **Devices list - empty** | `14:277` | Empty State | Light Mode |
| 26 | **Device detail** | `14:570` | Full Screen | Light Mode |
| 27 | **Device detail - offline** | `14:851` | Full Screen | Light Mode, Offline State |
| 28 | **Device detail - safety trip** | `14:1124` | Full Screen | Light Mode, Safety Trip |
| 29 | **Device detail - Family role** | `14:1343` | Full Screen | Light Mode, Family Role |
| 30 | **Device - rename sheet** | `14:1599` | Bottom Sheet | Light Mode |
| 31 | **Device - assign room sheet** | `14:1875` | Bottom Sheet | Light Mode |
| 32 | **Device - socket buttons sheet** | `14:2157` | Bottom Sheet | Light Mode |
| 33 | **Device - change Wi-Fi (confirm)** | `14:2477` | Full Screen | Light Mode |
| 34 | **Device - change Wi-Fi (details)** | `14:2756` | Full Screen | Light Mode |
| 35 | **Device - transfer ownership sheet** | `14:3034` | Bottom Sheet | Light Mode |
| 36 | **Device - remove dialog** | `14:3314` | Dialog | Light Mode |
| 37 | **Device - remove dialog (offline)** | `14:3593` | Dialog | Light Mode, Offline State |
| 38 | **Safety limits** | `14:3654` | Full Screen | Light Mode |
| 39 | **Safety limits - validation error** | `14:3716` | Error State | Light Mode |
| 40 | **Safety limits - Family (read only)** | `14:3771` | Full Screen | Light Mode, Family Role |
| 41 | **Add socket 1 - Scan QR** | `15:115` | Step / Wizard | Light Mode |
| 42 | **Add socket 2 - Confirm socket** | `15:175` | Step / Wizard | Light Mode |
| 43 | **Add socket 3 - How pairing stays secure** | `15:244` | Step / Wizard | Light Mode |
| 44 | **Add socket 4 - Wi-Fi for the socket** | `15:304` | Step / Wizard | Light Mode |
| 45 | **Add socket 5 - Pairing mode** | `15:348` | Step / Wizard | Light Mode |
| 46 | **Add socket 6 - Connecting** | `15:422` | Step / Wizard | Light Mode |
| 47 | **Add socket 7 - Claiming** | `15:457` | Step / Wizard | Light Mode |
| 48 | **Add socket 8 - Name your socket** | `15:513` | Step / Wizard | Light Mode |
| 49 | **Add socket Error - invalid QR** | `15:552` | Step / Wizard | Light Mode |
| 50 | **Add socket Error - Bluetooth not found** | `15:588` | Step / Wizard | Light Mode |
| 51 | **Add socket Error - socket could not join Wi-Fi** | `15:622` | Step / Wizard | Light Mode |
| 52 | **Add socket Error - claim code used** | `15:656` | Step / Wizard | Light Mode |
| 53 | **Add socket Error - already claimed** | `15:690` | Step / Wizard | Light Mode |
| 54 | **Add socket Error - too many attempts** | `15:726` | Step / Wizard | Light Mode |
| 55 | **Add socket Error - pairing window closed** | `15:762` | Step / Wizard | Light Mode |
| 56 | **Add socket Error - claim failed** | `15:796` | Step / Wizard | Light Mode |


### 04 Appliances (14 Screens)

*Appliance management, assignment to sockets, empty state, archive flow, and 4-step socket move wizard.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 57 | **Appliances list** | `16:108` | Full Screen | Light Mode |
| 58 | **Appliances list - empty** | `16:152` | Empty State | Light Mode |
| 59 | **Add appliance** | `16:284` | Full Screen | Light Mode |
| 60 | **Add appliance - name required** | `16:407` | Full Screen | Light Mode |
| 61 | **Add appliance - Family denied** | `16:438` | Full Screen | Light Mode, Family Role |
| 62 | **Appliance overview - Heater** | `16:753` | Full Screen | Light Mode |
| 63 | **Appliance overview - offline** | `16:966` | Full Screen | Light Mode, Offline State |
| 64 | **Appliance overview - archived** | `16:1114` | Full Screen | Light Mode |
| 65 | **Appliance overview - Family** | `16:1383` | Full Screen | Light Mode, Family Role |
| 66 | **Appliance - archive dialog** | `16:1656` | Dialog | Light Mode |
| 67 | **Move 1 - Close current session** | `16:1727` | Step / Wizard | Light Mode |
| 68 | **Move 2 - Choose new socket** | `16:1781` | Step / Wizard | Light Mode |
| 69 | **Move 3 - Review and confirm** | `16:1850` | Step / Wizard | Light Mode |
| 70 | **Move 4 - Done** | `16:1897` | Step / Wizard | Light Mode |


### 05 Control (12 Screens)

*Remote ON/OFF switch lifecycle (idle, pending, acknowledged, executed, failed, expired), countdown timer, and emergency OFF.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 71 | **Control - ON (idle)** | `16:2025` | Full Screen | Light Mode |
| 72 | **Control - pending** | `16:2172` | Full Screen | Light Mode |
| 73 | **Control - acknowledged** | `16:2306` | Full Screen | Light Mode |
| 74 | **Control - executed OFF** | `16:2438` | Full Screen | Light Mode |
| 75 | **Control - failed** | `16:2574` | Error State | Light Mode |
| 76 | **Control - expired** | `16:2710` | Full Screen | Light Mode |
| 77 | **Control - timer running** | `16:2848` | Full Screen | Light Mode |
| 78 | **Control - socket offline** | `16:2961` | Full Screen | Light Mode, Offline State |
| 79 | **Control - blocked by safety trip** | `16:3070` | Full Screen | Light Mode, Safety Trip |
| 80 | **Control - Family role** | `16:3167` | Full Screen | Light Mode, Family Role |
| 81 | **Control - timer sheet** | `16:3264` | Bottom Sheet | Light Mode |
| 82 | **Control - emergency OFF dialog** | `16:3391` | Dialog | Light Mode |


### 06 Scheduling (14 Screens)

*Weekly recurring schedules, overnight spans, multi-intervals, countdown timers, pause sheets, and conflict validation.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 83 | **Schedules list** | `17:85` | Full Screen | Light Mode |
| 84 | **Schedules list - paused** | `17:173` | Full Screen | Light Mode |
| 85 | **Schedules list - empty** | `17:230` | Empty State | Light Mode |
| 86 | **Schedules - pause sheet** | `17:299` | Bottom Sheet | Light Mode |
| 87 | **Schedule editor - new weekly** | `17:422` | Full Screen | Light Mode |
| 88 | **Schedule editor - name required** | `17:530` | Full Screen | Light Mode |
| 89 | **Schedule editor - edit existing** | `17:638` | Full Screen | Light Mode |
| 90 | **Schedule editor - overnight** | `17:742` | Full Screen | Light Mode |
| 91 | **Schedule editor - multiple intervals** | `17:867` | Full Screen | Light Mode |
| 92 | **Schedule editor - overlap error** | `17:992` | Error State | Light Mode |
| 93 | **Schedule editor - countdown** | `17:1068` | Full Screen | Light Mode |
| 94 | **Schedule editor - one-time** | `17:1163` | Full Screen | Light Mode |
| 95 | **Schedule editor - waiting for time sync** | `17:1271` | Full Screen | Light Mode |
| 96 | **Schedule - delete dialog** | `17:1375` | Dialog | Light Mode |


### 07 History (7 Screens)

*Energy consumption analytics across Hour/Day/10-sec granularities, telemetry gaps, single-device filters, and data export.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 97 | **History - Hour** | `17:1588` | Full Screen | Light Mode |
| 98 | **History - Day** | `17:1765` | Full Screen | Light Mode |
| 99 | **History - 10 s** | `17:1931` | Full Screen | Light Mode |
| 100 | **History - telemetry gap** | `17:2124` | Full Screen | Light Mode |
| 101 | **History - Heater only** | `17:2311` | Full Screen | Light Mode |
| 102 | **History - empty** | `17:2373` | Empty State | Light Mode |
| 103 | **History - export sheet** | `17:2560` | Bottom Sheet | Light Mode |


### 08 Alerts (7 Screens)

*Tabbed notification feed (All, Electrical, AI), critical detail overlays, AI insights, and notification rules sheet.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 104 | **Alerts - All** | `18:323` | Full Screen | Light Mode |
| 105 | **Alerts - Electrical** | `18:466` | Full Screen | Light Mode |
| 106 | **Alerts - AI** | `18:807` | Full Screen | Light Mode |
| 107 | **Alerts - empty** | `18:893` | Empty State | Light Mode |
| 108 | **Alert detail - critical** | `18:1032` | Full Screen | Light Mode |
| 109 | **Alert detail - AI** | `18:1229` | Full Screen | Light Mode |
| 110 | **Alert settings sheet** | `18:1574` | Bottom Sheet | Light Mode |


### 09 Billing (5 Screens)

*Electricity tariff configurations, slab estimates vs actual utility bills, validation states, and manual bill entry sheet.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 111 | **Billing settings** | `18:1838` | Full Screen | Light Mode |
| 112 | **Billing settings - Family (view only)** | `18:2015` | Full Screen | Light Mode, Family Role |
| 113 | **Billing - edit settings sheet** | `18:2197` | Bottom Sheet | Light Mode |
| 114 | **Billing - validation errors** | `18:2465` | Error State | Light Mode |
| 115 | **Billing - add bill sheet** | `18:2708` | Bottom Sheet | Light Mode |


### 10 AI (6 Screens)

*AI-powered Energy Intelligence progressive insights based on historical data maturity (2d, 5d, 10d, 45d), details, and settings.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 116 | **AI Energy - 45 days (strong)** | `21:252` | Full Screen | Light Mode |
| 117 | **AI Energy - 10 days (good)** | `21:440` | Full Screen | Light Mode |
| 118 | **AI Energy - 5 days (basic)** | `21:574` | Full Screen | Light Mode |
| 119 | **AI Energy - 2 days (learning)** | `21:649` | Full Screen | Light Mode |
| 120 | **AI - insight details sheet** | `21:851` | Bottom Sheet | Light Mode |
| 121 | **AI - settings sheet** | `21:1105` | Bottom Sheet | Light Mode |


### 11 Backup (18 Screens)

*Cloud backup lifecycle (disconnected, connected, syncing, failed), 5-step Google Drive restore wizard, and error handlers.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 122 | **Backup - not connected** | `22:146` | Full Screen | Light Mode |
| 123 | **Backup - connected** | `22:314` | Full Screen | Light Mode |
| 124 | **Backup - syncing** | `22:469` | Full Screen | Light Mode |
| 125 | **Backup - failed** | `22:622` | Error State | Light Mode |
| 126 | **Backup - Drive account unavailable** | `22:791` | Full Screen | Light Mode |
| 127 | **Backup - Family (Owner only)** | `22:822` | Full Screen | Light Mode, Family Role |
| 128 | **Backup - Google account chooser** | `22:931` | Full Screen | Light Mode |
| 129 | **Backup - manual backup sheet** | `22:1128` | Bottom Sheet | Light Mode |
| 130 | **Backup - verify result sheet** | `22:1305` | Bottom Sheet | Light Mode |
| 131 | **Restore 1 - Find backup** | `22:1402` | Step / Wizard | Light Mode |
| 132 | **Restore 2 - Validating** | `22:1446` | Step / Wizard | Light Mode |
| 133 | **Restore 3 - Review** | `22:1526` | Step / Wizard | Light Mode |
| 134 | **Restore 4 - Restoring** | `22:1568` | Step / Wizard | Light Mode |
| 135 | **Restore 5 - Done** | `22:1608` | Step / Wizard | Light Mode |
| 136 | **Restore error - no backup found** | `22:1647` | Step / Wizard | Light Mode |
| 137 | **Restore error - schema mismatch** | `22:1680` | Step / Wizard | Light Mode |
| 138 | **Restore error - checksum failed** | `22:1715` | Step / Wizard | Light Mode |
| 139 | **Restore error - Google account unavailable** | `22:1748` | Step / Wizard | Light Mode |


### 12 Settings (12 Screens)

*App preferences, user profile, family member permissions, storage quota, privacy terms, sign out, and deletion dialogs.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 140 | **Settings** | `22:2012` | Full Screen | Light Mode |
| 141 | **Settings - Family** | `22:2211` | Full Screen | Light Mode, Family Role |
| 142 | **Profile** | `22:2255` | Full Screen | Light Mode |
| 143 | **Notification rules** | `22:2345` | Full Screen | Light Mode |
| 144 | **Family and permissions** | `22:2510` | Full Screen | Light Mode, Family Role |
| 145 | **Family and permissions - Family view** | `22:2563` | Full Screen | Light Mode, Family Role |
| 146 | **Family - invite sheet** | `22:2619` | Bottom Sheet | Light Mode, Family Role |
| 147 | **Family - remove member dialog** | `22:2707` | Dialog | Light Mode, Family Role |
| 148 | **Storage and retention** | `22:2795` | Full Screen | Light Mode |
| 149 | **Privacy and data** | `22:2856` | Full Screen | Light Mode |
| 150 | **Settings - sign out dialog** | `22:3064` | Dialog | Light Mode |
| 151 | **Settings - delete account dialog** | `22:3281` | Dialog | Light Mode |


### 13 Family variants (6 Screens)

*Dedicated variant screens showing limited read/write permissions and restricted UI for family members.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 152 | **Dashboard - Family** | `22:3293` | Full Screen | Light Mode, Family Role |
| 153 | **Devices list - Family** | `22:3594` | Full Screen | Light Mode, Family Role |
| 154 | **Appliances list - Family** | `22:3722` | Full Screen | Light Mode, Family Role |
| 155 | **Schedules list - Family (can edit)** | `22:3802` | Full Screen | Light Mode, Family Role |
| 156 | **History - Family** | `22:3871` | Full Screen | Light Mode, Family Role |
| 157 | **Alerts - Family** | `22:4033` | Full Screen | Light Mode, Family Role |


### 14 Developer (7 Screens)

*Hardware debug tools, socket authentication token management, identity provisioning, and test harness.*

| # | Screen Name | Node ID | UI Type | State / Role / Notes |
| :---: | :--- | :---: | :---: | :--- |
| 158 | **Developer - login** | `22:4321` | Full Screen | Light Mode |
| 159 | **Developer - login error** | `22:4373` | Error State | Light Mode |
| 160 | **Developer - identities** | `22:4524` | Full Screen | Light Mode |
| 161 | **Developer - create identity** | `22:4572` | Full Screen | Light Mode |
| 162 | **Developer - identity created** | `22:4640` | Full Screen | Light Mode |
| 163 | **Developer - identity detail** | `22:4714` | Full Screen | Light Mode |
| 164 | **Developer - delete dialog** | `22:4741` | Dialog | Light Mode |

