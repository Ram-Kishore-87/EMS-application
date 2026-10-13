import 'package:ems_app/core/extensions/date_time_extensions.dart';
import 'package:ems_app/core/theme/app_theme.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/ems_tasks/data/database/database_provider.dart';
import 'package:ems_app/features/ems_tasks/domain/models/shift_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EmsTaskTile extends ConsumerWidget {
  final EmsTaskEntry task;
  final VoidCallback onEdit;

  const EmsTaskTile({
    super.key,
    required this.task,
    required this.onEdit,
  });

  String _formatDateTime(DateTime dt) {
    final timeStr = DateFormat('h:mm a').format(dt);
    if (dt.isToday) {
      return 'Today at $timeStr';
    } else if (dt.isTomorrow) {
      return 'Tomorrow at $timeStr';
    } else {
      return '${DateFormat('EEE, MMM d').format(dt)} at $timeStr';
    }
  }

  Color _getShiftColor(ShiftType shift) {
    switch (shift) {
      case ShiftType.morning:
        return const Color(0xFF0284C7); // Sky
      case ShiftType.evening:
        return const Color(0xFFD97706); // Amber
      case ShiftType.night:
        return const Color(0xFF7C3AED); // Purple
      case ShiftType.general:
        return const Color(0xFF059669); // Emerald
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shift = ShiftType.fromString(task.shiftType);
    final shiftColor = _getShiftColor(shift);

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(200),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Duty?'),
                content: Text('Are you sure you want to remove "${task.title}"?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) {
        ref.read(emsTaskRepositoryProvider).deleteTask(task.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Completion Checkbox
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Checkbox(
                    value: task.isCompleted,
                    activeColor: AppTheme.accentGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(emsTaskRepositoryProvider)
                            .toggleTaskCompletion(task.id, val);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Task details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? (isDark ? Colors.grey[500] : Colors.grey[400])
                                    : null,
                              ),
                            ),
                          ),
                          // Time Pill
                          Text(
                            _formatDateTime(task.dueDateTime),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: task.dueDateTime.isToday
                                  ? (task.dueDateTime.isBefore(DateTime.now()) &&
                                          !task.isCompleted
                                      ? Colors.red
                                      : AppTheme.primaryColor)
                                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      if (task.notes != null && task.notes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.notes!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      // Meta Chips: Employee Name, Shift, Department
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          // Employee Chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.grey[100],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 13,
                                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.employeeName,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        isDark ? Colors.grey[300] : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Shift Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: shiftColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: shiftColor.withAlpha(80)),
                            ),
                            child: Text(
                              shift.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: shiftColor,
                              ),
                            ),
                          ),
                          // Department Chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.grey[100],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              task.department,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action Menu
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 18),
                  padding: EdgeInsets.zero,
                  onSelected: (action) {
                    if (action == 'edit') {
                      onEdit();
                    } else if (action == 'delete') {
                      ref.read(emsTaskRepositoryProvider).deleteTask(task.id);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
