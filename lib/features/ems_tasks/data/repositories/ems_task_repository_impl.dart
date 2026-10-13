import 'package:drift/drift.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/ems_tasks/data/database/daos/ems_task_dao.dart';
import 'package:ems_app/features/ems_tasks/data/repositories/ems_task_repository.dart';
import 'package:ems_app/features/ems_tasks/domain/models/shift_type.dart';
import 'package:uuid/uuid.dart';

class EmsTaskRepositoryImpl implements EmsTaskRepository {
  final EmsTaskDao dao;
  final Uuid uuid;
  final Future<void> Function()? onDataChanged;

  EmsTaskRepositoryImpl({
    required this.dao,
    this.uuid = const Uuid(),
    this.onDataChanged,
  });

  @override
  Stream<List<EmsTaskEntry>> watchAllTasks() {
    return dao.watchAllTasks();
  }

  @override
  Stream<List<EmsTaskEntry>> watchTasksForDate(DateTime date) {
    return dao.watchTasksForDay(date);
  }

  @override
  Stream<List<EmsTaskEntry>> watchTasksForWeek(DateTime weekStart, DateTime weekEnd) {
    return dao.watchTasksForWeek(weekStart, weekEnd);
  }

  @override
  Future<List<EmsTaskEntry>> getTasksForNext7Days() {
    return dao.getTasksForNext7Days(DateTime.now());
  }

  @override
  Future<List<EmsTaskEntry>> getUpcomingUncompletedForNotifications({int limit = 50}) {
    return dao.getUpcomingUncompletedForNotifications(
      from: DateTime.now(),
      limit: limit,
    );
  }

  @override
  Future<EmsTaskEntry?> getTaskById(String id) {
    return dao.getTaskById(id);
  }

  @override
  Future<void> createTask({
    required String title,
    String? notes,
    required DateTime dueDateTime,
    required String employeeName,
    required String department,
    required ShiftType shiftType,
  }) async {
    final now = DateTime.now();
    final companion = EmsTasksCompanion(
      id: Value(uuid.v4()),
      title: Value(title.trim()),
      notes: Value(notes?.trim()),
      dueDateTime: Value(dueDateTime),
      employeeName: Value(employeeName.trim()),
      department: Value(department.trim()),
      shiftType: Value(shiftType.name),
      isCompleted: const Value(false),
      completedAt: const Value(null),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await dao.insertTask(companion);
    await _notifyDataChanged();
  }

  @override
  Future<void> updateTask({
    required String id,
    required String title,
    String? notes,
    required DateTime dueDateTime,
    required String employeeName,
    required String department,
    required ShiftType shiftType,
  }) async {
    final existing = await dao.getTaskById(id);
    if (existing == null) return;

    final now = DateTime.now();
    final companion = EmsTasksCompanion(
      id: Value(id),
      title: Value(title.trim()),
      notes: Value(notes?.trim()),
      dueDateTime: Value(dueDateTime),
      employeeName: Value(employeeName.trim()),
      department: Value(department.trim()),
      shiftType: Value(shiftType.name),
      isCompleted: Value(existing.isCompleted),
      completedAt: Value(existing.completedAt),
      createdAt: Value(existing.createdAt),
      updatedAt: Value(now),
    );

    await dao.updateTask(companion);
    await _notifyDataChanged();
  }

  @override
  Future<void> deleteTask(String id) async {
    await dao.deleteTask(id);
    await _notifyDataChanged();
  }

  @override
  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    await dao.toggleTaskCompletion(id, isCompleted);
    await _notifyDataChanged();
  }

  Future<void> _notifyDataChanged() async {
    if (onDataChanged != null) {
      try {
        await onDataChanged!();
      } catch (_) {
        // Silently handle any external callback failure so DB operation isn't rolled back
      }
    }
  }
}
