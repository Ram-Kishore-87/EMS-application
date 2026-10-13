import 'package:ems_app/core/services/notification_scheduler.dart';
import 'package:ems_app/core/services/notification_service.dart';
import 'package:ems_app/core/services/widget_sync_service.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/ems_tasks/data/database/daos/ems_task_dao.dart';
import 'package:ems_app/features/ems_tasks/data/repositories/ems_task_repository.dart';
import 'package:ems_app/features/ems_tasks/data/repositories/ems_task_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Singleton Database Provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Task DAO Provider
final emsTaskDaoProvider = Provider<EmsTaskDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.emsTaskDao;
});

/// Notification Service Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Task Repository Provider (orchestrating DB mutations + notifications + home widget sync)
final emsTaskRepositoryProvider = Provider<EmsTaskRepository>((ref) {
  final dao = ref.watch(emsTaskDaoProvider);
  final notifService = ref.watch(notificationServiceProvider);

  late final EmsTaskRepositoryImpl repository;
  repository = EmsTaskRepositoryImpl(
    dao: dao,
    onDataChanged: () async {
      final scheduler = NotificationScheduler(
        repository: repository,
        notificationService: notifService,
      );
      final widgetSync = WidgetSyncService(repository: repository);
      await scheduler.syncNotifications();
      await widgetSync.syncWidgetData();
    },
  );
  return repository;
});

/// Notification Scheduler Provider
final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  final repo = ref.watch(emsTaskRepositoryProvider);
  final notifService = ref.watch(notificationServiceProvider);
  return NotificationScheduler(
    repository: repo,
    notificationService: notifService,
  );
});

/// Home Widget Sync Service Provider
final widgetSyncServiceProvider = Provider<WidgetSyncService>((ref) {
  final repo = ref.watch(emsTaskRepositoryProvider);
  return WidgetSyncService(repository: repo);
});
