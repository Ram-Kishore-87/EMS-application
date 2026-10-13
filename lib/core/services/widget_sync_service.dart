import 'dart:convert';
import 'package:ems_app/core/constants/widget_constants.dart';
import 'package:ems_app/core/extensions/date_time_extensions.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/ems_tasks/data/repositories/ems_task_repository.dart';
import 'package:ems_app/features/ems_tasks/domain/models/shift_type.dart';
import 'package:ems_app/features/progress/domain/progress_calculator.dart';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

class WidgetSyncService {
  final EmsTaskRepository repository;

  WidgetSyncService({required this.repository});

  /// Serializes next 7 days of tasks (prioritizing today & tomorrow) and progress metrics into shared storage
  Future<void> syncWidgetData() async {
    try {
      // Set App Group for iOS WidgetKit
      await HomeWidget.setAppGroupId(WidgetConstants.appGroupId);

      // 1. Fetch upcoming tasks for the next 7 days
      final List<EmsTaskEntry> next7DaysTasks = await repository.getTasksForNext7Days();

      // 2. Fetch all week tasks for weekly progress
      final now = DateTime.now();
      final List<EmsTaskEntry> allWeekTasks =
          await repository.watchTasksForWeek(now.startOfWeek, now.endOfWeek).first;

      // 3. Compute derived progress strictly from task entries
      final dailyProgress = ProgressCalculator.calculateDailyProgress(allWeekTasks, targetDate: now);
      final weeklyProgress = ProgressCalculator.calculateWeeklyProgress(allWeekTasks, targetDate: now);

      // 4. Partition tasks: Today, Tomorrow, Upcoming (Days 3-7)
      final List<Map<String, dynamic>> todayList = [];
      final List<Map<String, dynamic>> tomorrowList = [];
      final List<Map<String, dynamic>> upcomingList = [];

      final timeFormatter = DateFormat('h:mm a');
      final dayDateFormatter = DateFormat('EEE, MMM d');

      for (final task in next7DaysTasks) {
        final shift = ShiftType.fromString(task.shiftType);
        final taskMap = {
          'id': task.id,
          'title': task.title,
          'time': timeFormatter.format(task.dueDateTime),
          'date': dayDateFormatter.format(task.dueDateTime),
          'employeeName': task.employeeName,
          'department': task.department,
          'shiftLabel': shift.label,
          'isCompleted': task.isCompleted,
        };

        if (task.dueDateTime.isToday) {
          todayList.add(taskMap);
        } else if (task.dueDateTime.isTomorrow) {
          tomorrowList.add(taskMap);
        } else {
          upcomingList.add(taskMap);
        }
      }

      final payload = {
        'lastUpdated': now.toIso8601String(),
        'weeklyProgressPct': weeklyProgress.percentage.round(),
        'weeklyCompleted': weeklyProgress.completedCount,
        'weeklyTotal': weeklyProgress.totalCount,
        'dailyProgressPct': dailyProgress.percentage.round(),
        'dailyCompleted': dailyProgress.completedCount,
        'dailyTotal': dailyProgress.totalCount,
        'todayDuties': todayList,
        'tomorrowDuties': tomorrowList,
        'upcomingDuties': upcomingList,
      };

      final jsonString = jsonEncode(payload);

      // 5. Persist JSON string and key metrics to shared storage
      await HomeWidget.saveWidgetData<String>(WidgetConstants.widgetDataKey, jsonString);
      await HomeWidget.saveWidgetData<int>('weeklyProgressPct', weeklyProgress.percentage.round());
      await HomeWidget.saveWidgetData<int>('dailyProgressPct', dailyProgress.percentage.round());

      // 6. Notify native widgets to refresh
      await HomeWidget.updateWidget(
        name: WidgetConstants.androidWidgetProvider,
        iOSName: WidgetConstants.iosWidgetName,
      );

      debugPrint('Widget synchronized successfully with ${next7DaysTasks.length} tasks.');
    } catch (e, stack) {
      debugPrint('Error syncing widget data: $e\n$stack');
    }
  }
}
