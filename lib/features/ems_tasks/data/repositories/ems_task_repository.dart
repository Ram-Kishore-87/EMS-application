import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/ems_tasks/domain/models/shift_type.dart';

abstract class EmsTaskRepository {
  /// Stream of all tasks ordered chronologically
  Stream<List<EmsTaskEntry>> watchAllTasks();

  /// Stream of tasks for a single day (from 00:00 to 23:59:59)
  Stream<List<EmsTaskEntry>> watchTasksForDate(DateTime date);

  /// Stream of tasks for a week window (Monday 00:00 to Sunday 23:59:59)
  Stream<List<EmsTaskEntry>> watchTasksForWeek(DateTime weekStart, DateTime weekEnd);

  /// Get tasks for the next 7 days (used for native widget sync)
  Future<List<EmsTaskEntry>> getTasksForNext7Days();

  /// Get upcoming uncompleted tasks (for notification sliding window)
  Future<List<EmsTaskEntry>> getUpcomingUncompletedForNotifications({int limit = 50});

  /// Get a single task by ID
  Future<EmsTaskEntry?> getTaskById(String id);

  /// Create a new duty/task
  Future<void> createTask({
    required String title,
    String? notes,
    required DateTime dueDateTime,
    required String employeeName,
    required String department,
    required ShiftType shiftType,
  });

  /// Update an existing duty/task
  Future<void> updateTask({
    required String id,
    required String title,
    String? notes,
    required DateTime dueDateTime,
    required String employeeName,
    required String department,
    required ShiftType shiftType,
  });

  /// Delete a duty/task by ID
  Future<void> deleteTask(String id);

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String id, bool isCompleted);
}
