import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/data/models/birthday.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/birthday/controllers/birthday_controller.dart';

class BirthdayFormSheet extends StatefulWidget {
  final Birthday? birthday;

  const BirthdayFormSheet({super.key, this.birthday});

  static Future<void> show({Birthday? birthday}) {
    return Get.bottomSheet(
      BirthdayFormSheet(birthday: birthday),
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
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.birthday != null;
    if (_isEditing) {
      _nameController.text = widget.birthday!.name;
      _memoController.text = widget.birthday!.memo ?? '';
      _selectedDate = widget.birthday!.birthDate;
    } else {
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<BirthdayController>();

    if (_isEditing) {
      final updated = widget.birthday!.copyWith(
        name: _nameController.text.trim(),
        birthDate: _selectedDate,
        memo: _memoController.text.trim().isEmpty ? null : _memoController.text.trim(),
      );
      await controller.updateBirthday(updated);
    } else {
      await controller.addBirthday(
        name: _nameController.text.trim(),
        birthDate: _selectedDate,
        memo: _memoController.text.trim().isEmpty ? null : _memoController.text.trim(),
      );
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
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
                  maxLines: 3,
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
