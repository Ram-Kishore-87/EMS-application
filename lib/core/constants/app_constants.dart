class AppConstants {
  static const String appName = 'EMS Task Scheduler';
  
  // Notification channels for Android
  static const String notificationChannelId = 'ems_duty_reminders_channel';
  static const String notificationChannelName = 'EMS Duty Reminders';
  static const String notificationChannelDescription =
      'High-importance alarm-style reminders for scheduled employee duties and shifts.';

  // iOS Notification Limit (iOS hard cap is 64; keep a safe buffer of 50-60)
  static const int maxPendingNotificationsIos = 50;

  // Departments
  static const List<String> defaultDepartments = [
    'Operations',
    'Customer Support',
    'Sales',
    'Engineering',
    'Logistics',
    'Administration',
  ];
}
