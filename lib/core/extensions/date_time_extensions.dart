extension DateTimeExtensions on DateTime {
  /// Start of the day (00:00:00.000)
  DateTime get startOfDay => DateTime(year, month, day);

  /// End of the day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Start of the week (Monday 00:00:00.000)
  DateTime get startOfWeek {
    // DateTime.weekday: Monday = 1, Sunday = 7
    final diff = weekday - DateTime.monday;
    return subtract(Duration(days: diff)).startOfDay;
  }

  /// End of the week (Sunday 23:59:59.999)
  DateTime get endOfWeek {
    final diff = DateTime.sunday - weekday;
    return add(Duration(days: diff)).endOfDay;
  }

  /// Whether this DateTime is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Whether this DateTime is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Whether this DateTime is within the next [days] days from now
  bool isWithinNextDays(int days) {
    final now = DateTime.now().startOfDay;
    final limit = now.add(Duration(days: days)).endOfDay;
    return !isBefore(now) && !isAfter(limit);
  }
}
