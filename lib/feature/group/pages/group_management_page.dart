import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/birthday/controllers/birthday_controller.dart';
import 'package:rememberotter/feature/group/controllers/group_controller.dart';
import 'package:rememberotter/feature/group/widgets/group_form_sheet.dart';

class GroupManagementPage extends StatelessWidget {
  const GroupManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GroupController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('그룹 관리'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => GroupFormSheet.show(),
          ),
        ],
      ),
      body: Obx(() {
        final groups = controller.groups;

        if (groups.isEmpty) {
          return const Center(
            child: Text(
              '등록된 그룹이 없어요',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return ReorderableListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: groups.length,
          onReorder: controller.reorderGroups,
          itemBuilder: (context, index) {
            final group = groups[index];
            return ListTile(
              key: ValueKey(group.id),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: const Icon(
                      Icons.drag_handle,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: group.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              title: Text(
                group.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    color: AppColors.textSecondary,
                    onPressed: () => GroupFormSheet.show(group: group),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: AppColors.error,
                    onPressed: () => _showDeleteConfirm(group.id, group.name, controller),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _showDeleteConfirm(String id, String name, GroupController controller) {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                '\'$name\' 그룹을 삭제할까요?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '해당 그룹의 생일은 미분류로 변경됩니다',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    Get.back();
                    await controller.deleteGroup(id);
                    // 생일 목록 갱신 (groupId가 null로 변경된 항목 반영)
                    await Get.find<BirthdayController>().loadBirthdays();
                    Get.snackbar(
                      '삭제 완료',
                      '\'$name\' 그룹이 삭제되었어요',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '삭제하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
