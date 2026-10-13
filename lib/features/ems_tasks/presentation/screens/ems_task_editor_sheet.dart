import 'package:ems_app/core/constants/app_constants.dart';
import 'package:ems_app/core/theme/app_theme.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/ems_tasks/data/database/database_provider.dart';
import 'package:ems_app/features/ems_tasks/domain/models/shift_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EmsTaskEditorSheet extends ConsumerStatefulWidget {
  final EmsTaskEntry? taskToEdit;

  const EmsTaskEditorSheet({super.key, this.taskToEdit});

  @override
  ConsumerState<EmsTaskEditorSheet> createState() => _EmsTaskEditorSheetState();
}

class _EmsTaskEditorSheetState extends ConsumerState<EmsTaskEditorSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late TextEditingController _employeeController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _selectedDepartment;
  late ShiftType _selectedShift;

  @override
  void initState() {
    super.initState();
    final task = widget.taskToEdit;

    _titleController = TextEditingController(text: task?.title ?? '');
    _notesController = TextEditingController(text: task?.notes ?? '');
    _employeeController = TextEditingController(text: task?.employeeName ?? '');

    final initialDateTime = task?.dueDateTime ?? DateTime.now().add(const Duration(hours: 1));
    _selectedDate = DateTime(initialDateTime.year, initialDateTime.month, initialDateTime.day);
    _selectedTime = TimeOfDay(hour: initialDateTime.hour, minute: initialDateTime.minute);

    _selectedDepartment = task?.department ?? AppConstants.defaultDepartments.first;
    _selectedShift = task != null ? ShiftType.fromString(task.shiftType) : ShiftType.morning;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _employeeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final dueDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final repo = ref.read(emsTaskRepositoryProvider);

    if (widget.taskToEdit == null) {
      await repo.createTask(
        title: _titleController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        dueDateTime: dueDateTime,
        employeeName: _employeeController.text,
        department: _selectedDepartment,
        shiftType: _selectedShift,
      );
    } else {
      await repo.updateTask(
        id: widget.taskToEdit!.id,
        title: _titleController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        dueDateTime: dueDateTime,
        employeeName: _employeeController.text,
        department: _selectedDepartment,
        shiftType: _selectedShift,
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Duty / Task' : 'Schedule New Duty',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Duty Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Duty / Task Title *',
                  hintText: 'e.g. ICU Equipment Audit & Restock',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.assignment_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              // Employee Name
              TextFormField(
                controller: _employeeController,
                decoration: const InputDecoration(
                  labelText: 'Assigned Employee *',
                  hintText: 'e.g. Alex Rivera',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Employee name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              // Department & Shift Row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedDepartment,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      items: AppConstants.defaultDepartments.map((dept) {
                        return DropdownMenuItem(value: dept, child: Text(dept));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedDepartment = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<ShiftType>(
                      initialValue: _selectedShift,
                      decoration: const InputDecoration(
                        labelText: 'Shift Type',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      items: ShiftType.values.map((s) {
                        return DropdownMenuItem(value: s, child: Text(s.label));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedShift = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Date & Time pickers
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(10),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Scheduled Date',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        child: Text(DateFormat('EEE, MMM d, y').format(_selectedDate)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _pickTime,
                      borderRadius: BorderRadius.circular(10),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time_outlined),
                        ),
                        child: Text(_selectedTime.format(context)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Optional Notes
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Optional Notes / Instructions',
                  hintText: 'Handover requirements, checklist details...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 20),
              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(
                    isEditing ? 'Save Changes' : 'Schedule Duty',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
