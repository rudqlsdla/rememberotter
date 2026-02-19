import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ─────────────── 테이블 정의 ───────────────

@DataClassName('BirthdayData')
class Birthdays extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get birthDate => dateTime()();
  TextColumn get memo => text().nullable()();
  TextColumn get profileImage => text().nullable()();
  BoolColumn get isLunarCalendar => boolean().withDefault(const Constant(false))();
  BoolColumn get notificationEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get notificationDaysBefore => integer().withDefault(const Constant(1))();
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
  TextColumn get receivedGiftName => text().nullable()();
  TextColumn get memo => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ─────────────── 데이터베이스 ───────────────

@DriftDatabase(tables: [Birthdays, Gifts])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static AppDatabase? _instance;
  static AppDatabase get instance => _instance ??= AppDatabase._();

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'rememberotter.db'));
    return NativeDatabase.createInBackground(file);
  });
}
