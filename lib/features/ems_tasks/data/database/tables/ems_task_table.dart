import 'package:drift/drift.dart';

@DataClassName('EmsTaskEntry')
class EmsTasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get dueDateTime => dateTime()();
  TextColumn get employeeName => text().withLength(min: 1, max: 100)();
  TextColumn get department => text().withLength(min: 1, max: 100)();
  TextColumn get shiftType => text().withLength(min: 1, max: 50).withDefault(const Constant('general'))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
