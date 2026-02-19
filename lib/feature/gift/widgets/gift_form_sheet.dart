import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/domain/models/gift.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/gift/controllers/gift_controller.dart';
import 'package:rememberotter/shared/widgets/year_picker_spinner.dart';

class GiftFormSheet extends StatefulWidget {
  final String birthdayId;
  final Gift? gift;

  const GiftFormSheet({
    super.key,
    required this.birthdayId,
    this.gift,
  });

  static Future<void> show({
    required String birthdayId,
    Gift? gift,
  }) {
    return Get.bottomSheet(
      GiftFormSheet(birthdayId: birthdayId, gift: gift),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  State<GiftFormSheet> createState() => _GiftFormSheetState();
}

class _GiftFormSheetState extends State<GiftFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _givenGiftNameController = TextEditingController();
  final _receivedGiftNameController = TextEditingController();
  final _memoController = TextEditingController();

  late int _selectedYear;
  bool _given = false;
  bool _received = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.gift != null;
    if (_isEditing) {
      _selectedYear = widget.gift!.year;
      _given = widget.gift!.given;
      _received = widget.gift!.received;
      _givenGiftNameController.text = widget.gift!.givenGiftName ?? '';
      _receivedGiftNameController.text = widget.gift!.receivedGiftName ?? '';
      _memoController.text = widget.gift!.memo ?? '';
    } else {
      _selectedYear = DateTime.now().year;
    }
  }

  @override
  void dispose() {
    _givenGiftNameController.dispose();
    _receivedGiftNameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<GiftController>();

    if (_isEditing) {
      final updated = widget.gift!.copyWith(
        year: _selectedYear,
        given: _given,
        received: _received,
        givenGiftName: _given ? _givenGiftNameController.text.trim() : null,
        receivedGiftName: _received ? _receivedGiftNameController.text.trim() : null,
        memo: _memoController.text.trim().isEmpty ? null : _memoController.text.trim(),
      );
      await controller.updateGift(updated);
    } else {
      await controller.addGift(
        birthdayId: widget.birthdayId,
        year: _selectedYear,
        given: _given,
        received: _received,
        givenGiftName: _given ? _givenGiftNameController.text.trim() : null,
        receivedGiftName: _received ? _receivedGiftNameController.text.trim() : null,
        memo: _memoController.text.trim().isEmpty ? null : _memoController.text.trim(),
      );
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
                    _isEditing ? '선물 기록 수정' : '선물 기록 추가',
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

              // 연도 선택
              _buildYearSelector(),
              const SizedBox(height: 20),

              // 선물 준 여부
              _buildGivenSection(),
              const SizedBox(height: 16),

              // 선물 받은 여부
              _buildReceivedSection(),
              const SizedBox(height: 16),

              // 메모
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
    );
  }

  void _selectYear() {
    int tempYear = _selectedYear;

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
                      '연도 선택',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedYear = tempYear;
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
              // Year Picker
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: YearPickerSpinner(
                    height: 150,
                    year: _selectedYear,
                    onChanged: (year) {
                      tempYear = year;
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

  Widget _buildYearSelector() {
    return GestureDetector(
      onTap: _selectYear,
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
                  '연도',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_selectedYear년',
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
    );
  }

  Widget _buildGivenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _given,
              onChanged: (value) {
                setState(() {
                  _given = value ?? false;
                });
              },
              activeColor: AppColors.primary,
            ),
            const Text(
              '선물을 줬어요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        if (_given)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8),
            child: TextFormField(
              controller: _givenGiftNameController,
              decoration: InputDecoration(
                labelText: '준 선물 이름(선택)',
                hintText: '예: 향수, 지갑',
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
          ),
      ],
    );
  }

  Widget _buildReceivedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _received,
              onChanged: (value) {
                setState(() {
                  _received = value ?? false;
                });
              },
              activeColor: AppColors.accent,
            ),
            const Text(
              '선물을 받았어요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        if (_received)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8),
            child: TextFormField(
              controller: _receivedGiftNameController,
              decoration: InputDecoration(
                labelText: '받은 선물 이름(선택)',
                hintText: '예: 케이크, 카드',
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.accent, width: 2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
