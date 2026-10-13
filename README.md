# EMS Task Scheduler & Weekly Progress App

A cross-platform Flutter application built for **Employee Management Systems (EMS)** to schedule employee shift duties, track weekly & daily completion rates from a single source of truth, receive alarm-style high-priority reminders, and display prioritized duties on Android and iOS native home screen widgets.

---

## 🚀 Key Features

* **Duty & Task Lifecycle**: Full CRUD operations for duties with Title, Date & Time, Optional Notes, Assigned Staff Member, Department, and Shift Type (`Morning`, `Evening`, `Night`, `General`).
* **Single Source of Truth Progress**: Daily and weekly completion % are derived dynamically on-the-fly directly from task entries without auxiliary counter tables. All progress bars, charts, and home widgets read from this single source.
* **Performance Breakdown Modal**: Tapping the Weekly Performance card displays progress bars broken down per department and per employee.
* **Alarm-Style Reminders**: High-priority alarm sound, vibration pattern, full-screen intent on Android, and time-sensitive alerts on iOS via `flutter_local_notifications`.
* **iOS 64-Notification Limit Sliding Window**: Automatically calculates and schedules the top 50 imminent uncompleted duties, dynamically refreshing when tasks are added, marked complete, or modified.
* **Interactive Notification Actions**: Users can tap "Mark as Done" directly from lock-screen and banner notifications to complete a duty without opening the app.
* **Native Home Screen Widgets (`home_widget`)**:
  * Prioritizes **Today** and **Tomorrow** duties, alongside upcoming duties for days 3–7.
  * Shows the current week's completion percentage gauge directly in the widget.
  * Kotlin RemoteViews provider on Android.
  * SwiftUI WidgetKit TimelineProvider with App Groups on iOS.
* **App Lifecycle Observer**: Automatically refreshes date windows and synchronizes widgets when resuming from the background or crossing midnight.

---

## 🏗️ Architecture & Tech Stack

* **Framework**: Flutter 3.x / Dart 3.x
* **State Management**: [Riverpod](https://pub.dev/packages/flutter_riverpod) (`flutter_riverpod: ^3.4.3`)
* **Local Persistence**: [Drift](https://drift.simonbinder.eu/) SQLite (`drift: ^2.35.2`, `drift_flutter: ^0.3.1`)
* **Reminders**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) (`^22.3.2`), `timezone`, `flutter_timezone`
* **Widgets**: [home_widget](https://pub.dev/packages/home_widget) (`^0.10.0`)

---

## 📁 Project Folder Structure

```text
ems-app/
├── android/
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml                        # Exact alarm, receivers, widget provider
│   │   │   ├── kotlin/com/example/ems_app/
│   │   │   │   ├── MainActivity.kt
│   │   │   │   └── EmsTaskWidgetProvider.kt               # Native Kotlin AppWidgetProvider
│   │   │   └── res/
│   │   │       ├── layout/ems_widget_layout.xml           # Widget layout (Week % + 7-day duties)
│   │   │       ├── drawable/widget_background.xml
│   │   │       └── xml/ems_widget_info.xml
│   │   └── build.gradle.kts                               # Java 8+ core library desugaring
├── ios/
│   ├── Runner/
│   │   └── Runner.entitlements                            # App Groups (group.com.example.emsApp)
│   └── EmsWidgetExtension/                                # Native WidgetKit Extension target
│       ├── EmsWidgetDataModel.swift                       # Codable model for shared JSON
│       └── EmsWidgetExtension.swift                       # SwiftUI Widget with TimelineProvider
├── lib/
│   ├── app.dart                                           # Root MaterialApp
│   ├── main.dart                                          # Entry point with widget deep-linking & alarms
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart                         # Notification channels & iOS limit cap
│   │   │   └── widget_constants.dart                      # App Group identifier & widget keys
│   │   ├── extensions/
│   │   │   └── date_time_extensions.dart                  # startOfDay, weekStart (Monday), weekEnd (Sunday)
│   │   ├── services/
│   │   │   ├── notification_service.dart                  # Local notifications & interactive action buttons
│   │   │   ├── notification_scheduler.dart                # 50-limit sliding window scheduler
│   │   │   └── widget_sync_service.dart                   # home_widget bridge & data serializer
│   │   ├── theme/
│   │   │   └── app_theme.dart                             # Modern dark & light EMS themes
│   │   └── utils/
│   │       └── sample_data_seeder.dart                    # Demo shift duties generator
│   └── features/
│       ├── ems_tasks/
│       │   ├── data/
│       │   │   ├── database/
│       │   │   │   ├── app_database.dart                  # Drift SQLite database
│       │   │   │   ├── database_provider.dart             # Riverpod database & sync providers
│       │   │   │   ├── daos/ems_task_dao.dart             # Reactive SQL queries & filters
│       │   │   │   └── tables/ems_task_table.dart         # Schema definition
│       │   │   └── repositories/
│       │   │       ├── ems_task_repository.dart
│       │   │       └── ems_task_repository_impl.dart      # DB + Notification + Widget sync
│       │   ├── domain/models/shift_type.dart              # Morning, Evening, Night, General
│       │   └── presentation/
│       │       ├── screens/
│       │       │   ├── ems_dashboard_screen.dart          # Main duties list & filter chips
│       │       │   └── ems_task_editor_sheet.dart         # Create/Edit duty bottom sheet
│       │       └── widgets/ems_task_tile.dart             # Interactive tile with employee badges
│       └── progress/
│           ├── domain/progress_calculator.dart            # Pure functions for daily & weekly % derivation
│           └── presentation/
│               ├── controllers/progress_providers.dart    # Reactive derived progress providers
│               └── widgets/
│                   ├── progress_header.dart               # Weekly bar & today ring card
│                   └── performance_breakdown_sheet.dart   # Department & Staff completion breakdown
└── test/
    ├── ems_task_flow_test.dart                            # End-to-end task lifecycle & sync test
    ├── progress_calculator_test.dart                      # Pure domain derivation unit tests
    └── widget_test.dart                                   # Dashboard UI smoke test
```

---

## ⚙️ Platform Setup & Native Widgets

### Android
* **Manifest Permissions**: Configured in `android/app/src/main/AndroidManifest.xml` with:
  * `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM`
  * `POST_NOTIFICATIONS`
  * `RECEIVE_BOOT_COMPLETED`, `VIBRATE`, `WAKE_LOCK`
* **Desugaring**: Enabled `isCoreLibraryDesugaringEnabled = true` in `build.gradle.kts`.
* **Widget Registration**: Registered `EmsTaskWidgetProvider` with `android.appwidget.action.APPWIDGET_UPDATE`.

### iOS
1. Open the project in Xcode: `open ios/Runner.xcworkspace`.
2. Under **Signing & Capabilities** for `Runner`:
   * Enable **App Groups** and check `group.com.example.emsApp`.
3. Add the Widget Extension Target:
   * Select **File > New > Target... > Widget Extension**.
   * Product Name: `EmsWidgetExtension`.
   * Uncheck "Include Live Activity".
   * Add the files from `ios/EmsWidgetExtension/` to this target.
   * Add the **App Groups** capability to `EmsWidgetExtension` with the matching ID `group.com.example.emsApp`.

---

## 🧪 Running Automated Tests

Run the full suite of unit, integration, and UI widget tests:
```bash
flutter test
```

Run static analysis:
```bash
flutter analyze
```

---

## 📱 Running the Application

### Preview in Chrome (Desktop):
```bash
flutter run -d chrome
```

### Run on Android Device / Emulator:
```bash
flutter run -d android
```

### Run on iOS Simulator (macOS):
```bash
flutter run -d ios
```

---

## 💡 Quick Testing Tips
* **Populate Demo Duties**: In the dashboard, tap the top-right menu ($\vdots$) and select **Seed Demo Duties** to instantly populate 9 realistic duties across Today, Tomorrow, and the next 7 days.
* **View Staff Breakdown**: Tap on the **Weekly Performance** card to open the departmental and employee completion percentage breakdown sheet.
* **Test Alarms**: Create a duty scheduled for 2 minutes from the current time to observe high-priority notifications with the interactive "Mark as Done" action button.
