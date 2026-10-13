import 'package:ems_app/core/theme/app_theme.dart';
import 'package:ems_app/features/progress/domain/progress_calculator.dart';
import 'package:ems_app/features/progress/presentation/controllers/progress_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerformanceBreakdownSheet extends ConsumerWidget {
  const PerformanceBreakdownSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekTasksAsync = ref.watch(weekTasksStreamProvider);
    final weeklyProgressAsync = ref.watch(weeklyProgressProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance Analytics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Department & Staff Weekly Completion',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Overall Summary Card
            weeklyProgressAsync.when(
              data: (summary) => Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryColor.withAlpha(60)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Weekly Rate', summary.formattedPercentage, AppTheme.primaryColor),
                    _buildStatItem('Completed', '${summary.completedCount}', AppTheme.accentGreen),
                    _buildStatItem('Pending', '${summary.pendingCount}', AppTheme.accentAmber),
                    _buildStatItem('Total Duties', '${summary.totalCount}', isDark ? Colors.white : Colors.black87),
                  ],
                ),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 20),

            weekTasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: Text(
                        'No duties scheduled for this week',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                // Extract unique departments & staff
                final departments = tasks.map((t) => t.department).toSet().toList()..sort();
                final employees = tasks.map((t) => t.employeeName).toSet().toList()..sort();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Departments Section
                    const Text(
                      'DEPARTMENT PERFORMANCE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...departments.map((dept) {
                      final summary = ProgressCalculator.calculateDepartmentWeeklyProgress(tasks, dept);
                      return _buildProgressBarRow(
                        label: dept,
                        summary: summary,
                        icon: Icons.domain_rounded,
                        isDark: isDark,
                      );
                    }),

                    const Divider(height: 28),

                    // Staff Section
                    const Text(
                      'EMPLOYEE PERFORMANCE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...employees.map((emp) {
                      final summary = ProgressCalculator.calculateEmployeeWeeklyProgress(tasks, emp);
                      return _buildProgressBarRow(
                        label: emp,
                        summary: summary,
                        icon: Icons.person_outline,
                        isDark: isDark,
                      );
                    }),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading stats: $err'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildProgressBarRow({
    required String label,
    required ProgressSummary summary,
    required IconData icon,
    required bool isDark,
  }) {
    final color = summary.percentage >= 75
        ? AppTheme.accentGreen
        : (summary.percentage >= 40 ? AppTheme.accentAmber : AppTheme.primaryColor);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: isDark ? Colors.grey[400] : Colors.grey[600]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '${summary.completedCount}/${summary.totalCount} (${summary.formattedPercentage})',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: summary.ratio,
              minHeight: 6,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
