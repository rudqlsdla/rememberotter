import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/birthday/controllers/birthday_controller.dart';
import 'package:rememberotter/feature/birthday/widgets/birthday_form_sheet.dart';
import 'package:rememberotter/feature/birthday/widgets/birthday_list_item.dart';
import 'package:rememberotter/feature/calendar/pages/calendar_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rememberotter/shared/services/notification_service.dart';
import 'package:rememberotter/shared/services/settings_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CalendarPage(),
    const _FriendsPage(),
    const _SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('기억해달'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _pages[_currentIndex],
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButton: _currentIndex != 2
          ? FloatingActionButton.small(
              onPressed: () => BirthdayFormSheet.show(),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '친구',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}

// 친구 목록 탭 페이지
class _FriendsPage extends StatelessWidget {
  const _FriendsPage();

  @override
  Widget build(BuildContext context) {
    return GetX<BirthdayController>(
      builder: (controller) {
        final birthdays = controller.birthdays;

        if (birthdays.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cake_outlined,
                  size: 80,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: 20),
                Text(
                  '등록된 생일이 없어요',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '소중한 사람의 생일을 추가해보세요',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: birthdays.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final birthday = birthdays[index];
            return BirthdayListItem(
              birthday: birthday,
              onTap: () => Get.toNamed(
                AppRoutes.birthdayDetail,
                arguments: birthday.id,
              ),
              onDelete: () => controller.deleteBirthday(birthday.id),
            );
          },
        );
      },
    );
  }
}

// 설정 탭 페이지
class _SettingsPage extends StatefulWidget {
  const _SettingsPage();

  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> with WidgetsBindingObserver {
  final NotificationService _notificationService = NotificationService();
  final SettingsService _settingsService = SettingsService();
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  late int _notificationDaysBefore;
  late TimeOfDay _notificationTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
    _notificationDaysBefore = _settingsService.notificationDaysBefore;
    _notificationTime = _settingsService.notificationTime;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    final status = await _notificationService.checkPermission();
    if (mounted) {
      setState(() {
        _permissionStatus = status;
      });
    }
  }

  Future<void> _handleNotificationPermission() async {
    if (_permissionStatus.isGranted) {
      return;
    }

    if (_permissionStatus.isPermanentlyDenied) {
      // 영구 거부 상태면 설정 화면으로 이동
      final opened = await _notificationService.openSettings();
      if (!opened) {
        Get.snackbar(
          '설정',
          '설정 앱을 열 수 없습니다',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      // 권한 요청
      final granted = await _notificationService.requestPermission();
      await _checkPermission();

      if (granted) {
        // 알림 재스케줄링
        final controller = Get.find<BirthdayController>();
        await _notificationService
            .rescheduleAllBirthdayNotifications(controller.birthdays);

        Get.snackbar(
          '알림 권한',
          '알림이 활성화되었습니다',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );
      }
    }
  }

  String _getPermissionSubtitle() {
    if (_permissionStatus.isGranted) {
      return '알림이 활성화되어 있어요';
    } else if (_permissionStatus.isPermanentlyDenied) {
      return '설정에서 알림을 활성화해주세요';
    } else {
      return '생일 알림을 받으려면 권한이 필요해요';
    }
  }

  Widget? _getPermissionTrailing() {
    if (_permissionStatus.isGranted) {
      return const Icon(Icons.check_circle, color: AppColors.success);
    }
    return null;
  }

  Future<void> _showNotificationTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _notificationTime) {
      setState(() {
        _notificationTime = picked;
        _settingsService.notificationTime = picked;
      });

      // 알림 재스케줄링
      final controller = Get.find<BirthdayController>();
      await _notificationService
          .rescheduleAllBirthdayNotifications(controller.birthdays);

      Get.snackbar(
        '알림 시간 변경',
        '${_settingsService.notificationTimeLabel}에 알림을 받아요',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showNotificationDaysPicker() {
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
                  '알림 받을 시점',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Divider(height: 1),
              ...SettingsService.notificationDaysOptions.map((days) {
                final isSelected = _notificationDaysBefore == days;
                return ListTile(
                  title: Text(
                    SettingsService.getNotificationDaysLabel(days),
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _notificationDaysBefore = days;
                      _settingsService.notificationDaysBefore = days;
                    });
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        // 알림 설정 섹션
        _buildSectionHeader('알림'),
        _buildSettingTile(
          icon: Icons.notifications_outlined,
          title: '알림 권한',
          subtitle: _getPermissionSubtitle(),
          onTap: _permissionStatus.isGranted ? null : _handleNotificationPermission,
          trailing: _getPermissionTrailing(),
        ),
        _buildSettingTile(
          icon: Icons.schedule_outlined,
          title: '알림 시간',
          subtitle: _settingsService.notificationTimeLabel,
          onTap: _showNotificationTimePicker,
        ),
        _buildSettingTile(
          icon: Icons.calendar_month_outlined,
          title: '알림 받을 시점',
          subtitle: SettingsService.getNotificationDaysLabel(_notificationDaysBefore),
          onTap: _showNotificationDaysPicker,
        ),
        const Divider(height: 32),

        // 앱 정보 섹션
        _buildSectionHeader('앱 정보'),
        _buildSettingTile(
          icon: Icons.info_outline,
          title: '버전',
          subtitle: '1.0.0',
        ),
        _buildSettingTile(
          icon: Icons.pets,
          title: '기억해달',
          subtitle: '해달이 소중한 돌을 간직하듯, 소중한 생일을 간직해드려요',
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: AppColors.textTertiary) : null),
      onTap: onTap,
    );
  }
}
