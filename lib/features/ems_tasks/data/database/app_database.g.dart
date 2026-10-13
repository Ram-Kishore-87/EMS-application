// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EmsTasksTable extends EmsTasks
    with TableInfo<$EmsTasksTable, EmsTaskEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmsTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateTimeMeta = const VerificationMeta(
    'dueDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> dueDateTime = GeneratedColumn<DateTime>(
    'due_date_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeNameMeta = const VerificationMeta(
    'employeeName',
  );
  @override
  late final GeneratedColumn<String> employeeName = GeneratedColumn<String>(
    'employee_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftTypeMeta = const VerificationMeta(
    'shiftType',
  );
  @override
  late final GeneratedColumn<String> shiftType = GeneratedColumn<String>(
    'shift_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    notes,
    dueDateTime,
    employeeName,
    department,
    shiftType,
    isCompleted,
    completedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ems_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmsTaskEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('due_date_time')) {
      context.handle(
        _dueDateTimeMeta,
        dueDateTime.isAcceptableOrUnknown(
          data['due_date_time']!,
          _dueDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dueDateTimeMeta);
    }
    if (data.containsKey('employee_name')) {
      context.handle(
        _employeeNameMeta,
        employeeName.isAcceptableOrUnknown(
          data['employee_name']!,
          _employeeNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_employeeNameMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    } else if (isInserting) {
      context.missing(_departmentMeta);
    }
    if (data.containsKey('shift_type')) {
      context.handle(
        _shiftTypeMeta,
        shiftType.isAcceptableOrUnknown(data['shift_type']!, _shiftTypeMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmsTaskEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmsTaskEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      dueDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date_time'],
      )!,
      employeeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_name'],
      )!,
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      )!,
      shiftType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_type'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EmsTasksTable createAlias(String alias) {
    return $EmsTasksTable(attachedDatabase, alias);
  }
}

class EmsTaskEntry extends DataClass implements Insertable<EmsTaskEntry> {
  final String id;
  final String title;
  final String? notes;
  final DateTime dueDateTime;
  final String employeeName;
  final String department;
  final String shiftType;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const EmsTaskEntry({
    required this.id,
    required this.title,
    this.notes,
    required this.dueDateTime,
    required this.employeeName,
    required this.department,
    required this.shiftType,
    required this.isCompleted,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['due_date_time'] = Variable<DateTime>(dueDateTime);
    map['employee_name'] = Variable<String>(employeeName);
    map['department'] = Variable<String>(department);
    map['shift_type'] = Variable<String>(shiftType);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EmsTasksCompanion toCompanion(bool nullToAbsent) {
    return EmsTasksCompanion(
      id: Value(id),
      title: Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      dueDateTime: Value(dueDateTime),
      employeeName: Value(employeeName),
      department: Value(department),
      shiftType: Value(shiftType),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EmsTaskEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmsTaskEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      dueDateTime: serializer.fromJson<DateTime>(json['dueDateTime']),
      employeeName: serializer.fromJson<String>(json['employeeName']),
      department: serializer.fromJson<String>(json['department']),
      shiftType: serializer.fromJson<String>(json['shiftType']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'dueDateTime': serializer.toJson<DateTime>(dueDateTime),
      'employeeName': serializer.toJson<String>(employeeName),
      'department': serializer.toJson<String>(department),
      'shiftType': serializer.toJson<String>(shiftType),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EmsTaskEntry copyWith({
    String? id,
    String? title,
    Value<String?> notes = const Value.absent(),
    DateTime? dueDateTime,
    String? employeeName,
    String? department,
    String? shiftType,
    bool? isCompleted,
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EmsTaskEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    notes: notes.present ? notes.value : this.notes,
    dueDateTime: dueDateTime ?? this.dueDateTime,
    employeeName: employeeName ?? this.employeeName,
    department: department ?? this.department,
    shiftType: shiftType ?? this.shiftType,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EmsTaskEntry copyWithCompanion(EmsTasksCompanion data) {
    return EmsTaskEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      dueDateTime: data.dueDateTime.present
          ? data.dueDateTime.value
          : this.dueDateTime,
      employeeName: data.employeeName.present
          ? data.employeeName.value
          : this.employeeName,
      department: data.department.present
          ? data.department.value
          : this.department,
      shiftType: data.shiftType.present ? data.shiftType.value : this.shiftType,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmsTaskEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('dueDateTime: $dueDateTime, ')
          ..write('employeeName: $employeeName, ')
          ..write('department: $department, ')
          ..write('shiftType: $shiftType, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    notes,
    dueDateTime,
    employeeName,
    department,
    shiftType,
    isCompleted,
    completedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmsTaskEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.dueDateTime == this.dueDateTime &&
          other.employeeName == this.employeeName &&
          other.department == this.department &&
          other.shiftType == this.shiftType &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmsTasksCompanion extends UpdateCompanion<EmsTaskEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> notes;
  final Value<DateTime> dueDateTime;
  final Value<String> employeeName;
  final Value<String> department;
  final Value<String> shiftType;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EmsTasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.dueDateTime = const Value.absent(),
    this.employeeName = const Value.absent(),
    this.department = const Value.absent(),
    this.shiftType = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmsTasksCompanion.insert({
    required String id,
    required String title,
    this.notes = const Value.absent(),
    required DateTime dueDateTime,
    required String employeeName,
    required String department,
    this.shiftType = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       dueDateTime = Value(dueDateTime),
       employeeName = Value(employeeName),
       department = Value(department),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<EmsTaskEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<DateTime>? dueDateTime,
    Expression<String>? employeeName,
    Expression<String>? department,
    Expression<String>? shiftType,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (dueDateTime != null) 'due_date_time': dueDateTime,
      if (employeeName != null) 'employee_name': employeeName,
      if (department != null) 'department': department,
      if (shiftType != null) 'shift_type': shiftType,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmsTasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? notes,
    Value<DateTime>? dueDateTime,
    Value<String>? employeeName,
    Value<String>? department,
    Value<String>? shiftType,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return EmsTasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      dueDateTime: dueDateTime ?? this.dueDateTime,
      employeeName: employeeName ?? this.employeeName,
      department: department ?? this.department,
      shiftType: shiftType ?? this.shiftType,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (dueDateTime.present) {
      map['due_date_time'] = Variable<DateTime>(dueDateTime.value);
    }
    if (employeeName.present) {
      map['employee_name'] = Variable<String>(employeeName.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (shiftType.present) {
      map['shift_type'] = Variable<String>(shiftType.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmsTasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('dueDateTime: $dueDateTime, ')
          ..write('employeeName: $employeeName, ')
          ..write('department: $department, ')
          ..write('shiftType: $shiftType, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EmsTasksTable emsTasks = $EmsTasksTable(this);
  late final EmsTaskDao emsTaskDao = EmsTaskDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [emsTasks];
}

typedef $$EmsTasksTableCreateCompanionBuilder = EmsTasksCompanion Function({
  required String id,
  required String title,
  Value<String?> notes,
  required DateTime dueDateTime,
  required String employeeName,
  required String department,
  Value<String> shiftType,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$EmsTasksTableUpdateCompanionBuilder = EmsTasksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> notes,
  Value<DateTime> dueDateTime,
  Value<String> employeeName,
  Value<String> department,
  Value<String> shiftType,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$EmsTasksTableFilterComposer
    extends Composer<_$AppDatabase, $EmsTasksTable> {
  $$EmsTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDateTime => $composableBuilder(
    column: $table.dueDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeName => $composableBuilder(
    column: $table.employeeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftType => $composableBuilder(
    column: $table.shiftType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmsTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $EmsTasksTable> {
  $$EmsTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDateTime => $composableBuilder(
    column: $table.dueDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeName => $composableBuilder(
    column: $table.employeeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftType => $composableBuilder(
    column: $table.shiftType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmsTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmsTasksTable> {
  $$EmsTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDateTime => $composableBuilder(
    column: $table.dueDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get employeeName => $composableBuilder(
    column: $table.employeeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shiftType =>
      $composableBuilder(column: $table.shiftType, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EmsTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmsTasksTable,
          EmsTaskEntry,
          $$EmsTasksTableFilterComposer,
          $$EmsTasksTableOrderingComposer,
          $$EmsTasksTableAnnotationComposer,
          $$EmsTasksTableCreateCompanionBuilder,
          $$EmsTasksTableUpdateCompanionBuilder,
          (
            EmsTaskEntry,
            BaseReferences<_$AppDatabase, $EmsTasksTable, EmsTaskEntry>,
          ),
          EmsTaskEntry,
          PrefetchHooks Function()
        > {
  $$EmsTasksTableTableManager(_$AppDatabase db, $EmsTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmsTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmsTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmsTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> dueDateTime = const Value.absent(),
                Value<String> employeeName = const Value.absent(),
                Value<String> department = const Value.absent(),
                Value<String> shiftType = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmsTasksCompanion(
                id: id,
                title: title,
                notes: notes,
                dueDateTime: dueDateTime,
                employeeName: employeeName,
                department: department,
                shiftType: shiftType,
                isCompleted: isCompleted,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> notes = const Value.absent(),
                required DateTime dueDateTime,
                required String employeeName,
                required String department,
                Value<String> shiftType = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => EmsTasksCompanion.insert(
                id: id,
                title: title,
                notes: notes,
                dueDateTime: dueDateTime,
                employeeName: employeeName,
                department: department,
                shiftType: shiftType,
                isCompleted: isCompleted,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmsTasksTable, EmsTaskEntry>(table),
                  BaseReferences<_$AppDatabase, $EmsTasksTable, EmsTaskEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmsTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmsTasksTable,
      EmsTaskEntry,
      $$EmsTasksTableFilterComposer,
      $$EmsTasksTableOrderingComposer,
      $$EmsTasksTableAnnotationComposer,
      $$EmsTasksTableCreateCompanionBuilder,
      $$EmsTasksTableUpdateCompanionBuilder,
      (
        EmsTaskEntry,
        BaseReferences<_$AppDatabase, $EmsTasksTable, EmsTaskEntry>,
      ),
      EmsTaskEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EmsTasksTableTableManager get emsTasks =>
      $$EmsTasksTableTableManager(_db, _db.emsTasks);
}
