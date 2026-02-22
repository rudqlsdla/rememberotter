import 'package:drift/drift.dart';
import 'package:rememberotter/data/database/app_database.dart';
import 'package:rememberotter/domain/models/group.dart';
import 'package:uuid/uuid.dart';

class GroupRepository {
  final _uuid = const Uuid();
  AppDatabase get _db => AppDatabase.instance;

  /// 모든 그룹 조회 (sortOrder 순)
  Future<List<Group>> getAll() async {
    final rows = await (_db.select(_db.groups)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  /// ID로 그룹 조회
  Future<Group?> getById(String id) async {
    final row = await (_db.select(_db.groups)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  /// 그룹 추가
  Future<Group> add({
    required String name,
    required int colorValue,
    required int sortOrder,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    await _db.into(_db.groups).insert(GroupsCompanion.insert(
      id: id,
      name: name,
      colorValue: colorValue,
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
    ));
    return Group(
      id: id,
      name: name,
      colorValue: colorValue,
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 그룹 수정
  Future<Group?> update(Group group) async {
    final updated = group.copyWith(updatedAt: DateTime.now());
    await (_db.update(_db.groups)..where((t) => t.id.equals(updated.id)))
        .write(GroupsCompanion(
      name: Value(updated.name),
      colorValue: Value(updated.colorValue),
      sortOrder: Value(updated.sortOrder),
      updatedAt: Value(updated.updatedAt),
    ));
    return updated;
  }

  /// 그룹 삭제 (해당 그룹의 Birthday groupId를 null로 설정 후 삭제)
  Future<void> delete(String id) async {
    // 해당 그룹의 생일 groupId를 null로 설정
    await (_db.update(_db.birthdays)..where((t) => t.groupId.equals(id)))
        .write(const BirthdaysCompanion(groupId: Value(null)));
    // 그룹 삭제
    await (_db.delete(_db.groups)..where((t) => t.id.equals(id))).go();
  }

  /// 정렬 순서 일괄 업데이트
  Future<void> updateSortOrders(List<Group> groups) async {
    await _db.transaction(() async {
      for (int i = 0; i < groups.length; i++) {
        await (_db.update(_db.groups)
              ..where((t) => t.id.equals(groups[i].id)))
            .write(GroupsCompanion(
          sortOrder: Value(i),
          updatedAt: Value(DateTime.now()),
        ));
      }
    });
  }

  /// Drift row → 도메인 모델 변환
  Group _fromRow(GroupData row) {
    return Group(
      id: row.id,
      name: row.name,
      colorValue: row.colorValue,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
