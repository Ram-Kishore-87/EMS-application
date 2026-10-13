import 'package:ems_app/core/constants/app_constants.dart';
import 'package:ems_app/core/extensions/date_time_extensions.dart';
import 'package:ems_app/core/theme/app_theme.dart';
import 'package:ems_app/core/utils/sample_data_seeder.dart';
import 'package:ems_app/features/ems_tasks/data/database/app_database.dart';
import 'package:ems_app/features/ems_tasks/data/database/database_provider.dart';
import 'package:ems_app/features/ems_tasks/domain/models/shift_type.dart';
import 'package:ems_app/features/ems_tasks/presentation/screens/ems_task_editor_sheet.dart';
import 'package:ems_app/features/ems_tasks/presentation/widgets/ems_task_tile.dart';
import 'package:ems_app/features/progress/presentation/controllers/progress_providers.dart';
import 'package:ems_app/features/progress/presentation/widgets/progress_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmsDashboardScreen extends ConsumerStatefulWidget {
  const EmsDashboardScreen({super.key});

  @override
  ConsumerState<EmsDashboardScreen> createState() => _EmsDashboardScreenState();
}

class _EmsDashboardScreenState extends ConsumerState<EmsDashboardScreen>
    with WidgetsBindingObserver {
  bool _hideCompleted = false;
  ShiftType? _selectedShiftFilter;
  String? _selectedDeptFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Midnight rollover & background resume re-sync
      ref.read(notificationSchedulerProvider).syncNotifications();
      ref.read(widgetSyncServiceProvider).syncWidgetData();
      ref.invalidate(todayTasksStreamProvider);
      ref.invalidate(weekTasksStreamProvider);
    }
  }

  void _openTaskEditor([EmsTaskEntry? task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EmsTaskEditorSheet(taskToEdit: task),
    );
  }

  Future<void> _seedDemoData() async {
    final repo = ref.read(emsTaskRepositoryProvider);
    await SampleDataSeeder.seedDemoDuties(repo);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sample EMS shift duties added!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _manualSync() async {
    final scheduler = ref.read(notificationSchedulerProvider);
    final widgetSync = ref.read(widgetSyncServiceProvider);
    await scheduler.syncNotifications();
    await widgetSync.syncWidgetData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Home widget and notifications resynced!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildSectionHeader({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 16, bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allTasksAsync = ref.watch(allTasksStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EMS Task Scheduler'),
            Text(
              'Employee Duty Management',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _hideCompleted ? 'Show completed' : 'Hide completed',
            icon: Icon(
              _hideCompleted ? Icons.check_circle : Icons.check_circle_outline,
              color: _hideCompleted ? AppTheme.accentGreen : null,
            ),
            onPressed: () => setState(() => _hideCompleted = !_hideCompleted),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (val) {
              if (val == 'seed') {
                _seedDemoData();
              } else if (val == 'sync') {
                _manualSync();
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'seed',
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 18, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Seed Demo Duties'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'sync',
                child: Row(
                  children: [
                    Icon(Icons.sync, size: 18),
                    SizedBox(width: 8),
                    Text('Sync Widget & Alarms'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allTasksStreamProvider);
          ref.invalidate(todayTasksStreamProvider);
          ref.invalidate(weekTasksStreamProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Weekly & Daily Progress Section (Single Source of Truth)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: ProgressHeader(),
              ),
            ),

            // Shift & Department Filter Chips
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // All Chip
                    FilterChip(
                      selected: _selectedShiftFilter == null && _selectedDeptFilter == null,
                      label: const Text('All Duties'),
                      onSelected: (_) {
                        setState(() {
                          _selectedShiftFilter = null;
                          _selectedDeptFilter = null;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    // Shifts
                    ...ShiftType.values.map((shift) {
                      final isSelected = _selectedShiftFilter == shift;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(shift.label),
                          onSelected: (selected) {
                            setState(() {
                              _selectedShiftFilter = selected ? shift : null;
                            });
                          },
                        ),
                      );
                    }),
                    // Departments
                    ...AppConstants.defaultDepartments.map((dept) {
                      final isSelected = _selectedDeptFilter == dept;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(dept),
                          onSelected: (selected) {
                            setState(() {
                              _selectedDeptFilter = selected ? dept : null;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Tasks List
            allTasksAsync.when(
              data: (tasks) {
                // Apply filters
                var filtered = tasks;
                if (_hideCompleted) {
                  filtered = filtered.where((t) => !t.isCompleted).toList();
                }
                if (_selectedShiftFilter != null) {
                  filtered = filtered
                      .where((t) =>
                          t.shiftType.toLowerCase() == _selectedShiftFilter!.name.toLowerCase())
                      .toList();
                }
                if (_selectedDeptFilter != null) {
                  filtered = filtered
                      .where((t) =>
                          t.department.toLowerCase() == _selectedDeptFilter!.toLowerCase())
                      .toList();
                }

                if (tasks.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 64,
                            color: Colors.grey.withAlpha(120),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No duties scheduled',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Tap the + button below to assign a duty',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (filtered.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.filter_alt_off_outlined,
                            size: 64,
                            color: Colors.grey.withAlpha(120),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No duties match your filter',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Reset your active filters to view duties',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final todayTasks = filtered.where((t) => t.dueDateTime.isToday).toList();
                final tomorrowTasks = filtered.where((t) => t.dueDateTime.isTomorrow).toList();
                final upcoming7DaysTasks = filtered.where((t) {
                  return !t.dueDateTime.isToday &&
                      !t.dueDateTime.isTomorrow &&
                      t.dueDateTime.isWithinNextDays(7);
                }).toList();
                final otherTasks = filtered.where((t) {
                  return !t.dueDateTime.isToday &&
                      !t.dueDateTime.isTomorrow &&
                      !t.dueDateTime.isWithinNextDays(7);
                }).toList();

                return SliverList(
                  delegate: SliverChildListDelegate([
                    // Today section
                    if (todayTasks.isNotEmpty) ...[
                      _buildSectionHeader(
                        title: 'Today',
                        count: todayTasks.length,
                        color: const Color(0xFF0284C7),
                        icon: Icons.today_rounded,
                      ),
                      ...todayTasks.map((t) => EmsTaskTile(
                            task: t,
                            onEdit: () => _openTaskEditor(t),
                          )),
                    ],

                    // Tomorrow section
                    if (tomorrowTasks.isNotEmpty) ...[
                      _buildSectionHeader(
                        title: 'Tomorrow',
                        count: tomorrowTasks.length,
                        color: const Color(0xFFD97706),
                        icon: Icons.wb_sunny_outlined,
                      ),
                      ...tomorrowTasks.map((t) => EmsTaskTile(
                            task: t,
                            onEdit: () => _openTaskEditor(t),
                          )),
                    ],

                    // Next 7 Days section
                    if (upcoming7DaysTasks.isNotEmpty) ...[
                      _buildSectionHeader(
                        title: 'Next 7 Days',
                        count: upcoming7DaysTasks.length,
                        color: const Color(0xFF059669),
                        icon: Icons.date_range_rounded,
                      ),
                      ...upcoming7DaysTasks.map((t) => EmsTaskTile(
                            task: t,
                            onEdit: () => _openTaskEditor(t),
                          )),
                    ],

                    // Future / Other section
                    if (otherTasks.isNotEmpty) ...[
                      _buildSectionHeader(
                        title: 'Later / Other Dates',
                        count: otherTasks.length,
                        color: Colors.blueGrey,
                        icon: Icons.more_time_rounded,
                      ),
                      ...otherTasks.map((t) => EmsTaskTile(
                            task: t,
                            onEdit: () => _openTaskEditor(t),
                          )),
                    ],

                    const SizedBox(height: 80), // Fab space
                  ]),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => SliverFillRemaining(
                child: Center(child: Text('Error loading tasks: $err')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Duty'),
        onPressed: () => _openTaskEditor(),
      ),
    );
  }
}
