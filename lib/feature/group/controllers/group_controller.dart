import 'package:get/get.dart';
import 'package:rememberotter/domain/models/group.dart';
import 'package:rememberotter/domain/repositories/group_repository.dart';

class GroupController extends GetxController {
  final GroupRepository _repository = GroupRepository();

  final RxList<Group> groups = <Group>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadGroups();
  }

  /// 모든 그룹 로드
  Future<void> loadGroups() async {
    final all = await _repository.getAll();
    groups.value = all;
  }

  /// ID로 그룹 조회 (캐시 기반)
  Group? getGroupById(String? id) {
    if (id == null) return null;
    return groups.firstWhereOrNull((g) => g.id == id);
  }

  /// 그룹 추가
  Future<void> addGroup({
    required String name,
    required int colorValue,
  }) async {
    final sortOrder = groups.isEmpty ? 0 : groups.last.sortOrder + 1;
    await _repository.add(
      name: name,
      colorValue: colorValue,
      sortOrder: sortOrder,
    );
    await loadGroups();
  }

  /// 그룹 수정
  Future<void> updateGroup(Group group) async {
    await _repository.update(group);
    await loadGroups();
  }

  /// 그룹 삭제
  Future<void> deleteGroup(String id) async {
    await _repository.delete(id);
    await loadGroups();
  }

  /// 그룹 순서 변경
  Future<void> reorderGroups(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = groups.removeAt(oldIndex);
    groups.insert(newIndex, item);
    await _repository.updateSortOrders(groups);
    await loadGroups();
  }
}
