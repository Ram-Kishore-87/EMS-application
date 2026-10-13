import 'package:ems_app/app.dart';
import 'package:ems_app/core/services/notification_service.dart';
import 'package:ems_app/features/ems_tasks/data/database/database_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // 2. Request notification permissions (Android 13+ & iOS)
  await notificationService.requestPermissions();

  final container = ProviderContainer();

  // 3. Initial sync for Home Screen Widget & Notifications
  try {
    final scheduler = container.read(notificationSchedulerProvider);
    final widgetSync = container.read(widgetSyncServiceProvider);
    await scheduler.syncNotifications();
    await widgetSync.syncWidgetData();
  } catch (e) {
    debugPrint('Initial sync warning: $e');
  }

  // 4. Setup Home Widget click interaction handler
  if (!kIsWeb) {
    HomeWidget.initiallyLaunchedFromHomeWidget().then((Uri? uri) {
      if (uri != null) {
        debugPrint('Launched from Home Widget with URI: $uri');
      }
    });

    HomeWidget.widgetClicked.listen((Uri? uri) {
      if (uri != null) {
        debugPrint('Clicked Home Widget while running with URI: $uri');
      }
    });
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const EmsApp(),
    ),
  );
}
