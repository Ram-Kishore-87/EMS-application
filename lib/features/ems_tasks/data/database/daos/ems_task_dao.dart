import 'package:drift/drift.dart';
import 'package:ems_app/core/extensions/date_time_extensions.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/ems_tasks/data/database/tables/ems_task_table.dart';

part 'ems_task_dao.g.dart';

@DriftAccessor(tables: [EmsTasks])
class EmsTaskDao extends DatabaseAccessor<AppDatabase> with _$EmsTaskDaoMixin {
  EmsTaskDao(super.db);

  /// Watch all tasks ordered by dueDateTime
  Stream<List<EmsTaskEntry>> watchAllTasks() {
    return (select(emsTasks)
          ..orderBy([(t) => OrderingTerm(expression: t.dueDateTime, mode: OrderingMode.asc)]))
        .watch();
  }

  /// Watch tasks within a specific date range
  Stream<List<EmsTaskEntry>> watchTasksForDateRange(DateTime start, DateTime end) {
    return (select(emsTasks)
          ..where((t) =>
              t.dueDateTime.isBiggerOrEqualValue(start) &
              t.dueDateTime.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm(expression: t.dueDateTime, mode: OrderingMode.asc)]))
        .watch();
  }

  /// Watch tasks for a specific calendar day
  Stream<List<EmsTaskEntry>> watchTasksForDay(DateTime date) {
    return watchTasksForDateRange(date.startOfDay, date.endOfDay);
  }

  /// Watch tasks for a specific week (e.g. Monday to Sunday)
  Stream<List<EmsTaskEntry>> watchTasksForWeek(DateTime weekStart, DateTime weekEnd) {
    return watchTasksForDateRange(weekStart.startOfDay, weekEnd.endOfDay);
  }

  /// Get upcoming uncompleted tasks (for notification scheduling sliding window)
  Future<List<EmsTaskEntry>> getUpcomingUncompletedForNotifications({
    required DateTime from,
    int limit = 50,
  }) {
    return (select(emsTasks)
          ..where((t) =>
              t.isCompleted.equals(false) &
              t.dueDateTime.isBiggerOrEqualValue(from))
          ..orderBy([(t) => OrderingTerm(expression: t.dueDateTime, mode: OrderingMode.asc)])
          ..limit(limit))
        .get();
  }

  /// Get tasks for the next 7 days (used by Home Widget sync)
  Future<List<EmsTaskEntry>> getTasksForNext7Days(DateTime from) {
    final start = from.startOfDay;
    final end = start.add(const Duration(days: 7)).endOfDay;
    return (select(emsTasks)
          ..where((t) =>
              t.dueDateTime.isBiggerOrEqualValue(start) &
              t.dueDateTime.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm(expression: t.dueDateTime, mode: OrderingMode.asc)]))
        .get();
  }

  /// Get a single task by ID
  Future<EmsTaskEntry?> getTaskById(String id) {
    return (select(emsTasks)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert a new task
  Future<int> insertTask(EmsTasksCompanion entry) {
    return into(emsTasks).insert(entry);
  }

  /// Update an existing task
  Future<bool> updateTask(EmsTasksCompanion entry) {
    return update(emsTasks).replace(entry);
  }

  /// Delete a task by ID
  Future<int> deleteTask(String id) {
    return (delete(emsTasks)..where((t) => t.id.equals(id))).go();
  }

  /// Toggle task completion
  Future<int> toggleTaskCompletion(String id, bool isCompleted) {
    return (update(emsTasks)..where((t) => t.id.equals(id))).write(
      EmsTasksCompanion(
        isCompleted: Value(isCompleted),
        completedAt: Value(isCompleted ? DateTime.now() : null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
