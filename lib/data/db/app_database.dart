import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('MandalartEntity')
class Mandalarts extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get emoji => text().nullable()();
  TextColumn get dateRangeLabel => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GoalEntity')
class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get mandalartId => text()();
  IntColumn get gridIndex => integer()();
  TextColumn get goalText => text()();
  IntColumn get status => integer()();
  TextColumn get memo => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Mandalarts, Goals])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // v1 -> v2: Add emoji column to mandalarts table
          await m.addColumn(mandalarts, mandalarts.emoji);
        }
      },
    );
  }
}

final AppDatabase appDatabase = AppDatabase();

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'mandalart.sqlite'));
    return NativeDatabase(file);
  });
}
