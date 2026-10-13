import 'package:ems_app/core/theme/app_theme.dart';
import 'package:ems_app/features/ems_tasks/presentation/screens/ems_dashboard_screen.dart';
import 'package:flutter/material.dart';

class EmsApp extends StatelessWidget {
  const EmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMS Task Scheduler',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const EmsDashboardScreen(),
    );
  }
}
