import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/birthday/controllers/birthday_controller.dart';
import 'package:rememberotter/shared/services/notification_service.dart';
import 'package:rememberotter/shared/services/settings_service.dart';
import 'package:rememberotter/shared/widgets/time_picker_spinner.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with WidgetsBindingObserver {
  final NotificationService _notificationService = NotificationService();
  final SettingsService _settingsService = SettingsService();
  PermissionStatus? _permissionStatus;
  late int _notificationDaysBefore;
  late TimeOfDay _notificationTime;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
    _notificationDaysBefore = _settingsService.notificationDaysBefore;
    _notificationTime = _settingsService.notificationTime;
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = packageInfo.version;
      });
    }
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
    if (_permissionStatus == null) return;
    if (_permissionStatus!.isGranted) {
      return;
    }

    if (_permissionStatus!.isPermanentlyDenied) {
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
    if (_permissionStatus == null) {
      return '';
    }
    if (_permissionStatus!.isGranted) {
      return '알림이 활성화되어 있어요';
    } else if (_permissionStatus!.isPermanentlyDenied) {
      return '설정에서 알림을 활성화해주세요';
    } else {
      return '생일 알림을 받으려면 권한이 필요해요';
    }
  }

  Widget? _getPermissionTrailing() {
    if (_permissionStatus == null) return null;
    if (_permissionStatus!.isGranted) {
      return const Icon(Icons.check_circle, color: AppColors.success);
    }
    return null;
  }

  void _showNotificationTimePicker() {
    TimeOfDay tempTime = _notificationTime;

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
                      '알림 시간',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          _notificationTime = tempTime;
                          _settingsService.notificationTime = tempTime;
                        });
                        Navigator.pop(context);

                        // 알림 재스케줄링
                        final controller = Get.find<BirthdayController>();
                        await _notificationService
                            .rescheduleAllBirthdayNotifications(controller.birthdays);

                        Get.snackbar(
                          '알림 시간 변경',
                          '${_settingsService.notificationTimeLabel}에 알림을 받아요',
                          snackPosition: SnackPosition.BOTTOM,
                        );
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
              // Time Picker
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TimePickerSpinner(
                    height: 150,
                    time: _notificationTime,
                    onChanged: (time) {
                      tempTime = time;
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
                  onTap: () async {
                    setState(() {
                      _notificationDaysBefore = days;
                      _settingsService.notificationDaysBefore = days;
                    });
                    Navigator.pop(context);

                    // 기존 생일 데이터도 일괄 업데이트
                    final controller = Get.find<BirthdayController>();
                    await controller.updateAllNotificationDaysBefore(days);

                    Get.snackbar(
                      '알림 설정 변경',
                      '모든 생일의 알림 시점이 ${SettingsService.getNotificationDaysLabel(days)}(으)로 변경되었어요',
                      snackPosition: SnackPosition.BOTTOM,
                    );
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

  void _showAgeTypePicker() {
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
                  '나이 표시 방식',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Divider(height: 1),
              _buildAgeOption(
                title: '만 나이',
                subtitle: '생일이 지나야 한 살 추가',
                isSelected: _settingsService.useInternationalAge,
                onTap: () {
                  setState(() => _settingsService.useInternationalAge = true);
                  Navigator.pop(context);
                },
              ),
              _buildAgeOption(
                title: '연 나이',
                subtitle: '올해 연도 - 출생 연도',
                isSelected: !_settingsService.useInternationalAge,
                onTap: () {
                  setState(() => _settingsService.useInternationalAge = false);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAgeOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          // 알림 설정 섹션
          _buildSectionHeader('알림'),
          _buildSettingTile(
            icon: Icons.notifications_outlined,
            title: '알림 권한',
            subtitle: _getPermissionSubtitle(),
            onTap: (_permissionStatus?.isGranted ?? false) ? null : _handleNotificationPermission,
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

          // 표시 섹션
          _buildSectionHeader('표시'),
          _buildSettingTile(
            icon: Icons.cake_outlined,
            title: '나이 표시 방식',
            subtitle: _settingsService.useInternationalAge ? '만 나이' : '연 나이',
            onTap: _showAgeTypePicker,
          ),
          const Divider(height: 32),

          // 데이터 섹션
          _buildSectionHeader('데이터'),
          _buildSettingTile(
            icon: Icons.contacts_outlined,
            title: '연락처에서 가져오기',
            subtitle: '연락처에 저장된 생일을 가져올 수 있어요',
            onTap: () => Get.toNamed(AppRoutes.contactImport),
          ),
          const Divider(height: 32),

          // 앱 정보 섹션
          _buildSectionHeader('앱 정보'),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: '버전',
            subtitle: _appVersion.isEmpty ? '-' : _appVersion,
          ),
          _buildSettingTile(
            icon: Icons.description_outlined,
            title: '오픈소스 라이선스',
            subtitle: '사용된 오픈소스 라이브러리',
            onTap: () => Get.toNamed(AppRoutes.ossLicenses),
          ),
          _buildSettingTile(
            icon: Icons.pets,
            title: '기억해달',
            subtitle: '해달이 소중한 돌을 간직하듯, 소중한 생일을 간직해드려요',
          ),
        ],
      ),
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
