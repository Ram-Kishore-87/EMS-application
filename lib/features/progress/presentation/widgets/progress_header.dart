import 'package:ems_app/core/theme/app_theme.dart';
import 'package:ems_app/features/progress/presentation/controllers/progress_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressHeader extends ConsumerWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyProgressAsync = ref.watch(weeklyProgressProvider);
    final dailyProgressAsync = ref.watch(dailyProgressProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withAlpha(35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.insights_rounded,
                        color: AppTheme.primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Weekly Performance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Mon – Sun completion rate',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                weeklyProgressAsync.when(
                  data: (summary) {
                    final color = summary.percentage >= 70
                        ? AppTheme.accentGreen
                        : (summary.percentage >= 40
                            ? AppTheme.accentAmber
                            : Colors.blueGrey);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withAlpha(35),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withAlpha(80)),
                      ),
                      child: Text(
                        summary.formattedPercentage,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, _) => const Text('0%'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Weekly Progress Bar
            weeklyProgressAsync.when(
              data: (summary) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: summary.ratio,
                      minHeight: 8,
                      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        summary.percentage >= 70
                            ? AppTheme.accentGreen
                            : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${summary.completedCount} of ${summary.totalCount} duties completed',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                      Text(
                        '${summary.pendingCount} pending',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const Divider(height: 24),
            // Daily Progress Quick Metric
            Row(
              children: [
                Expanded(
                  child: dailyProgressAsync.when(
                    data: (daily) => Row(
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            value: daily.ratio,
                            strokeWidth: 3.5,
                            backgroundColor:
                                isDark ? Colors.grey[800] : Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.accentAmber,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's Shift Progress: ${daily.formattedPercentage}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${daily.completedCount} done / ${daily.totalCount} total today',
                              style: TextStyle(
                                fontSize: 11,
                                color:
                                    isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    loading: () => const Text('Calculating today...'),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
