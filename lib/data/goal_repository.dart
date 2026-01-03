import 'package:drift/drift.dart';
import 'package:mandalart/data/db/app_database.dart';

class GoalRepository {
  GoalRepository(this._database);

  final AppDatabase _database;

  Stream<List<GoalEntity>> watchGoals(String mandalartId) {
    final query = _database.select(_database.goals)
      ..where((row) => row.mandalartId.equals(mandalartId));
    return query.watch();
  }

  Future<void> saveGoal({
    required String mandalartId,
    required int gridIndex,
    required String text,
    required int status,
    required String memo,
  }) {
    final id = _goalId(mandalartId, gridIndex);
    final now = DateTime.now();
    return _database.into(_database.goals).insertOnConflictUpdate(
          GoalsCompanion(
            id: Value(id),
            mandalartId: Value(mandalartId),
            gridIndex: Value(gridIndex),
            goalText: Value(text),
            status: Value(status),
            memo: Value(memo),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> deleteGoal(String mandalartId, int gridIndex) {
    final id = _goalId(mandalartId, gridIndex);
    return (_database.delete(_database.goals)..where((row) => row.id.equals(id)))
        .go();
  }

  String _goalId(String mandalartId, int gridIndex) {
    return '$mandalartId:$gridIndex';
  }
}
