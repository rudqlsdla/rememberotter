import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/contact/controllers/contact_import_controller.dart';
import 'package:rememberotter/feature/contact/widgets/contact_list_item.dart';
import 'package:rememberotter/shared/widgets/date_picker_spinner.dart';
import 'package:rememberotter/shared/widgets/otter_image.dart';

class ContactImportPage extends StatefulWidget {
  const ContactImportPage({super.key});

  @override
  State<ContactImportPage> createState() => _ContactImportPageState();
}

class _ContactImportPageState extends State<ContactImportPage>
    with WidgetsBindingObserver {
  late final ContactImportController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ContactImportController());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Get.delete<ContactImportController>();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.recheckPermission();
    }
  }

  Future<void> _handleImport() async {
    final count = await _controller.importSelected();
    if (count > 0) {
      Get.back();
      Get.snackbar(
        '가져오기 완료',
        '$count명의 생일을 추가했어요',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    }
  }

  void _showBirthdayPicker(String contactId, String name) {
    DateTime tempDate = _controller.manualBirthdays[contactId] ?? DateTime(2000, 1, 1);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
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
                    Text(
                      '$name의 생일',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _controller.setBirthday(contactId, tempDate);
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: DatePickerSpinner(
                    height: 180,
                    date: tempDate,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('연락처에서 가져오기'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: AppColors.background,
        elevation: 0,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!_controller.hasPermission.value) {
          return _buildPermissionDenied();
        }

        if (_controller.contacts.isEmpty) {
          return _buildEmptyState();
        }

        return _buildContactList();
      }),
      bottomNavigationBar: Obx(() {
        final selectedCount = _controller.selectedContactIds.length;
        if (!_controller.hasPermission.value ||
            _controller.contacts.isEmpty ||
            _controller.isLoading.value) {
          return const SizedBox.shrink();
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: selectedCount > 0 ? _handleImport : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primaryLight,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  selectedCount > 0
                      ? '$selectedCount명 가져오기'
                      : '가져올 연락처를 선택하세요',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const OtterImage(type: OtterType.wave, size: 120),
            const SizedBox(height: 24),
            const Text(
              '연락처 접근 권한이 필요해요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '연락처에 저장된 정보를\n가져오려면 권한을 허용해주세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _controller.retryPermission(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text('권한 허용하기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const OtterImage(type: OtterType.empty, size: 120),
          const SizedBox(height: 24),
          const Text(
            '연락처가 없어요',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '연락처에 친구를 추가하면\n여기서 가져올 수 있어요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactList() {
    return Column(
      children: [
        // 검색 필드
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            onChanged: (value) => _controller.searchQuery.value = value,
            decoration: InputDecoration(
              hintText: '이름 검색',
              hintStyle: const TextStyle(color: AppColors.textTertiary),
              prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        // 전체 선택 헤더
        Obx(() {
          final selectedCount = _controller.selectedContactIds.length;
          return GestureDetector(
            onTap: () => _controller.toggleSelectAll(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _controller.isAllSelected,
                      onChanged: (_) => _controller.toggleSelectAll(),
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedCount > 0
                        ? '$selectedCount명 선택됨'
                        : '생일 등록된 연락처 전체 선택 (${_controller.selectableCount}명)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        const Divider(height: 1),

        // 연락처 목록
        Expanded(
          child: Obx(() {
            final filtered = _controller.filteredContacts;
            return ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final contact = filtered[index];
                final isImported = _controller.isAlreadyImported(contact);

                return Obx(() {
                  final birthday = _controller.getBirthday(contact);
                  return ContactListItem(
                    contact: contact,
                    birthday: birthday,
                    isSelected:
                        _controller.selectedContactIds.contains(contact.id),
                    isAlreadyImported: isImported,
                    onChanged: (_) => _controller.toggleContact(contact.id),
                    onSetBirthday: () => _showBirthdayPicker(
                      contact.id,
                      contact.displayName,
                    ),
                  );
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
