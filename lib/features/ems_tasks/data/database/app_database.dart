import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:ems_app/features/ems_tasks/data/database/daos/ems_task_dao.dart';
import 'package:ems_app/features/ems_tasks/data/database/tables/ems_task_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [EmsTasks], daos: [EmsTaskDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'ems_tasks_db');
  }
}
