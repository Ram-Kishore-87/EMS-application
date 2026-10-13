enum ShiftType {
  morning('Morning Shift', '08:00 - 16:00'),
  evening('Evening Shift', '16:00 - 00:00'),
  night('Night Shift', '00:00 - 08:00'),
  general('General Shift', '09:00 - 18:00');

  final String label;
  final String timing;

  const ShiftType(this.label, this.timing);

  static ShiftType fromString(String? value) {
    return ShiftType.values.firstWhere(
      (e) => e.name.toLowerCase() == (value ?? '').toLowerCase(),
      orElse: () => ShiftType.general,
    );
  }
}
