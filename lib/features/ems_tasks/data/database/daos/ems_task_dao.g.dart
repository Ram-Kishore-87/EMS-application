// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ems_task_dao.dart';

// ignore_for_file: type=lint
mixin _$EmsTaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $EmsTasksTable get emsTasks => attachedDatabase.emsTasks;
  EmsTaskDaoManager get managers => EmsTaskDaoManager(this);
}

class EmsTaskDaoManager {
  final _$EmsTaskDaoMixin _db;
  EmsTaskDaoManager(this._db);
  $$EmsTasksTableTableManager get emsTasks =>
      $$EmsTasksTableTableManager(_db.attachedDatabase, _db.emsTasks);
}
