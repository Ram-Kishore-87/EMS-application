import 'package:ems_app/core/constants/app_constants.dart';
import 'package:ems_app/core/services/notification_service.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/ems_tasks/data/repositories/ems_task_repository.dart';
import 'package:ems_app/features/ems_tasks/domain/models/shift_type.dart';
import 'package:flutter/foundation.dart';

class NotificationScheduler {
  final NotificationService notificationService;
  final EmsTaskRepository repository;

  NotificationScheduler({
    NotificationService? notificationService,
    required this.repository,
  }) : notificationService = notificationService ?? NotificationService();

  /// Reschedules notifications using a sliding window to stay within iOS's 64 notification limit.
  Future<void> syncNotifications() async {
    try {
      // 1. Cancel all previously scheduled notifications
      await notificationService.cancelAllNotifications();

      // 2. Fetch the nearest upcoming uncompleted tasks within safe cap
      final List<EmsTaskEntry> upcomingTasks =
          await repository.getUpcomingUncompletedForNotifications(
        limit: AppConstants.maxPendingNotificationsIos,
      );

      final now = DateTime.now();

      // 3. Schedule the nearest batch
      for (final task in upcomingTasks) {
        if (task.dueDateTime.isAfter(now)) {
          final shift = ShiftType.fromString(task.shiftType);
          final id = task.id.hashCode.abs() % 1000000;

          final title = '⏰ [${shift.label}] ${task.title}';
          final body =
              'Assigned to: ${task.employeeName} • ${task.department}${task.notes != null && task.notes!.isNotEmpty ? '\nNote: ${task.notes}' : ''}';

          await notificationService.scheduleAlarmNotification(
            id: id,
            title: title,
            body: body,
            scheduledDate: task.dueDateTime,
            payload: task.id,
          );
        }
      }

      debugPrint(
        'Synced notifications: Scheduled ${upcomingTasks.length} upcoming duties (iOS cap: 64, buffer: ${AppConstants.maxPendingNotificationsIos}).',
      );
    } catch (e, stack) {
      debugPrint('Failed to sync notifications: $e\n$stack');
    }
  }
}
