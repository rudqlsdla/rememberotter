// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GroupsTable extends Groups with TableInfo<$GroupsTable, GroupData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    name,
    colorValue,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
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
  GroupData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
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
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class GroupData extends DataClass implements Insertable<GroupData> {
  final String id;
  final String name;
  final int colorValue;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GroupData({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color_value'] = Variable<int>(colorValue);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      name: Value(name),
      colorValue: Value(colorValue),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GroupData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int>(colorValue),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GroupData copyWith({
    String? id,
    String? name,
    int? colorValue,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GroupData(
    id: id ?? this.id,
    name: name ?? this.name,
    colorValue: colorValue ?? this.colorValue,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GroupData copyWithCompanion(GroupsCompanion data) {
    return GroupData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, colorValue, sortOrder, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupData &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorValue == this.colorValue &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GroupsCompanion extends UpdateCompanion<GroupData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> colorValue;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsCompanion.insert({
    required String id,
    required String name,
    required int colorValue,
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       colorValue = Value(colorValue),
       sortOrder = Value(sortOrder),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GroupData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? colorValue,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
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
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BirthdaysTable extends Birthdays
    with TableInfo<$BirthdaysTable, BirthdayData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BirthdaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _profileImageMeta = const VerificationMeta(
    'profileImage',
  );
  @override
  late final GeneratedColumn<String> profileImage = GeneratedColumn<String>(
    'profile_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _isLunarCalendarMeta = const VerificationMeta(
    'isLunarCalendar',
  );
  @override
  late final GeneratedColumn<bool> isLunarCalendar = GeneratedColumn<bool>(
    'is_lunar_calendar',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_lunar_calendar" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notificationEnabledMeta =
      const VerificationMeta('notificationEnabled');
  @override
  late final GeneratedColumn<bool> notificationEnabled = GeneratedColumn<bool>(
    'notification_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notification_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notificationDaysBeforeMeta =
      const VerificationMeta('notificationDaysBefore');
  @override
  late final GeneratedColumn<int> notificationDaysBefore = GeneratedColumn<int>(
    'notification_days_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
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
    name,
    birthDate,
    memo,
    profileImage,
    groupId,
    isLunarCalendar,
    notificationEnabled,
    notificationDaysBefore,
    phoneNumber,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'birthdays';
  @override
  VerificationContext validateIntegrity(
    Insertable<BirthdayData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('profile_image')) {
      context.handle(
        _profileImageMeta,
        profileImage.isAcceptableOrUnknown(
          data['profile_image']!,
          _profileImageMeta,
        ),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('is_lunar_calendar')) {
      context.handle(
        _isLunarCalendarMeta,
        isLunarCalendar.isAcceptableOrUnknown(
          data['is_lunar_calendar']!,
          _isLunarCalendarMeta,
        ),
      );
    }
    if (data.containsKey('notification_enabled')) {
      context.handle(
        _notificationEnabledMeta,
        notificationEnabled.isAcceptableOrUnknown(
          data['notification_enabled']!,
          _notificationEnabledMeta,
        ),
      );
    }
    if (data.containsKey('notification_days_before')) {
      context.handle(
        _notificationDaysBeforeMeta,
        notificationDaysBefore.isAcceptableOrUnknown(
          data['notification_days_before']!,
          _notificationDaysBeforeMeta,
        ),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
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
  BirthdayData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BirthdayData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      profileImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_image'],
      ),
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      ),
      isLunarCalendar: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_lunar_calendar'],
      )!,
      notificationEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notification_enabled'],
      )!,
      notificationDaysBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_days_before'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
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
  $BirthdaysTable createAlias(String alias) {
    return $BirthdaysTable(attachedDatabase, alias);
  }
}

class BirthdayData extends DataClass implements Insertable<BirthdayData> {
  final String id;
  final String name;
  final DateTime birthDate;
  final String? memo;
  final String? profileImage;
  final String? groupId;
  final bool isLunarCalendar;
  final bool notificationEnabled;
  final int notificationDaysBefore;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BirthdayData({
    required this.id,
    required this.name,
    required this.birthDate,
    this.memo,
    this.profileImage,
    this.groupId,
    required this.isLunarCalendar,
    required this.notificationEnabled,
    required this.notificationDaysBefore,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['birth_date'] = Variable<DateTime>(birthDate);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || profileImage != null) {
      map['profile_image'] = Variable<String>(profileImage);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['is_lunar_calendar'] = Variable<bool>(isLunarCalendar);
    map['notification_enabled'] = Variable<bool>(notificationEnabled);
    map['notification_days_before'] = Variable<int>(notificationDaysBefore);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BirthdaysCompanion toCompanion(bool nullToAbsent) {
    return BirthdaysCompanion(
      id: Value(id),
      name: Value(name),
      birthDate: Value(birthDate),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      profileImage: profileImage == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImage),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      isLunarCalendar: Value(isLunarCalendar),
      notificationEnabled: Value(notificationEnabled),
      notificationDaysBefore: Value(notificationDaysBefore),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BirthdayData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BirthdayData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      memo: serializer.fromJson<String?>(json['memo']),
      profileImage: serializer.fromJson<String?>(json['profileImage']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      isLunarCalendar: serializer.fromJson<bool>(json['isLunarCalendar']),
      notificationEnabled: serializer.fromJson<bool>(
        json['notificationEnabled'],
      ),
      notificationDaysBefore: serializer.fromJson<int>(
        json['notificationDaysBefore'],
      ),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'memo': serializer.toJson<String?>(memo),
      'profileImage': serializer.toJson<String?>(profileImage),
      'groupId': serializer.toJson<String?>(groupId),
      'isLunarCalendar': serializer.toJson<bool>(isLunarCalendar),
      'notificationEnabled': serializer.toJson<bool>(notificationEnabled),
      'notificationDaysBefore': serializer.toJson<int>(notificationDaysBefore),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BirthdayData copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    Value<String?> memo = const Value.absent(),
    Value<String?> profileImage = const Value.absent(),
    Value<String?> groupId = const Value.absent(),
    bool? isLunarCalendar,
    bool? notificationEnabled,
    int? notificationDaysBefore,
    Value<String?> phoneNumber = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BirthdayData(
    id: id ?? this.id,
    name: name ?? this.name,
    birthDate: birthDate ?? this.birthDate,
    memo: memo.present ? memo.value : this.memo,
    profileImage: profileImage.present ? profileImage.value : this.profileImage,
    groupId: groupId.present ? groupId.value : this.groupId,
    isLunarCalendar: isLunarCalendar ?? this.isLunarCalendar,
    notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    notificationDaysBefore:
        notificationDaysBefore ?? this.notificationDaysBefore,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BirthdayData copyWithCompanion(BirthdaysCompanion data) {
    return BirthdayData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      memo: data.memo.present ? data.memo.value : this.memo,
      profileImage: data.profileImage.present
          ? data.profileImage.value
          : this.profileImage,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      isLunarCalendar: data.isLunarCalendar.present
          ? data.isLunarCalendar.value
          : this.isLunarCalendar,
      notificationEnabled: data.notificationEnabled.present
          ? data.notificationEnabled.value
          : this.notificationEnabled,
      notificationDaysBefore: data.notificationDaysBefore.present
          ? data.notificationDaysBefore.value
          : this.notificationDaysBefore,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BirthdayData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('memo: $memo, ')
          ..write('profileImage: $profileImage, ')
          ..write('groupId: $groupId, ')
          ..write('isLunarCalendar: $isLunarCalendar, ')
          ..write('notificationEnabled: $notificationEnabled, ')
          ..write('notificationDaysBefore: $notificationDaysBefore, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    birthDate,
    memo,
    profileImage,
    groupId,
    isLunarCalendar,
    notificationEnabled,
    notificationDaysBefore,
    phoneNumber,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BirthdayData &&
          other.id == this.id &&
          other.name == this.name &&
          other.birthDate == this.birthDate &&
          other.memo == this.memo &&
          other.profileImage == this.profileImage &&
          other.groupId == this.groupId &&
          other.isLunarCalendar == this.isLunarCalendar &&
          other.notificationEnabled == this.notificationEnabled &&
          other.notificationDaysBefore == this.notificationDaysBefore &&
          other.phoneNumber == this.phoneNumber &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BirthdaysCompanion extends UpdateCompanion<BirthdayData> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> birthDate;
  final Value<String?> memo;
  final Value<String?> profileImage;
  final Value<String?> groupId;
  final Value<bool> isLunarCalendar;
  final Value<bool> notificationEnabled;
  final Value<int> notificationDaysBefore;
  final Value<String?> phoneNumber;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BirthdaysCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.memo = const Value.absent(),
    this.profileImage = const Value.absent(),
    this.groupId = const Value.absent(),
    this.isLunarCalendar = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
    this.notificationDaysBefore = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BirthdaysCompanion.insert({
    required String id,
    required String name,
    required DateTime birthDate,
    this.memo = const Value.absent(),
    this.profileImage = const Value.absent(),
    this.groupId = const Value.absent(),
    this.isLunarCalendar = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
    this.notificationDaysBefore = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       birthDate = Value(birthDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BirthdayData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? birthDate,
    Expression<String>? memo,
    Expression<String>? profileImage,
    Expression<String>? groupId,
    Expression<bool>? isLunarCalendar,
    Expression<bool>? notificationEnabled,
    Expression<int>? notificationDaysBefore,
    Expression<String>? phoneNumber,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (birthDate != null) 'birth_date': birthDate,
      if (memo != null) 'memo': memo,
      if (profileImage != null) 'profile_image': profileImage,
      if (groupId != null) 'group_id': groupId,
      if (isLunarCalendar != null) 'is_lunar_calendar': isLunarCalendar,
      if (notificationEnabled != null)
        'notification_enabled': notificationEnabled,
      if (notificationDaysBefore != null)
        'notification_days_before': notificationDaysBefore,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BirthdaysCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? birthDate,
    Value<String?>? memo,
    Value<String?>? profileImage,
    Value<String?>? groupId,
    Value<bool>? isLunarCalendar,
    Value<bool>? notificationEnabled,
    Value<int>? notificationDaysBefore,
    Value<String?>? phoneNumber,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BirthdaysCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      memo: memo ?? this.memo,
      profileImage: profileImage ?? this.profileImage,
      groupId: groupId ?? this.groupId,
      isLunarCalendar: isLunarCalendar ?? this.isLunarCalendar,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      notificationDaysBefore:
          notificationDaysBefore ?? this.notificationDaysBefore,
      phoneNumber: phoneNumber ?? this.phoneNumber,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (profileImage.present) {
      map['profile_image'] = Variable<String>(profileImage.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (isLunarCalendar.present) {
      map['is_lunar_calendar'] = Variable<bool>(isLunarCalendar.value);
    }
    if (notificationEnabled.present) {
      map['notification_enabled'] = Variable<bool>(notificationEnabled.value);
    }
    if (notificationDaysBefore.present) {
      map['notification_days_before'] = Variable<int>(
        notificationDaysBefore.value,
      );
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
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
    return (StringBuffer('BirthdaysCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('memo: $memo, ')
          ..write('profileImage: $profileImage, ')
          ..write('groupId: $groupId, ')
          ..write('isLunarCalendar: $isLunarCalendar, ')
          ..write('notificationEnabled: $notificationEnabled, ')
          ..write('notificationDaysBefore: $notificationDaysBefore, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GiftsTable extends Gifts with TableInfo<$GiftsTable, GiftData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthdayIdMeta = const VerificationMeta(
    'birthdayId',
  );
  @override
  late final GeneratedColumn<String> birthdayId = GeneratedColumn<String>(
    'birthday_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES birthdays (id)',
    ),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _givenMeta = const VerificationMeta('given');
  @override
  late final GeneratedColumn<bool> given = GeneratedColumn<bool>(
    'given',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("given" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _receivedMeta = const VerificationMeta(
    'received',
  );
  @override
  late final GeneratedColumn<bool> received = GeneratedColumn<bool>(
    'received',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("received" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _givenGiftNameMeta = const VerificationMeta(
    'givenGiftName',
  );
  @override
  late final GeneratedColumn<String> givenGiftName = GeneratedColumn<String>(
    'given_gift_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _givenGiftPriceMeta = const VerificationMeta(
    'givenGiftPrice',
  );
  @override
  late final GeneratedColumn<int> givenGiftPrice = GeneratedColumn<int>(
    'given_gift_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receivedGiftNameMeta = const VerificationMeta(
    'receivedGiftName',
  );
  @override
  late final GeneratedColumn<String> receivedGiftName = GeneratedColumn<String>(
    'received_gift_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receivedGiftPriceMeta = const VerificationMeta(
    'receivedGiftPrice',
  );
  @override
  late final GeneratedColumn<int> receivedGiftPrice = GeneratedColumn<int>(
    'received_gift_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    birthdayId,
    year,
    given,
    received,
    givenGiftName,
    givenGiftPrice,
    receivedGiftName,
    receivedGiftPrice,
    memo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gifts';
  @override
  VerificationContext validateIntegrity(
    Insertable<GiftData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('birthday_id')) {
      context.handle(
        _birthdayIdMeta,
        birthdayId.isAcceptableOrUnknown(data['birthday_id']!, _birthdayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_birthdayIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('given')) {
      context.handle(
        _givenMeta,
        given.isAcceptableOrUnknown(data['given']!, _givenMeta),
      );
    }
    if (data.containsKey('received')) {
      context.handle(
        _receivedMeta,
        received.isAcceptableOrUnknown(data['received']!, _receivedMeta),
      );
    }
    if (data.containsKey('given_gift_name')) {
      context.handle(
        _givenGiftNameMeta,
        givenGiftName.isAcceptableOrUnknown(
          data['given_gift_name']!,
          _givenGiftNameMeta,
        ),
      );
    }
    if (data.containsKey('given_gift_price')) {
      context.handle(
        _givenGiftPriceMeta,
        givenGiftPrice.isAcceptableOrUnknown(
          data['given_gift_price']!,
          _givenGiftPriceMeta,
        ),
      );
    }
    if (data.containsKey('received_gift_name')) {
      context.handle(
        _receivedGiftNameMeta,
        receivedGiftName.isAcceptableOrUnknown(
          data['received_gift_name']!,
          _receivedGiftNameMeta,
        ),
      );
    }
    if (data.containsKey('received_gift_price')) {
      context.handle(
        _receivedGiftPriceMeta,
        receivedGiftPrice.isAcceptableOrUnknown(
          data['received_gift_price']!,
          _receivedGiftPriceMeta,
        ),
      );
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
  GiftData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GiftData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      birthdayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birthday_id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      given: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}given'],
      )!,
      received: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}received'],
      )!,
      givenGiftName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}given_gift_name'],
      ),
      givenGiftPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}given_gift_price'],
      ),
      receivedGiftName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}received_gift_name'],
      ),
      receivedGiftPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}received_gift_price'],
      ),
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
  $GiftsTable createAlias(String alias) {
    return $GiftsTable(attachedDatabase, alias);
  }
}

class GiftData extends DataClass implements Insertable<GiftData> {
  final String id;
  final String birthdayId;
  final int year;
  final bool given;
  final bool received;
  final String? givenGiftName;
  final int? givenGiftPrice;
  final String? receivedGiftName;
  final int? receivedGiftPrice;
  final String? memo;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GiftData({
    required this.id,
    required this.birthdayId,
    required this.year,
    required this.given,
    required this.received,
    this.givenGiftName,
    this.givenGiftPrice,
    this.receivedGiftName,
    this.receivedGiftPrice,
    this.memo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['birthday_id'] = Variable<String>(birthdayId);
    map['year'] = Variable<int>(year);
    map['given'] = Variable<bool>(given);
    map['received'] = Variable<bool>(received);
    if (!nullToAbsent || givenGiftName != null) {
      map['given_gift_name'] = Variable<String>(givenGiftName);
    }
    if (!nullToAbsent || givenGiftPrice != null) {
      map['given_gift_price'] = Variable<int>(givenGiftPrice);
    }
    if (!nullToAbsent || receivedGiftName != null) {
      map['received_gift_name'] = Variable<String>(receivedGiftName);
    }
    if (!nullToAbsent || receivedGiftPrice != null) {
      map['received_gift_price'] = Variable<int>(receivedGiftPrice);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GiftsCompanion toCompanion(bool nullToAbsent) {
    return GiftsCompanion(
      id: Value(id),
      birthdayId: Value(birthdayId),
      year: Value(year),
      given: Value(given),
      received: Value(received),
      givenGiftName: givenGiftName == null && nullToAbsent
          ? const Value.absent()
          : Value(givenGiftName),
      givenGiftPrice: givenGiftPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(givenGiftPrice),
      receivedGiftName: receivedGiftName == null && nullToAbsent
          ? const Value.absent()
          : Value(receivedGiftName),
      receivedGiftPrice: receivedGiftPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(receivedGiftPrice),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GiftData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GiftData(
      id: serializer.fromJson<String>(json['id']),
      birthdayId: serializer.fromJson<String>(json['birthdayId']),
      year: serializer.fromJson<int>(json['year']),
      given: serializer.fromJson<bool>(json['given']),
      received: serializer.fromJson<bool>(json['received']),
      givenGiftName: serializer.fromJson<String?>(json['givenGiftName']),
      givenGiftPrice: serializer.fromJson<int?>(json['givenGiftPrice']),
      receivedGiftName: serializer.fromJson<String?>(json['receivedGiftName']),
      receivedGiftPrice: serializer.fromJson<int?>(json['receivedGiftPrice']),
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
      'birthdayId': serializer.toJson<String>(birthdayId),
      'year': serializer.toJson<int>(year),
      'given': serializer.toJson<bool>(given),
      'received': serializer.toJson<bool>(received),
      'givenGiftName': serializer.toJson<String?>(givenGiftName),
      'givenGiftPrice': serializer.toJson<int?>(givenGiftPrice),
      'receivedGiftName': serializer.toJson<String?>(receivedGiftName),
      'receivedGiftPrice': serializer.toJson<int?>(receivedGiftPrice),
      'memo': serializer.toJson<String?>(memo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GiftData copyWith({
    String? id,
    String? birthdayId,
    int? year,
    bool? given,
    bool? received,
    Value<String?> givenGiftName = const Value.absent(),
    Value<int?> givenGiftPrice = const Value.absent(),
    Value<String?> receivedGiftName = const Value.absent(),
    Value<int?> receivedGiftPrice = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GiftData(
    id: id ?? this.id,
    birthdayId: birthdayId ?? this.birthdayId,
    year: year ?? this.year,
    given: given ?? this.given,
    received: received ?? this.received,
    givenGiftName: givenGiftName.present
        ? givenGiftName.value
        : this.givenGiftName,
    givenGiftPrice: givenGiftPrice.present
        ? givenGiftPrice.value
        : this.givenGiftPrice,
    receivedGiftName: receivedGiftName.present
        ? receivedGiftName.value
        : this.receivedGiftName,
    receivedGiftPrice: receivedGiftPrice.present
        ? receivedGiftPrice.value
        : this.receivedGiftPrice,
    memo: memo.present ? memo.value : this.memo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GiftData copyWithCompanion(GiftsCompanion data) {
    return GiftData(
      id: data.id.present ? data.id.value : this.id,
      birthdayId: data.birthdayId.present
          ? data.birthdayId.value
          : this.birthdayId,
      year: data.year.present ? data.year.value : this.year,
      given: data.given.present ? data.given.value : this.given,
      received: data.received.present ? data.received.value : this.received,
      givenGiftName: data.givenGiftName.present
          ? data.givenGiftName.value
          : this.givenGiftName,
      givenGiftPrice: data.givenGiftPrice.present
          ? data.givenGiftPrice.value
          : this.givenGiftPrice,
      receivedGiftName: data.receivedGiftName.present
          ? data.receivedGiftName.value
          : this.receivedGiftName,
      receivedGiftPrice: data.receivedGiftPrice.present
          ? data.receivedGiftPrice.value
          : this.receivedGiftPrice,
      memo: data.memo.present ? data.memo.value : this.memo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GiftData(')
          ..write('id: $id, ')
          ..write('birthdayId: $birthdayId, ')
          ..write('year: $year, ')
          ..write('given: $given, ')
          ..write('received: $received, ')
          ..write('givenGiftName: $givenGiftName, ')
          ..write('givenGiftPrice: $givenGiftPrice, ')
          ..write('receivedGiftName: $receivedGiftName, ')
          ..write('receivedGiftPrice: $receivedGiftPrice, ')
          ..write('memo: $memo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    birthdayId,
    year,
    given,
    received,
    givenGiftName,
    givenGiftPrice,
    receivedGiftName,
    receivedGiftPrice,
    memo,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GiftData &&
          other.id == this.id &&
          other.birthdayId == this.birthdayId &&
          other.year == this.year &&
          other.given == this.given &&
          other.received == this.received &&
          other.givenGiftName == this.givenGiftName &&
          other.givenGiftPrice == this.givenGiftPrice &&
          other.receivedGiftName == this.receivedGiftName &&
          other.receivedGiftPrice == this.receivedGiftPrice &&
          other.memo == this.memo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GiftsCompanion extends UpdateCompanion<GiftData> {
  final Value<String> id;
  final Value<String> birthdayId;
  final Value<int> year;
  final Value<bool> given;
  final Value<bool> received;
  final Value<String?> givenGiftName;
  final Value<int?> givenGiftPrice;
  final Value<String?> receivedGiftName;
  final Value<int?> receivedGiftPrice;
  final Value<String?> memo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GiftsCompanion({
    this.id = const Value.absent(),
    this.birthdayId = const Value.absent(),
    this.year = const Value.absent(),
    this.given = const Value.absent(),
    this.received = const Value.absent(),
    this.givenGiftName = const Value.absent(),
    this.givenGiftPrice = const Value.absent(),
    this.receivedGiftName = const Value.absent(),
    this.receivedGiftPrice = const Value.absent(),
    this.memo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GiftsCompanion.insert({
    required String id,
    required String birthdayId,
    required int year,
    this.given = const Value.absent(),
    this.received = const Value.absent(),
    this.givenGiftName = const Value.absent(),
    this.givenGiftPrice = const Value.absent(),
    this.receivedGiftName = const Value.absent(),
    this.receivedGiftPrice = const Value.absent(),
    this.memo = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       birthdayId = Value(birthdayId),
       year = Value(year),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GiftData> custom({
    Expression<String>? id,
    Expression<String>? birthdayId,
    Expression<int>? year,
    Expression<bool>? given,
    Expression<bool>? received,
    Expression<String>? givenGiftName,
    Expression<int>? givenGiftPrice,
    Expression<String>? receivedGiftName,
    Expression<int>? receivedGiftPrice,
    Expression<String>? memo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (birthdayId != null) 'birthday_id': birthdayId,
      if (year != null) 'year': year,
      if (given != null) 'given': given,
      if (received != null) 'received': received,
      if (givenGiftName != null) 'given_gift_name': givenGiftName,
      if (givenGiftPrice != null) 'given_gift_price': givenGiftPrice,
      if (receivedGiftName != null) 'received_gift_name': receivedGiftName,
      if (receivedGiftPrice != null) 'received_gift_price': receivedGiftPrice,
      if (memo != null) 'memo': memo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GiftsCompanion copyWith({
    Value<String>? id,
    Value<String>? birthdayId,
    Value<int>? year,
    Value<bool>? given,
    Value<bool>? received,
    Value<String?>? givenGiftName,
    Value<int?>? givenGiftPrice,
    Value<String?>? receivedGiftName,
    Value<int?>? receivedGiftPrice,
    Value<String?>? memo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GiftsCompanion(
      id: id ?? this.id,
      birthdayId: birthdayId ?? this.birthdayId,
      year: year ?? this.year,
      given: given ?? this.given,
      received: received ?? this.received,
      givenGiftName: givenGiftName ?? this.givenGiftName,
      givenGiftPrice: givenGiftPrice ?? this.givenGiftPrice,
      receivedGiftName: receivedGiftName ?? this.receivedGiftName,
      receivedGiftPrice: receivedGiftPrice ?? this.receivedGiftPrice,
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
    if (birthdayId.present) {
      map['birthday_id'] = Variable<String>(birthdayId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (given.present) {
      map['given'] = Variable<bool>(given.value);
    }
    if (received.present) {
      map['received'] = Variable<bool>(received.value);
    }
    if (givenGiftName.present) {
      map['given_gift_name'] = Variable<String>(givenGiftName.value);
    }
    if (givenGiftPrice.present) {
      map['given_gift_price'] = Variable<int>(givenGiftPrice.value);
    }
    if (receivedGiftName.present) {
      map['received_gift_name'] = Variable<String>(receivedGiftName.value);
    }
    if (receivedGiftPrice.present) {
      map['received_gift_price'] = Variable<int>(receivedGiftPrice.value);
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
    return (StringBuffer('GiftsCompanion(')
          ..write('id: $id, ')
          ..write('birthdayId: $birthdayId, ')
          ..write('year: $year, ')
          ..write('given: $given, ')
          ..write('received: $received, ')
          ..write('givenGiftName: $givenGiftName, ')
          ..write('givenGiftPrice: $givenGiftPrice, ')
          ..write('receivedGiftName: $receivedGiftName, ')
          ..write('receivedGiftPrice: $receivedGiftPrice, ')
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
  late final $GroupsTable groups = $GroupsTable(this);
  late final $BirthdaysTable birthdays = $BirthdaysTable(this);
  late final $GiftsTable gifts = $GiftsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    groups,
    birthdays,
    gifts,
  ];
}

typedef $$GroupsTableCreateCompanionBuilder =
    GroupsCompanion Function({
      required String id,
      required String name,
      required int colorValue,
      required int sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GroupsTableUpdateCompanionBuilder =
    GroupsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> colorValue,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$GroupsTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTable, GroupData> {
  $$GroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BirthdaysTable, List<BirthdayData>>
  _birthdaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.birthdays,
    aliasName: $_aliasNameGenerator(db.groups.id, db.birthdays.groupId),
  );

  $$BirthdaysTableProcessedTableManager get birthdaysRefs {
    final manager = $$BirthdaysTableTableManager(
      $_db,
      $_db.birthdays,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_birthdaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

  Expression<bool> birthdaysRefs(
    Expression<bool> Function($$BirthdaysTableFilterComposer f) f,
  ) {
    final $$BirthdaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.birthdays,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BirthdaysTableFilterComposer(
            $db: $db,
            $table: $db.birthdays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> birthdaysRefs<T extends Object>(
    Expression<T> Function($$BirthdaysTableAnnotationComposer a) f,
  ) {
    final $$BirthdaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.birthdays,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BirthdaysTableAnnotationComposer(
            $db: $db,
            $table: $db.birthdays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupsTable,
          GroupData,
          $$GroupsTableFilterComposer,
          $$GroupsTableOrderingComposer,
          $$GroupsTableAnnotationComposer,
          $$GroupsTableCreateCompanionBuilder,
          $$GroupsTableUpdateCompanionBuilder,
          (GroupData, $$GroupsTableReferences),
          GroupData,
          PrefetchHooks Function({bool birthdaysRefs})
        > {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion(
                id: id,
                name: name,
                colorValue: colorValue,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int colorValue,
                required int sortOrder,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion.insert(
                id: id,
                name: name,
                colorValue: colorValue,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GroupsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({birthdaysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (birthdaysRefs) db.birthdays],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (birthdaysRefs)
                    await $_getPrefetchedData<
                      GroupData,
                      $GroupsTable,
                      BirthdayData
                    >(
                      currentTable: table,
                      referencedTable: $$GroupsTableReferences
                          ._birthdaysRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GroupsTableReferences(db, table, p0).birthdaysRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.groupId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupsTable,
      GroupData,
      $$GroupsTableFilterComposer,
      $$GroupsTableOrderingComposer,
      $$GroupsTableAnnotationComposer,
      $$GroupsTableCreateCompanionBuilder,
      $$GroupsTableUpdateCompanionBuilder,
      (GroupData, $$GroupsTableReferences),
      GroupData,
      PrefetchHooks Function({bool birthdaysRefs})
    >;
typedef $$BirthdaysTableCreateCompanionBuilder =
    BirthdaysCompanion Function({
      required String id,
      required String name,
      required DateTime birthDate,
      Value<String?> memo,
      Value<String?> profileImage,
      Value<String?> groupId,
      Value<bool> isLunarCalendar,
      Value<bool> notificationEnabled,
      Value<int> notificationDaysBefore,
      Value<String?> phoneNumber,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BirthdaysTableUpdateCompanionBuilder =
    BirthdaysCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> birthDate,
      Value<String?> memo,
      Value<String?> profileImage,
      Value<String?> groupId,
      Value<bool> isLunarCalendar,
      Value<bool> notificationEnabled,
      Value<int> notificationDaysBefore,
      Value<String?> phoneNumber,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$BirthdaysTableReferences
    extends BaseReferences<_$AppDatabase, $BirthdaysTable, BirthdayData> {
  $$BirthdaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) => db.groups.createAlias(
    $_aliasNameGenerator(db.birthdays.groupId, db.groups.id),
  );

  $$GroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<String>('group_id');
    if ($_column == null) return null;
    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GiftsTable, List<GiftData>> _giftsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.gifts,
    aliasName: $_aliasNameGenerator(db.birthdays.id, db.gifts.birthdayId),
  );

  $$GiftsTableProcessedTableManager get giftsRefs {
    final manager = $$GiftsTableTableManager(
      $_db,
      $_db.gifts,
    ).filter((f) => f.birthdayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_giftsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BirthdaysTableFilterComposer
    extends Composer<_$AppDatabase, $BirthdaysTable> {
  $$BirthdaysTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileImage => $composableBuilder(
    column: $table.profileImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLunarCalendar => $composableBuilder(
    column: $table.isLunarCalendar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationEnabled => $composableBuilder(
    column: $table.notificationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationDaysBefore => $composableBuilder(
    column: $table.notificationDaysBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
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

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> giftsRefs(
    Expression<bool> Function($$GiftsTableFilterComposer f) f,
  ) {
    final $$GiftsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gifts,
      getReferencedColumn: (t) => t.birthdayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GiftsTableFilterComposer(
            $db: $db,
            $table: $db.gifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BirthdaysTableOrderingComposer
    extends Composer<_$AppDatabase, $BirthdaysTable> {
  $$BirthdaysTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileImage => $composableBuilder(
    column: $table.profileImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLunarCalendar => $composableBuilder(
    column: $table.isLunarCalendar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationEnabled => $composableBuilder(
    column: $table.notificationEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationDaysBefore => $composableBuilder(
    column: $table.notificationDaysBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
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

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BirthdaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $BirthdaysTable> {
  $$BirthdaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get profileImage => $composableBuilder(
    column: $table.profileImage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLunarCalendar => $composableBuilder(
    column: $table.isLunarCalendar,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationEnabled => $composableBuilder(
    column: $table.notificationEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationDaysBefore => $composableBuilder(
    column: $table.notificationDaysBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> giftsRefs<T extends Object>(
    Expression<T> Function($$GiftsTableAnnotationComposer a) f,
  ) {
    final $$GiftsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gifts,
      getReferencedColumn: (t) => t.birthdayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GiftsTableAnnotationComposer(
            $db: $db,
            $table: $db.gifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BirthdaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BirthdaysTable,
          BirthdayData,
          $$BirthdaysTableFilterComposer,
          $$BirthdaysTableOrderingComposer,
          $$BirthdaysTableAnnotationComposer,
          $$BirthdaysTableCreateCompanionBuilder,
          $$BirthdaysTableUpdateCompanionBuilder,
          (BirthdayData, $$BirthdaysTableReferences),
          BirthdayData,
          PrefetchHooks Function({bool groupId, bool giftsRefs})
        > {
  $$BirthdaysTableTableManager(_$AppDatabase db, $BirthdaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BirthdaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BirthdaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BirthdaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> profileImage = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<bool> isLunarCalendar = const Value.absent(),
                Value<bool> notificationEnabled = const Value.absent(),
                Value<int> notificationDaysBefore = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BirthdaysCompanion(
                id: id,
                name: name,
                birthDate: birthDate,
                memo: memo,
                profileImage: profileImage,
                groupId: groupId,
                isLunarCalendar: isLunarCalendar,
                notificationEnabled: notificationEnabled,
                notificationDaysBefore: notificationDaysBefore,
                phoneNumber: phoneNumber,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime birthDate,
                Value<String?> memo = const Value.absent(),
                Value<String?> profileImage = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<bool> isLunarCalendar = const Value.absent(),
                Value<bool> notificationEnabled = const Value.absent(),
                Value<int> notificationDaysBefore = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BirthdaysCompanion.insert(
                id: id,
                name: name,
                birthDate: birthDate,
                memo: memo,
                profileImage: profileImage,
                groupId: groupId,
                isLunarCalendar: isLunarCalendar,
                notificationEnabled: notificationEnabled,
                notificationDaysBefore: notificationDaysBefore,
                phoneNumber: phoneNumber,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BirthdaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, giftsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (giftsRefs) db.gifts],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$BirthdaysTableReferences
                                    ._groupIdTable(db),
                                referencedColumn: $$BirthdaysTableReferences
                                    ._groupIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (giftsRefs)
                    await $_getPrefetchedData<
                      BirthdayData,
                      $BirthdaysTable,
                      GiftData
                    >(
                      currentTable: table,
                      referencedTable: $$BirthdaysTableReferences
                          ._giftsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BirthdaysTableReferences(db, table, p0).giftsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.birthdayId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BirthdaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BirthdaysTable,
      BirthdayData,
      $$BirthdaysTableFilterComposer,
      $$BirthdaysTableOrderingComposer,
      $$BirthdaysTableAnnotationComposer,
      $$BirthdaysTableCreateCompanionBuilder,
      $$BirthdaysTableUpdateCompanionBuilder,
      (BirthdayData, $$BirthdaysTableReferences),
      BirthdayData,
      PrefetchHooks Function({bool groupId, bool giftsRefs})
    >;
typedef $$GiftsTableCreateCompanionBuilder =
    GiftsCompanion Function({
      required String id,
      required String birthdayId,
      required int year,
      Value<bool> given,
      Value<bool> received,
      Value<String?> givenGiftName,
      Value<int?> givenGiftPrice,
      Value<String?> receivedGiftName,
      Value<int?> receivedGiftPrice,
      Value<String?> memo,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GiftsTableUpdateCompanionBuilder =
    GiftsCompanion Function({
      Value<String> id,
      Value<String> birthdayId,
      Value<int> year,
      Value<bool> given,
      Value<bool> received,
      Value<String?> givenGiftName,
      Value<int?> givenGiftPrice,
      Value<String?> receivedGiftName,
      Value<int?> receivedGiftPrice,
      Value<String?> memo,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$GiftsTableReferences
    extends BaseReferences<_$AppDatabase, $GiftsTable, GiftData> {
  $$GiftsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BirthdaysTable _birthdayIdTable(_$AppDatabase db) => db.birthdays
      .createAlias($_aliasNameGenerator(db.gifts.birthdayId, db.birthdays.id));

  $$BirthdaysTableProcessedTableManager get birthdayId {
    final $_column = $_itemColumn<String>('birthday_id')!;

    final manager = $$BirthdaysTableTableManager(
      $_db,
      $_db.birthdays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_birthdayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GiftsTableFilterComposer extends Composer<_$AppDatabase, $GiftsTable> {
  $$GiftsTableFilterComposer({
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

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get given => $composableBuilder(
    column: $table.given,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get received => $composableBuilder(
    column: $table.received,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get givenGiftName => $composableBuilder(
    column: $table.givenGiftName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get givenGiftPrice => $composableBuilder(
    column: $table.givenGiftPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receivedGiftName => $composableBuilder(
    column: $table.receivedGiftName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receivedGiftPrice => $composableBuilder(
    column: $table.receivedGiftPrice,
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

  $$BirthdaysTableFilterComposer get birthdayId {
    final $$BirthdaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.birthdayId,
      referencedTable: $db.birthdays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BirthdaysTableFilterComposer(
            $db: $db,
            $table: $db.birthdays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $GiftsTable> {
  $$GiftsTableOrderingComposer({
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

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get given => $composableBuilder(
    column: $table.given,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get received => $composableBuilder(
    column: $table.received,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get givenGiftName => $composableBuilder(
    column: $table.givenGiftName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get givenGiftPrice => $composableBuilder(
    column: $table.givenGiftPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receivedGiftName => $composableBuilder(
    column: $table.receivedGiftName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receivedGiftPrice => $composableBuilder(
    column: $table.receivedGiftPrice,
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

  $$BirthdaysTableOrderingComposer get birthdayId {
    final $$BirthdaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.birthdayId,
      referencedTable: $db.birthdays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BirthdaysTableOrderingComposer(
            $db: $db,
            $table: $db.birthdays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GiftsTable> {
  $$GiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<bool> get given =>
      $composableBuilder(column: $table.given, builder: (column) => column);

  GeneratedColumn<bool> get received =>
      $composableBuilder(column: $table.received, builder: (column) => column);

  GeneratedColumn<String> get givenGiftName => $composableBuilder(
    column: $table.givenGiftName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get givenGiftPrice => $composableBuilder(
    column: $table.givenGiftPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receivedGiftName => $composableBuilder(
    column: $table.receivedGiftName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receivedGiftPrice => $composableBuilder(
    column: $table.receivedGiftPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BirthdaysTableAnnotationComposer get birthdayId {
    final $$BirthdaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.birthdayId,
      referencedTable: $db.birthdays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BirthdaysTableAnnotationComposer(
            $db: $db,
            $table: $db.birthdays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GiftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GiftsTable,
          GiftData,
          $$GiftsTableFilterComposer,
          $$GiftsTableOrderingComposer,
          $$GiftsTableAnnotationComposer,
          $$GiftsTableCreateCompanionBuilder,
          $$GiftsTableUpdateCompanionBuilder,
          (GiftData, $$GiftsTableReferences),
          GiftData,
          PrefetchHooks Function({bool birthdayId})
        > {
  $$GiftsTableTableManager(_$AppDatabase db, $GiftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> birthdayId = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<bool> given = const Value.absent(),
                Value<bool> received = const Value.absent(),
                Value<String?> givenGiftName = const Value.absent(),
                Value<int?> givenGiftPrice = const Value.absent(),
                Value<String?> receivedGiftName = const Value.absent(),
                Value<int?> receivedGiftPrice = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GiftsCompanion(
                id: id,
                birthdayId: birthdayId,
                year: year,
                given: given,
                received: received,
                givenGiftName: givenGiftName,
                givenGiftPrice: givenGiftPrice,
                receivedGiftName: receivedGiftName,
                receivedGiftPrice: receivedGiftPrice,
                memo: memo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String birthdayId,
                required int year,
                Value<bool> given = const Value.absent(),
                Value<bool> received = const Value.absent(),
                Value<String?> givenGiftName = const Value.absent(),
                Value<int?> givenGiftPrice = const Value.absent(),
                Value<String?> receivedGiftName = const Value.absent(),
                Value<int?> receivedGiftPrice = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GiftsCompanion.insert(
                id: id,
                birthdayId: birthdayId,
                year: year,
                given: given,
                received: received,
                givenGiftName: givenGiftName,
                givenGiftPrice: givenGiftPrice,
                receivedGiftName: receivedGiftName,
                receivedGiftPrice: receivedGiftPrice,
                memo: memo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GiftsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({birthdayId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (birthdayId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.birthdayId,
                                referencedTable: $$GiftsTableReferences
                                    ._birthdayIdTable(db),
                                referencedColumn: $$GiftsTableReferences
                                    ._birthdayIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GiftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GiftsTable,
      GiftData,
      $$GiftsTableFilterComposer,
      $$GiftsTableOrderingComposer,
      $$GiftsTableAnnotationComposer,
      $$GiftsTableCreateCompanionBuilder,
      $$GiftsTableUpdateCompanionBuilder,
      (GiftData, $$GiftsTableReferences),
      GiftData,
      PrefetchHooks Function({bool birthdayId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$BirthdaysTableTableManager get birthdays =>
      $$BirthdaysTableTableManager(_db, _db.birthdays);
  $$GiftsTableTableManager get gifts =>
      $$GiftsTableTableManager(_db, _db.gifts);
}
