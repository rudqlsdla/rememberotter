import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/domain/models/group.dart';
import 'package:rememberotter/feature/group/controllers/group_controller.dart';

class GroupFormSheet extends StatefulWidget {
  final Group? group;

  const GroupFormSheet({super.key, this.group});

  static Future<void> show({Group? group}) {
    return Get.bottomSheet(
      GroupFormSheet(group: group),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  State<GroupFormSheet> createState() => _GroupFormSheetState();
}

class _GroupFormSheetState extends State<GroupFormSheet> {
  static const List<int> presetColors = [
    0xFFEF4444, 0xFFF97316, 0xFFF59E0B, 0xFF10B981,
    0xFF14B8A6, 0xFF3B82F6, 0xFF6366F1, 0xFF8B5CF6,
    0xFFEC4899, 0xFF9CA3AF, 0xFF78716C, 0xFF64748B,
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late int _selectedColor;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.group != null;
    if (_isEditing) {
      _nameController.text = widget.group!.name;
      _selectedColor = widget.group!.colorValue;
    } else {
      _selectedColor = presetColors[0];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<GroupController>();

    if (_isEditing) {
      final updated = widget.group!.copyWith(
        name: _nameController.text.trim(),
        colorValue: _selectedColor,
      );
      await controller.updateGroup(updated);
    } else {
      await controller.addGroup(
        name: _nameController.text.trim(),
        colorValue: _selectedColor,
      );
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? '그룹 수정' : '그룹 추가',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 이름 입력
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '그룹 이름',
                hintText: '그룹 이름을 입력하세요',
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '그룹 이름을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // 색상 선택
            const Text(
              '색상',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: presetColors.length,
              itemBuilder: (context, index) {
                final color = presetColors[index];
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(color),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: AppColors.textPrimary, width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // 저장 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _isEditing ? '수정하기' : '추가하기',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SafeArea(child: const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
