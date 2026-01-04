// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MandalartsTable extends Mandalarts
    with TableInfo<$MandalartsTable, MandalartEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MandalartsTable(this.attachedDatabase, [this._alias]);
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateRangeLabelMeta = const VerificationMeta(
    'dateRangeLabel',
  );
  @override
  late final GeneratedColumn<String> dateRangeLabel = GeneratedColumn<String>(
    'date_range_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    emoji,
    dateRangeLabel,
    isPinned,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mandalarts';
  @override
  VerificationContext validateIntegrity(
    Insertable<MandalartEntity> instance, {
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
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('date_range_label')) {
      context.handle(
        _dateRangeLabelMeta,
        dateRangeLabel.isAcceptableOrUnknown(
          data['date_range_label']!,
          _dateRangeLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateRangeLabelMeta);
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
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
  MandalartEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MandalartEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      ),
      dateRangeLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_range_label'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
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
  $MandalartsTable createAlias(String alias) {
    return $MandalartsTable(attachedDatabase, alias);
  }
}

class MandalartEntity extends DataClass implements Insertable<MandalartEntity> {
  final String id;
  final String title;
  final String? emoji;
  final String dateRangeLabel;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MandalartEntity({
    required this.id,
    required this.title,
    this.emoji,
    required this.dateRangeLabel,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    map['date_range_label'] = Variable<String>(dateRangeLabel);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MandalartsCompanion toCompanion(bool nullToAbsent) {
    return MandalartsCompanion(
      id: Value(id),
      title: Value(title),
      emoji: emoji == null && nullToAbsent
          ? const Value.absent()
          : Value(emoji),
      dateRangeLabel: Value(dateRangeLabel),
      isPinned: Value(isPinned),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MandalartEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MandalartEntity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      emoji: serializer.fromJson<String?>(json['emoji']),
      dateRangeLabel: serializer.fromJson<String>(json['dateRangeLabel']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
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
      'emoji': serializer.toJson<String?>(emoji),
      'dateRangeLabel': serializer.toJson<String>(dateRangeLabel),
      'isPinned': serializer.toJson<bool>(isPinned),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MandalartEntity copyWith({
    String? id,
    String? title,
    Value<String?> emoji = const Value.absent(),
    String? dateRangeLabel,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MandalartEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    emoji: emoji.present ? emoji.value : this.emoji,
    dateRangeLabel: dateRangeLabel ?? this.dateRangeLabel,
    isPinned: isPinned ?? this.isPinned,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MandalartEntity copyWithCompanion(MandalartsCompanion data) {
    return MandalartEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      dateRangeLabel: data.dateRangeLabel.present
          ? data.dateRangeLabel.value
          : this.dateRangeLabel,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MandalartEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('emoji: $emoji, ')
          ..write('dateRangeLabel: $dateRangeLabel, ')
          ..write('isPinned: $isPinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    emoji,
    dateRangeLabel,
    isPinned,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MandalartEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.emoji == this.emoji &&
          other.dateRangeLabel == this.dateRangeLabel &&
          other.isPinned == this.isPinned &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MandalartsCompanion extends UpdateCompanion<MandalartEntity> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> emoji;
  final Value<String> dateRangeLabel;
  final Value<bool> isPinned;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MandalartsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.emoji = const Value.absent(),
    this.dateRangeLabel = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MandalartsCompanion.insert({
    required String id,
    required String title,
    this.emoji = const Value.absent(),
    required String dateRangeLabel,
    this.isPinned = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       dateRangeLabel = Value(dateRangeLabel),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MandalartEntity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? emoji,
    Expression<String>? dateRangeLabel,
    Expression<bool>? isPinned,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (emoji != null) 'emoji': emoji,
      if (dateRangeLabel != null) 'date_range_label': dateRangeLabel,
      if (isPinned != null) 'is_pinned': isPinned,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MandalartsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? emoji,
    Value<String>? dateRangeLabel,
    Value<bool>? isPinned,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MandalartsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      dateRangeLabel: dateRangeLabel ?? this.dateRangeLabel,
      isPinned: isPinned ?? this.isPinned,
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
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (dateRangeLabel.present) {
      map['date_range_label'] = Variable<String>(dateRangeLabel.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
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
    return (StringBuffer('MandalartsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('emoji: $emoji, ')
          ..write('dateRangeLabel: $dateRangeLabel, ')
          ..write('isPinned: $isPinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, GoalEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mandalartIdMeta = const VerificationMeta(
    'mandalartId',
  );
  @override
  late final GeneratedColumn<String> mandalartId = GeneratedColumn<String>(
    'mandalart_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gridIndexMeta = const VerificationMeta(
    'gridIndex',
  );
  @override
  late final GeneratedColumn<int> gridIndex = GeneratedColumn<int>(
    'grid_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalTextMeta = const VerificationMeta(
    'goalText',
  );
  @override
  late final GeneratedColumn<String> goalText = GeneratedColumn<String>(
    'goal_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
    mandalartId,
    gridIndex,
    goalText,
    status,
    memo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mandalart_id')) {
      context.handle(
        _mandalartIdMeta,
        mandalartId.isAcceptableOrUnknown(
          data['mandalart_id']!,
          _mandalartIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mandalartIdMeta);
    }
    if (data.containsKey('grid_index')) {
      context.handle(
        _gridIndexMeta,
        gridIndex.isAcceptableOrUnknown(data['grid_index']!, _gridIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_gridIndexMeta);
    }
    if (data.containsKey('goal_text')) {
      context.handle(
        _goalTextMeta,
        goalText.isAcceptableOrUnknown(data['goal_text']!, _goalTextMeta),
      );
    } else if (isInserting) {
      context.missing(_goalTextMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
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
  GoalEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mandalartId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mandalart_id'],
      )!,
      gridIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grid_index'],
      )!,
      goalText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_text'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
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
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class GoalEntity extends DataClass implements Insertable<GoalEntity> {
  final String id;
  final String mandalartId;
  final int gridIndex;
  final String goalText;
  final int status;
  final String? memo;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GoalEntity({
    required this.id,
    required this.mandalartId,
    required this.gridIndex,
    required this.goalText,
    required this.status,
    this.memo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mandalart_id'] = Variable<String>(mandalartId);
    map['grid_index'] = Variable<int>(gridIndex);
    map['goal_text'] = Variable<String>(goalText);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      mandalartId: Value(mandalartId),
      gridIndex: Value(gridIndex),
      goalText: Value(goalText),
      status: Value(status),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GoalEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalEntity(
      id: serializer.fromJson<String>(json['id']),
      mandalartId: serializer.fromJson<String>(json['mandalartId']),
      gridIndex: serializer.fromJson<int>(json['gridIndex']),
      goalText: serializer.fromJson<String>(json['goalText']),
      status: serializer.fromJson<int>(json['status']),
      memo: serializer.fromJson<String?>(json['memo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mandalartId': serializer.toJson<String>(mandalartId),
      'gridIndex': serializer.toJson<int>(gridIndex),
      'goalText': serializer.toJson<String>(goalText),
      'status': serializer.toJson<int>(status),
      'memo': serializer.toJson<String?>(memo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GoalEntity copyWith({
    String? id,
    String? mandalartId,
    int? gridIndex,
    String? goalText,
    int? status,
    Value<String?> memo = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GoalEntity(
    id: id ?? this.id,
    mandalartId: mandalartId ?? this.mandalartId,
    gridIndex: gridIndex ?? this.gridIndex,
    goalText: goalText ?? this.goalText,
    status: status ?? this.status,
    memo: memo.present ? memo.value : this.memo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GoalEntity copyWithCompanion(GoalsCompanion data) {
    return GoalEntity(
      id: data.id.present ? data.id.value : this.id,
      mandalartId: data.mandalartId.present
          ? data.mandalartId.value
          : this.mandalartId,
      gridIndex: data.gridIndex.present ? data.gridIndex.value : this.gridIndex,
      goalText: data.goalText.present ? data.goalText.value : this.goalText,
      status: data.status.present ? data.status.value : this.status,
      memo: data.memo.present ? data.memo.value : this.memo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalEntity(')
          ..write('id: $id, ')
          ..write('mandalartId: $mandalartId, ')
          ..write('gridIndex: $gridIndex, ')
          ..write('goalText: $goalText, ')
          ..write('status: $status, ')
          ..write('memo: $memo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mandalartId,
    gridIndex,
    goalText,
    status,
    memo,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalEntity &&
          other.id == this.id &&
          other.mandalartId == this.mandalartId &&
          other.gridIndex == this.gridIndex &&
          other.goalText == this.goalText &&
          other.status == this.status &&
          other.memo == this.memo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GoalsCompanion extends UpdateCompanion<GoalEntity> {
  final Value<String> id;
  final Value<String> mandalartId;
  final Value<int> gridIndex;
  final Value<String> goalText;
  final Value<int> status;
  final Value<String?> memo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.mandalartId = const Value.absent(),
    this.gridIndex = const Value.absent(),
    this.goalText = const Value.absent(),
    this.status = const Value.absent(),
    this.memo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String mandalartId,
    required int gridIndex,
    required String goalText,
    required int status,
    this.memo = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mandalartId = Value(mandalartId),
       gridIndex = Value(gridIndex),
       goalText = Value(goalText),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GoalEntity> custom({
    Expression<String>? id,
    Expression<String>? mandalartId,
    Expression<int>? gridIndex,
    Expression<String>? goalText,
    Expression<int>? status,
    Expression<String>? memo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mandalartId != null) 'mandalart_id': mandalartId,
      if (gridIndex != null) 'grid_index': gridIndex,
      if (goalText != null) 'goal_text': goalText,
      if (status != null) 'status': status,
      if (memo != null) 'memo': memo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? mandalartId,
    Value<int>? gridIndex,
    Value<String>? goalText,
    Value<int>? status,
    Value<String?>? memo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      mandalartId: mandalartId ?? this.mandalartId,
      gridIndex: gridIndex ?? this.gridIndex,
      goalText: goalText ?? this.goalText,
      status: status ?? this.status,
      memo: memo ?? this.memo,
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
    if (mandalartId.present) {
      map['mandalart_id'] = Variable<String>(mandalartId.value);
    }
    if (gridIndex.present) {
      map['grid_index'] = Variable<int>(gridIndex.value);
    }
    if (goalText.present) {
      map['goal_text'] = Variable<String>(goalText.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
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
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('mandalartId: $mandalartId, ')
          ..write('gridIndex: $gridIndex, ')
          ..write('goalText: $goalText, ')
          ..write('status: $status, ')
          ..write('memo: $memo, ')
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
  late final $MandalartsTable mandalarts = $MandalartsTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [mandalarts, goals];
}

typedef $$MandalartsTableCreateCompanionBuilder =
    MandalartsCompanion Function({
      required String id,
      required String title,
      Value<String?> emoji,
      required String dateRangeLabel,
      Value<bool> isPinned,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MandalartsTableUpdateCompanionBuilder =
    MandalartsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> emoji,
      Value<String> dateRangeLabel,
      Value<bool> isPinned,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$MandalartsTableFilterComposer
    extends Composer<_$AppDatabase, $MandalartsTable> {
  $$MandalartsTableFilterComposer({
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

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateRangeLabel => $composableBuilder(
    column: $table.dateRangeLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
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

class $$MandalartsTableOrderingComposer
    extends Composer<_$AppDatabase, $MandalartsTable> {
  $$MandalartsTableOrderingComposer({
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

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateRangeLabel => $composableBuilder(
    column: $table.dateRangeLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
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

class $$MandalartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MandalartsTable> {
  $$MandalartsTableAnnotationComposer({
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

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get dateRangeLabel => $composableBuilder(
    column: $table.dateRangeLabel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MandalartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MandalartsTable,
          MandalartEntity,
          $$MandalartsTableFilterComposer,
          $$MandalartsTableOrderingComposer,
          $$MandalartsTableAnnotationComposer,
          $$MandalartsTableCreateCompanionBuilder,
          $$MandalartsTableUpdateCompanionBuilder,
          (
            MandalartEntity,
            BaseReferences<_$AppDatabase, $MandalartsTable, MandalartEntity>,
          ),
          MandalartEntity,
          PrefetchHooks Function()
        > {
  $$MandalartsTableTableManager(_$AppDatabase db, $MandalartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MandalartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MandalartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MandalartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<String> dateRangeLabel = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MandalartsCompanion(
                id: id,
                title: title,
                emoji: emoji,
                dateRangeLabel: dateRangeLabel,
                isPinned: isPinned,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> emoji = const Value.absent(),
                required String dateRangeLabel,
                Value<bool> isPinned = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MandalartsCompanion.insert(
                id: id,
                title: title,
                emoji: emoji,
                dateRangeLabel: dateRangeLabel,
                isPinned: isPinned,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MandalartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MandalartsTable,
      MandalartEntity,
      $$MandalartsTableFilterComposer,
      $$MandalartsTableOrderingComposer,
      $$MandalartsTableAnnotationComposer,
      $$MandalartsTableCreateCompanionBuilder,
      $$MandalartsTableUpdateCompanionBuilder,
      (
        MandalartEntity,
        BaseReferences<_$AppDatabase, $MandalartsTable, MandalartEntity>,
      ),
      MandalartEntity,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableCreateCompanionBuilder =
    GoalsCompanion Function({
      required String id,
      required String mandalartId,
      required int gridIndex,
      required String goalText,
      required int status,
      Value<String?> memo,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GoalsTableUpdateCompanionBuilder =
    GoalsCompanion Function({
      Value<String> id,
      Value<String> mandalartId,
      Value<int> gridIndex,
      Value<String> goalText,
      Value<int> status,
      Value<String?> memo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
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

  ColumnFilters<String> get mandalartId => $composableBuilder(
    column: $table.mandalartId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gridIndex => $composableBuilder(
    column: $table.gridIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalText => $composableBuilder(
    column: $table.goalText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
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

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
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

  ColumnOrderings<String> get mandalartId => $composableBuilder(
    column: $table.mandalartId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gridIndex => $composableBuilder(
    column: $table.gridIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalText => $composableBuilder(
    column: $table.goalText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
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

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mandalartId => $composableBuilder(
    column: $table.mandalartId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gridIndex =>
      $composableBuilder(column: $table.gridIndex, builder: (column) => column);

  GeneratedColumn<String> get goalText =>
      $composableBuilder(column: $table.goalText, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          GoalEntity,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (GoalEntity, BaseReferences<_$AppDatabase, $GoalsTable, GoalEntity>),
          GoalEntity,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mandalartId = const Value.absent(),
                Value<int> gridIndex = const Value.absent(),
                Value<String> goalText = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                mandalartId: mandalartId,
                gridIndex: gridIndex,
                goalText: goalText,
                status: status,
                memo: memo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mandalartId,
                required int gridIndex,
                required String goalText,
                required int status,
                Value<String?> memo = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                mandalartId: mandalartId,
                gridIndex: gridIndex,
                goalText: goalText,
                status: status,
                memo: memo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      GoalEntity,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (GoalEntity, BaseReferences<_$AppDatabase, $GoalsTable, GoalEntity>),
      GoalEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MandalartsTableTableManager get mandalarts =>
      $$MandalartsTableTableManager(_db, _db.mandalarts);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
}
