import 'package:drift/native.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/ems_tasks/data/repositories/ems_task_repository_impl.dart';
import 'package:ems_app/features/ems_tasks/domain/models/shift_type.dart';
import 'package:ems_app/features/progress/domain/progress_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EMS Duty Flow & Single-Source-of-Truth Progress Integration Tests', () {
    late AppDatabase db;
    late EmsTaskRepositoryImpl repository;
    bool syncCalled = false;

    setUp(() {
      syncCalled = false;
      db = AppDatabase(NativeDatabase.memory());
      repository = EmsTaskRepositoryImpl(
        dao: db.emsTaskDao,
        onDataChanged: () async {
          syncCalled = true;
        },
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('Creating duties triggers sync and reflects accurately in progress', () async {
      final now = DateTime.now();

      // Initially empty
      var tasks = await repository.watchAllTasks().first;
      var progress = ProgressCalculator.calculateWeeklyProgress(tasks, targetDate: now);
      expect(progress.percentage, 0.0);
      expect(progress.totalCount, 0);

      // 1. Create a Morning Duty for Today
      await repository.createTask(
        title: 'Check Ventilators',
        notes: 'ICU ward 3',
        dueDateTime: now,
        employeeName: 'Nurse Jackie',
        department: 'Operations',
        shiftType: ShiftType.morning,
      );

      expect(syncCalled, isTrue);

      tasks = await repository.watchAllTasks().first;
      expect(tasks.length, 1);
      expect(tasks.first.title, 'Check Ventilators');
      expect(tasks.first.isCompleted, isFalse);

      // Verify progress derived from task data
      progress = ProgressCalculator.calculateWeeklyProgress(tasks, targetDate: now);
      expect(progress.totalCount, 1);
      expect(progress.completedCount, 0);
      expect(progress.percentage, 0.0);

      // 2. Mark duty as completed
      syncCalled = false;
      await repository.toggleTaskCompletion(tasks.first.id, true);
      expect(syncCalled, isTrue);

      tasks = await repository.watchAllTasks().first;
      expect(tasks.first.isCompleted, isTrue);
      expect(tasks.first.completedAt, isNotNull);

      // Verify single source of truth progress updates to 100%
      progress = ProgressCalculator.calculateWeeklyProgress(tasks, targetDate: now);
      expect(progress.totalCount, 1);
      expect(progress.completedCount, 1);
      expect(progress.percentage, 100.0);
      expect(progress.ratio, 1.0);

      // 3. Add a second duty for tomorrow
      await repository.createTask(
        title: 'Staff Meeting',
        dueDateTime: now.add(const Duration(days: 1)),
        employeeName: 'Dr. House',
        department: 'Administration',
        shiftType: ShiftType.general,
      );

      tasks = await repository.watchAllTasks().first;
      expect(tasks.length, 2);

      // Daily progress for today should remain 100%
      final dailyProgress = ProgressCalculator.calculateDailyProgress(tasks, targetDate: now);
      expect(dailyProgress.totalCount, 1);
      expect(dailyProgress.completedCount, 1);
      expect(dailyProgress.percentage, 100.0);

      // Weekly progress should be 50% (1 completed out of 2) if tomorrow is in current week
      if (now.weekday < 7) {
        final weeklyProgress = ProgressCalculator.calculateWeeklyProgress(tasks, targetDate: now);
        expect(weeklyProgress.totalCount, 2);
        expect(weeklyProgress.completedCount, 1);
        expect(weeklyProgress.percentage, 50.0);
      }

      // 4. Delete the first duty
      await repository.deleteTask(tasks.first.id);
      tasks = await repository.watchAllTasks().first;
      expect(tasks.length, 1);
      expect(tasks.first.title, 'Staff Meeting');
    });

    test('Next 7 days query prioritizes and bounds correctly', () async {
      final now = DateTime.now();

      // Add task today
      await repository.createTask(
        title: 'Duty Today',
        dueDateTime: now,
        employeeName: 'Staff 1',
        department: 'Operations',
        shiftType: ShiftType.morning,
      );

      // Add task 5 days from now
      await repository.createTask(
        title: 'Duty in 5 Days',
        dueDateTime: now.add(const Duration(days: 5)),
        employeeName: 'Staff 2',
        department: 'Operations',
        shiftType: ShiftType.morning,
      );

      // Add task 20 days from now (outside 7 days window)
      await repository.createTask(
        title: 'Duty Far Future',
        dueDateTime: now.add(const Duration(days: 20)),
        employeeName: 'Staff 3',
        department: 'Operations',
        shiftType: ShiftType.morning,
      );

      final next7Days = await repository.getTasksForNext7Days();
      expect(next7Days.length, 2);
      expect(next7Days.any((t) => t.title == 'Duty Today'), isTrue);
      expect(next7Days.any((t) => t.title == 'Duty in 5 Days'), isTrue);
      expect(next7Days.any((t) => t.title == 'Duty Far Future'), isFalse);
    });
  });
}
