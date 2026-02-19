import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/shared/services/notification_service.dart';
import 'package:rememberotter/shared/widgets/otter_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationConsentPage extends StatelessWidget {
  const NotificationConsentPage({super.key});

  static const String _consentKey = 'notificationConsentShown';

  /// 동의 화면을 이미 봤는지 확인
  static Future<bool> hasShownConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_consentKey) ?? false;
  }

  /// 동의 화면을 봤다고 표시
  static Future<void> markConsentShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, true);
  }

  Future<void> _onAllow() async {
    final notificationService = NotificationService();
    await notificationService.requestPermission();
    await markConsentShown();
    Get.offAllNamed(AppRoutes.main);
  }

  Future<void> _onSkip() async {
    await markConsentShown();
    Get.offAllNamed(AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // 해달 이미지
              const OtterImage(type: OtterType.celebrate, size: 160),
              const SizedBox(height: 32),
              // 타이틀
              const Text(
                '생일 알림을 받아보세요!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // 설명
              const Text(
                '소중한 사람들의 생일을 놓치지 않도록\n기억해달이 미리 알려드릴게요',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // 기능 설명
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildFeatureRow(
                      icon: Icons.cake_outlined,
                      text: '생일 당일 또는 미리 알림',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureRow(
                      icon: Icons.schedule_outlined,
                      text: '원하는 시간에 알림 받기',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureRow(
                      icon: Icons.notifications_off_outlined,
                      text: '언제든 설정에서 변경 가능',
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              // 동의 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onAllow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '알림 허용하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 나중에 버튼
              TextButton(
                onPressed: _onSkip,
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
}
