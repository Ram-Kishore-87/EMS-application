import 'package:ems_app/features/ems_tasks/data/repositories/ems_task_repository.dart';
import 'package:ems_app/features/ems_tasks/domain/models/shift_type.dart';

class SampleDataSeeder {
  /// Seeds initial EMS shift duties for testing progress tracking and 7-day widgets
  static Future<void> seedDemoDuties(EmsTaskRepository repository) async {
    final now = DateTime.now();

    final demoDuties = [
      // TODAY
      (
        title: 'Emergency Room Triage Protocol Review',
        notes: 'Check rapid response triage kits and update ward intake log.',
        dueDateTime: DateTime(now.year, now.month, now.day, 8, 30),
        employee: 'Sarah Jenkins',
        department: 'Operations',
        shift: ShiftType.morning,
        completed: true,
      ),
      (
        title: 'Medical Supplies & Narcotics Restock',
        notes: 'Double count scheduled substances and log signatures.',
        dueDateTime: DateTime(now.year, now.month, now.day, 11, 0),
        employee: 'Michael Chang',
        department: 'Logistics',
        shift: ShiftType.morning,
        completed: true,
      ),
      (
        title: 'Shift Handover & Patient Status Debrief',
        notes: 'Critical notes on beds 4 and 12 transfer to night team.',
        dueDateTime: DateTime(now.year, now.month, now.day, 14, 30),
        employee: 'David Ross',
        department: 'Operations',
        shift: ShiftType.morning,
        completed: false,
      ),
      (
        title: 'Ambulance Fleet & Oxygen Cylinder Inspection',
        notes: 'Check PSI levels for rigs #3 and #5.',
        dueDateTime: DateTime(now.year, now.month, now.day, 17, 30),
        employee: 'Emma Watson',
        department: 'Operations',
        shift: ShiftType.evening,
        completed: false,
      ),

      // TOMORROW
      (
        title: 'Weekly Staff Clinical Safety Briefing',
        notes: 'Review updated bloodborne pathogen protocols in conference room B.',
        dueDateTime: DateTime(now.year, now.month, now.day + 1, 9, 0),
        employee: 'Sarah Jenkins',
        department: 'Administration',
        shift: ShiftType.morning,
        completed: false,
      ),
      (
        title: 'Pediatric Ward Equipment Audit',
        notes: 'Calibrate monitors and verify pediatric resuscitation carts.',
        dueDateTime: DateTime(now.year, now.month, now.day + 1, 15, 0),
        employee: 'Jessica Alba',
        department: 'Customer Support',
        shift: ShiftType.evening,
        completed: false,
      ),

      // DAY 3
      (
        title: 'Hazardous Waste & Sharps Disposal Run',
        notes: 'Ensure proper biosafety labeling and custody signoffs.',
        dueDateTime: DateTime(now.year, now.month, now.day + 2, 10, 15),
        employee: 'Michael Chang',
        department: 'Logistics',
        shift: ShiftType.morning,
        completed: false,
      ),

      // DAY 5
      (
        title: 'ICU Ventilator Maintenance Checklist',
        notes: 'Preventative bio-med inspection and filter replacement.',
        dueDateTime: DateTime(now.year, now.month, now.day + 4, 13, 0),
        employee: 'David Ross',
        department: 'Engineering',
        shift: ShiftType.general,
        completed: false,
      ),

      // DAY 6
      (
        title: 'Weekend Dispatch & On-Call Rotation Setup',
        notes: 'Confirm paramedic backup availability for Saturday night.',
        dueDateTime: DateTime(now.year, now.month, now.day + 5, 8, 0),
        employee: 'Emma Watson',
        department: 'Operations',
        shift: ShiftType.morning,
        completed: false,
      ),
    ];

    for (final d in demoDuties) {
      await repository.createTask(
        title: d.title,
        notes: d.notes,
        dueDateTime: d.dueDateTime,
        employeeName: d.employee,
        department: d.department,
        shiftType: d.shift,
      );
    }
  }
}
