import 'package:ems_app/core/extensions/date_time_extensions.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/ems_tasks/data/database/database_provider.dart';
import 'package:ems_app/features/progress/domain/progress_calculator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stream of all tasks in the database
final allTasksStreamProvider = StreamProvider<List<EmsTaskEntry>>((ref) {
  final repo = ref.watch(emsTaskRepositoryProvider);
  return repo.watchAllTasks();
});

/// Stream of today's tasks
final todayTasksStreamProvider = StreamProvider<List<EmsTaskEntry>>((ref) {
  final repo = ref.watch(emsTaskRepositoryProvider);
  return repo.watchTasksForDate(DateTime.now());
});

/// Stream of this week's tasks (Monday to Sunday)
final weekTasksStreamProvider = StreamProvider<List<EmsTaskEntry>>((ref) {
  final repo = ref.watch(emsTaskRepositoryProvider);
  final now = DateTime.now();
  return repo.watchTasksForWeek(now.startOfWeek, now.endOfWeek);
});

/// Reactive Daily Progress: derived purely from today's tasks
final dailyProgressProvider = Provider<AsyncValue<ProgressSummary>>((ref) {
  final todayTasksAsync = ref.watch(todayTasksStreamProvider);
  return todayTasksAsync.whenData((tasks) => ProgressCalculator.calculateProgress(tasks));
});

/// Reactive Weekly Progress: derived purely from this week's tasks
final weeklyProgressProvider = Provider<AsyncValue<ProgressSummary>>((ref) {
  final weekTasksAsync = ref.watch(weekTasksStreamProvider);
  return weekTasksAsync.whenData((tasks) => ProgressCalculator.calculateProgress(tasks));
});

/// Department-specific weekly progress
final departmentWeeklyProgressProvider =
    Provider.family<AsyncValue<ProgressSummary>, String>((ref, department) {
  final weekTasksAsync = ref.watch(weekTasksStreamProvider);
  return weekTasksAsync.whenData((tasks) =>
      ProgressCalculator.calculateDepartmentWeeklyProgress(tasks, department));
});

/// Employee-specific weekly progress
final employeeWeeklyProgressProvider =
    Provider.family<AsyncValue<ProgressSummary>, String>((ref, employeeName) {
  final weekTasksAsync = ref.watch(weekTasksStreamProvider);
  return weekTasksAsync.whenData((tasks) =>
      ProgressCalculator.calculateEmployeeWeeklyProgress(tasks, employeeName));
});
