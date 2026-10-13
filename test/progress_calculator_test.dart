import 'package:ems_app/core/extensions/date_time_extensions.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/progress/domain/progress_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProgressCalculator Tests', () {
    final now = DateTime.now();

    EmsTaskEntry createMockTask({
      required String id,
      required DateTime dueDateTime,
      required bool isCompleted,
      String department = 'Operations',
      String employeeName = 'Jane Doe',
    }) {
      return EmsTaskEntry(
        id: id,
        title: 'Duty $id',
        notes: null,
        dueDateTime: dueDateTime,
        employeeName: employeeName,
        department: department,
        shiftType: 'morning',
        isCompleted: isCompleted,
        completedAt: isCompleted ? dueDateTime : null,
        createdAt: now,
        updatedAt: now,
      );
    }

    test('returns 0% and empty summary when task list is empty', () {
      final summary = ProgressCalculator.calculateProgress([]);
      expect(summary.totalCount, 0);
      expect(summary.completedCount, 0);
      expect(summary.pendingCount, 0);
      expect(summary.percentage, 0.0);
      expect(summary.ratio, 0.0);
      expect(summary.formattedPercentage, '0%');
    });

    test('calculates correct percentages for mixed completion', () {
      final tasks = [
        createMockTask(id: '1', dueDateTime: now, isCompleted: true),
        createMockTask(id: '2', dueDateTime: now, isCompleted: true),
        createMockTask(id: '3', dueDateTime: now, isCompleted: false),
        createMockTask(id: '4', dueDateTime: now, isCompleted: false),
      ];

      final summary = ProgressCalculator.calculateProgress(tasks);
      expect(summary.totalCount, 4);
      expect(summary.completedCount, 2);
      expect(summary.pendingCount, 2);
      expect(summary.percentage, 50.0);
      expect(summary.ratio, 0.5);
      expect(summary.formattedPercentage, '50%');
    });

    test('calculates 100% when all tasks completed', () {
      final tasks = [
        createMockTask(id: '1', dueDateTime: now, isCompleted: true),
        createMockTask(id: '2', dueDateTime: now, isCompleted: true),
      ];

      final summary = ProgressCalculator.calculateProgress(tasks);
      expect(summary.percentage, 100.0);
      expect(summary.ratio, 1.0);
      expect(summary.formattedPercentage, '100%');
    });

    test('calculates daily progress isolating today from tomorrow', () {
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));

      final tasks = [
        // Today: 1 completed, 1 pending
        createMockTask(id: '1', dueDateTime: today, isCompleted: true),
        createMockTask(id: '2', dueDateTime: today, isCompleted: false),
        // Tomorrow: 1 completed
        createMockTask(id: '3', dueDateTime: tomorrow, isCompleted: true),
      ];

      final dailySummary = ProgressCalculator.calculateDailyProgress(tasks, targetDate: today);
      expect(dailySummary.totalCount, 2);
      expect(dailySummary.completedCount, 1);
      expect(dailySummary.percentage, 50.0);
    });

    test('calculates weekly progress covering Monday to Sunday', () {
      final monday = DateTime.now().startOfWeek;
      final wednesday = monday.add(const Duration(days: 2));
      final nextWeek = monday.add(const Duration(days: 9));

      final tasks = [
        createMockTask(id: '1', dueDateTime: monday, isCompleted: true),
        createMockTask(id: '2', dueDateTime: wednesday, isCompleted: true),
        createMockTask(id: '3', dueDateTime: wednesday, isCompleted: false),
        // Outside the week
        createMockTask(id: '4', dueDateTime: nextWeek, isCompleted: false),
      ];

      final weeklySummary = ProgressCalculator.calculateWeeklyProgress(tasks, targetDate: monday);
      expect(weeklySummary.totalCount, 3);
      expect(weeklySummary.completedCount, 2);
      expect(weeklySummary.percentage, 66.7);
    });
  });
}
