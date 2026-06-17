import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ─────────────── 테이블 정의 ───────────────

@DataClassName('GroupData')
class Groups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get colorValue => integer()();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BirthdayData')
class Birthdays extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get birthDate => dateTime()();
  TextColumn get memo => text().nullable()();
  TextColumn get profileImage => text().nullable()();
  TextColumn get groupId => text().nullable().references(Groups, #id)();
  BoolColumn get isLunarCalendar => boolean().withDefault(const Constant(false))();
  BoolColumn get notificationEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get notificationDaysBefore => integer().withDefault(const Constant(1))();
  TextColumn get phoneNumber => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GiftData')
class Gifts extends Table {
  TextColumn get id => text()();
  TextColumn get birthdayId => text().references(Birthdays, #id)();
  IntColumn get year => integer()();
  BoolColumn get given => boolean().withDefault(const Constant(false))();
  BoolColumn get received => boolean().withDefault(const Constant(false))();
  TextColumn get givenGiftName => text().nullable()();
  IntColumn get givenGiftPrice => integer().nullable()();
  TextColumn get receivedGiftName => text().nullable()();
  IntColumn get receivedGiftPrice => integer().nullable()();
  TextColumn get memo => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ─────────────── 데이터베이스 ───────────────

@DriftDatabase(tables: [Birthdays, Gifts, Groups])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static AppDatabase? _instance;
  static AppDatabase get instance => _instance ??= AppDatabase._();

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _insertDefaultGroups();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(birthdays, birthdays.phoneNumber);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _insertDefaultGroups() async {
    final now = DateTime.now();
    final defaults = [
      ('family', '가족', 0xFFEF4444, 0),
      ('friends', '친구', 0xFF3B82F6, 1),
      ('work', '직장', 0xFF10B981, 2),
      ('etc', '기타', 0xFF9CA3AF, 3),
    ];
    for (final (id, name, color, order) in defaults) {
      await into(groups).insert(GroupsCompanion.insert(
        id: id,
        name: name,
        colorValue: color,
        sortOrder: order,
        createdAt: now,
        updatedAt: now,
      ));
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'rememberotter.db'));
    return NativeDatabase.createInBackground(file);
  });
}
