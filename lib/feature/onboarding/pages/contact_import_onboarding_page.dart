import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/contact/controllers/contact_import_controller.dart';
import 'package:rememberotter/feature/contact/widgets/contact_list_item.dart';
import 'package:rememberotter/shared/services/contact_service.dart';
import 'package:rememberotter/shared/widgets/date_picker_spinner.dart';
import 'package:rememberotter/shared/widgets/otter_image.dart';

class ContactImportOnboardingPage extends StatefulWidget {
  const ContactImportOnboardingPage({super.key});

  @override
  State<ContactImportOnboardingPage> createState() =>
      _ContactImportOnboardingPageState();
}

class _ContactImportOnboardingPageState
    extends State<ContactImportOnboardingPage> with WidgetsBindingObserver {
  final ContactService _contactService = ContactService();

  /// true = 연락처 선택 UI (상태 B), false = 인트로 UI (상태 A)
  final RxBool _showContactList = false.obs;
  ContactImportController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_controller != null) {
      Get.delete<ContactImportController>();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _controller != null) {
      _controller!.recheckPermission();
    }
  }

  Future<void> _onRequestPermission() async {
    final granted = await _contactService.requestPermission();
    if (granted) {
      _controller = Get.put(ContactImportController());
      _showContactList.value = true;
    } else {
      // 권한 거부 시 메인으로 이동
      _goToMain();
    }
  }

  Future<void> _handleImport() async {
    if (_controller == null) return;
    final count = await _controller!.importSelected();
    _goToMain();
    if (count > 0) {
      Get.snackbar(
        '가져오기 완료',
        '$count명의 생일을 추가했어요',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    }
  }

  void _goToMain() {
    Get.offAllNamed(AppRoutes.main);
  }

  void _showBirthdayPicker(String contactId, String name) {
    if (_controller == null) return;
    DateTime tempDate =
        _controller!.manualBirthdays[contactId] ?? DateTime(2000, 1, 1);

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
                        _controller!.setBirthday(contactId, tempDate);
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
      body: Obx(() {
        if (_showContactList.value) {
          return _buildContactSelection();
        }
        return _buildIntro();
      }),
    );
  }

  // ──────────────────────────────────────────────
  // 상태 A: 인트로 화면
  // ──────────────────────────────────────────────
  Widget _buildIntro() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(flex: 2),
            const OtterImage(type: OtterType.wave, size: 160),
            const SizedBox(height: 32),
            const Text(
              '연락처에서 생일을 가져올까요?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              '연락처에 저장된 생일 정보를\n한번에 가져올 수 있어요',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildFeatureRow(
                    icon: Icons.contact_phone_outlined,
                    text: '연락처 생일 자동 인식',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureRow(
                    icon: Icons.checklist_outlined,
                    text: '원하는 친구만 선택',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureRow(
                    icon: Icons.lock_outline,
                    text: '기기에서만 사용돼요',
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _onRequestPermission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '연락처 가져오기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _goToMain,
              child: const Text(
                '나중에 할게요',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.op(AppColors.primary, 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // 상태 B: 연락처 선택 화면
  // ──────────────────────────────────────────────
  Widget _buildContactSelection() {
    return SafeArea(
      child: Column(
        children: [
          // 상단 헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '가져올 친구를 선택하세요',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _goToMain,
                  child: const Text(
                    '건너뛰기',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 콘텐츠
          Expanded(
            child: Obx(() {
              if (_controller!.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_controller!.contacts.isEmpty) {
                return _buildEmptyState();
              }

              return _buildContactList();
            }),
          ),

          // 하단 버튼
          Obx(() {
            final selectedCount = _controller!.selectedContactIds.length;
            if (_controller!.isLoading.value ||
                _controller!.contacts.isEmpty) {
              return const SizedBox.shrink();
            }

            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: SizedBox(
                  height: 52,
                  width: double.infinity,
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
        ],
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
            '생일이 등록된 연락처가 없어요',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '연락처에 생일을 추가하면\n여기서 가져올 수 있어요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: _goToMain,
            child: const Text(
              '메인으로 이동',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primary,
              ),
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
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            onChanged: (value) => _controller!.searchQuery.value = value,
            decoration: InputDecoration(
              hintText: '이름 검색',
              hintStyle: const TextStyle(color: AppColors.textTertiary),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.textTertiary),
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
          final selectedCount = _controller!.selectedContactIds.length;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _controller!.isAllSelected,
                    onChanged: (_) => _controller!.toggleSelectAll(),
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
                      : '생일 등록된 연락처 전체 선택 (${_controller!.selectableCount}명)',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }),

        const Divider(height: 1),

        // 연락처 목록
        Expanded(
          child: Obx(() {
            final filtered = _controller!.filteredContacts;
            return ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final contact = filtered[index];
                final isImported = _controller!.isAlreadyImported(contact);

                return Obx(() {
                  final birthday = _controller!.getBirthday(contact);
                  return ContactListItem(
                    contact: contact,
                    birthday: birthday,
                    isSelected: _controller!.selectedContactIds
                        .contains(contact.id),
                    isAlreadyImported: isImported,
                    onChanged: (_) =>
                        _controller!.toggleContact(contact.id),
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
