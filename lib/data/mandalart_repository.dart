import 'package:drift/drift.dart';
import 'package:mandalart/data/db/app_database.dart';
import 'package:mandalart/features/mandalart/mandalart.dart';

class MandalartRepository {
  MandalartRepository(this._database);

  final AppDatabase _database;

  Stream<List<Mandalart>> watchMandalarts() {
    final query = _database.select(_database.mandalarts)
      ..orderBy([
        // 고정된 항목 먼저, 그 다음 업데이트 순
        (row) => OrderingTerm.desc(row.isPinned),
        (row) => OrderingTerm.desc(row.updatedAt),
      ]);
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => Mandalart(
                  id: row.id,
                  title: row.title,
                  emoji: row.emoji,
                  dateRangeLabel: row.dateRangeLabel,
                  isPinned: row.isPinned,
                ),
              )
              .toList(),
        );
  }

  Future<void> saveMandalart(Mandalart mandalart) async {
    final now = DateTime.now();
    final updated = await (_database.update(_database.mandalarts)
          ..where((row) => row.id.equals(mandalart.id)))
        .write(
      MandalartsCompanion(
        title: Value(mandalart.title),
        emoji: Value(mandalart.emoji),
        dateRangeLabel: Value(mandalart.dateRangeLabel),
        isPinned: Value(mandalart.isPinned),
        updatedAt: Value(now),
      ),
    );

    if (updated == 0) {
      await _database.into(_database.mandalarts).insert(
            MandalartsCompanion(
              id: Value(mandalart.id),
              title: Value(mandalart.title),
              emoji: Value(mandalart.emoji),
              dateRangeLabel: Value(mandalart.dateRangeLabel),
              isPinned: Value(mandalart.isPinned),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    }
  }

  /// 고정 상태 토글
  Future<void> togglePin(String id) async {
    final query = _database.select(_database.mandalarts)
      ..where((row) => row.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return;

    await (_database.update(_database.mandalarts)
          ..where((row) => row.id.equals(id)))
        .write(
      MandalartsCompanion(
        isPinned: Value(!row.isPinned),
      ),
    );
  }

  Future<void> deleteMandalart(String id) {
    return (_database.delete(_database.mandalarts)
          ..where((row) => row.id.equals(id)))
        .go();
  }

  /// 특정 만다라트 조회
  Future<Mandalart?> getMandalart(String id) async {
    final query = _database.select(_database.mandalarts)
      ..where((row) => row.id.equals(id));
    final row = await query.getSingleOrNull();

    if (row == null) return null;

    return Mandalart(
      id: row.id,
      title: row.title,
      emoji: row.emoji,
      dateRangeLabel: row.dateRangeLabel,
      isPinned: row.isPinned,
    );
  }
}
