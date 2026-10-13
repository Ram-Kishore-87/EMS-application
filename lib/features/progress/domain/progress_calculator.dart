import 'package:ems_app/core/extensions/date_time_extensions.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';

class ProgressSummary {
  final int totalCount;
  final int completedCount;
  final int pendingCount;
  final double percentage; // 0.0 to 100.0

  const ProgressSummary({
    required this.totalCount,
    required this.completedCount,
    required this.pendingCount,
    required this.percentage,
  });

  /// Empty summary fallback
  const ProgressSummary.empty()
      : totalCount = 0,
        completedCount = 0,
        pendingCount = 0,
        percentage = 0.0;

  /// Human-readable percentage string (e.g., "75%")
  String get formattedPercentage => '${percentage.round()}%';

  /// Ratio as a double between 0.0 and 1.0 (for Flutter Linear/CircularProgressIndicator)
  double get ratio => totalCount == 0 ? 0.0 : (completedCount / totalCount).clamp(0.0, 1.0);
}

class ProgressCalculator {
  /// Pure function: calculates progress summary from a given list of task entries
  static ProgressSummary calculateProgress(List<EmsTaskEntry> tasks) {
    if (tasks.isEmpty) {
      return const ProgressSummary.empty();
    }

    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    final pending = total - completed;
    final pct = (completed / total) * 100.0;

    return ProgressSummary(
      totalCount: total,
      completedCount: completed,
      pendingCount: pending,
      percentage: double.parse(pct.toStringAsFixed(1)),
    );
  }

  /// Pure function: filters tasks for [targetDate] and calculates daily progress
  static ProgressSummary calculateDailyProgress(
    List<EmsTaskEntry> allTasks, {
    DateTime? targetDate,
  }) {
    final date = targetDate ?? DateTime.now();
    final start = date.startOfDay;
    final end = date.endOfDay;

    final todayTasks = allTasks.where((t) {
      return !t.dueDateTime.isBefore(start) && !t.dueDateTime.isAfter(end);
    }).toList();

    return calculateProgress(todayTasks);
  }

  /// Pure function: filters tasks for the current week containing [targetDate]
  /// Week starts Monday 00:00:00 and ends Sunday 23:59:59.999
  static ProgressSummary calculateWeeklyProgress(
    List<EmsTaskEntry> allTasks, {
    DateTime? targetDate,
  }) {
    final date = targetDate ?? DateTime.now();
    final start = date.startOfWeek;
    final end = date.endOfWeek;

    final weekTasks = allTasks.where((t) {
      return !t.dueDateTime.isBefore(start) && !t.dueDateTime.isAfter(end);
    }).toList();

    return calculateProgress(weekTasks);
  }

  /// Pure function: calculates progress for a specific department within the week
  static ProgressSummary calculateDepartmentWeeklyProgress(
    List<EmsTaskEntry> allTasks,
    String department, {
    DateTime? targetDate,
  }) {
    final date = targetDate ?? DateTime.now();
    final start = date.startOfWeek;
    final end = date.endOfWeek;

    final deptTasks = allTasks.where((t) {
      final inWeek = !t.dueDateTime.isBefore(start) && !t.dueDateTime.isAfter(end);
      return inWeek && t.department.toLowerCase() == department.toLowerCase();
    }).toList();

    return calculateProgress(deptTasks);
  }

  /// Pure function: calculates progress for a specific employee within the week
  static ProgressSummary calculateEmployeeWeeklyProgress(
    List<EmsTaskEntry> allTasks,
    String employeeName, {
    DateTime? targetDate,
  }) {
    final date = targetDate ?? DateTime.now();
    final start = date.startOfWeek;
    final end = date.endOfWeek;

    final empTasks = allTasks.where((t) {
      final inWeek = !t.dueDateTime.isBefore(start) && !t.dueDateTime.isAfter(end);
      return inWeek && t.employeeName.toLowerCase() == employeeName.toLowerCase();
    }).toList();

    return calculateProgress(empTasks);
  }
}
