import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/domain/models/birthday.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/birthday/controllers/birthday_controller.dart';
import 'package:rememberotter/feature/group/controllers/group_controller.dart';
import 'package:rememberotter/shared/services/analytics_service.dart';
import 'package:rememberotter/shared/widgets/date_picker_spinner.dart';

class BirthdayFormSheet extends StatefulWidget {
  final Birthday? birthday;
  final DateTime? initialDate;

  const BirthdayFormSheet({super.key, this.birthday, this.initialDate});

  static Future<void> show({Birthday? birthday, DateTime? initialDate}) {
    AnalyticsService().logBirthdayFormOpen(mode: birthday != null ? 'edit' : 'add');
    return Get.bottomSheet(
      BirthdayFormSheet(birthday: birthday, initialDate: initialDate),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  State<BirthdayFormSheet> createState() => _BirthdayFormSheetState();
}

class _BirthdayFormSheetState extends State<BirthdayFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _memoController = TextEditingController();
  late DateTime _selectedDate;
  String? _selectedGroupId;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.birthday != null;
    if (_isEditing) {
      _nameController.text = widget.birthday!.name;
      _memoController.text = widget.birthday!.memo ?? '';
      _selectedDate = widget.birthday!.birthDate;
      _selectedGroupId = widget.birthday!.groupId;
    } else {
      final date = widget.initialDate ?? DateTime.now();
      final today = DateTime.now();
      final isPast = DateTime(today.year, date.month, date.day)
          .isBefore(DateTime(today.year, today.month, today.day)) ||
          DateTime(today.year, date.month, date.day)
          .isAtSameMomentAs(DateTime(today.year, today.month, today.day));
      _selectedDate = DateTime(isPast ? date.year : date.year - 1, date.month, date.day);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _selectDate() {
    DateTime tempDate = _selectedDate;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 280,
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              // 헤더
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Text(
                      '생년월일',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = tempDate;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Wheel Picker
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: DatePickerSpinner(
                    height: 150,
                    date: _selectedDate,
                    onChanged: (date) {
                      tempDate = date;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectGroup() {
    final groupController = Get.find<GroupController>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '그룹 선택',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Divider(height: 1),
              // 미분류 옵션
              ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                ),
                title: const Text('미분류'),
                trailing: _selectedGroupId == null
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedGroupId = null);
                  Navigator.pop(context);
                },
              ),
              // 그룹 목록
              ...groupController.groups.map((group) {
                final isSelected = _selectedGroupId == group.id;
                return ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: group.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(group.name),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedGroupId = group.id);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<BirthdayController>();

    if (_isEditing) {
      final updated = widget.birthday!.copyWith(
        name: _nameController.text.trim(),
        birthDate: _selectedDate,
        memo: _memoController.text.trim().isEmpty ? null : _memoController.text.trim(),
        groupId: () => _selectedGroupId,
      );
      await controller.updateBirthday(updated);
    } else {
      await controller.addBirthday(
        name: _nameController.text.trim(),
        birthDate: _selectedDate,
        memo: _memoController.text.trim().isEmpty ? null : _memoController.text.trim(),
        groupId: _selectedGroupId,
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
                    _isEditing ? '생일 수정' : '생일 추가',
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
                  labelText: '이름',
                  hintText: '이름을 입력하세요',
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
                    return '이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 생년월일 선택
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.textSecondary),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '생년월일',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 메모 입력
              TextFormField(
                controller: _memoController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: '메모 (선택)',
                  hintText: '메모를 입력하세요',
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
              ),
              const SizedBox(height: 16),

              // 그룹 선택
              GestureDetector(
                onTap: _selectGroup,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.folder_outlined, color: AppColors.textSecondary),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '그룹',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Builder(
                            builder: (context) {
                              final groupController = Get.find<GroupController>();
                              final group = groupController.getGroupById(_selectedGroupId);
                              return Row(
                                children: [
                                  if (group != null) ...[
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: group.color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Text(
                                    group?.name ?? '미분류',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                    ],
                  ),
                ),
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
