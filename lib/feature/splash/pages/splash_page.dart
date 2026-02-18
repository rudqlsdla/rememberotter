import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/onboarding/pages/notification_consent_page.dart';
import 'package:rememberotter/shared/log/logger.dart';
import 'package:rememberotter/shared/services/remote_config_service.dart';
import 'package:rememberotter/shared/widgets/otter_image.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    logger.i('스플래시 화면 시작');

    // 2초 대기 + 버전 체크 병렬 실행
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      RemoteConfigService().checkAndStoreUpdateStatus(),
    ]);

    // 알림 동의 화면을 봤는지 확인
    final hasShownConsent = await NotificationConsentPage.hasShownConsent();

    if (hasShownConsent) {
      // 이미 봤으면 메인 화면으로
      Get.offAllNamed(AppRoutes.main);
    } else {
      // 처음이면 알림 동의 화면으로
      Get.offAllNamed(AppRoutes.notificationConsent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            OtterImage(type: OtterType.splash, size: 140),
            SizedBox(height: 24),
            Text(
              '기억해달',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '해달이 소중한 돌을 간직하듯\n소중한 생일을 간직해드려요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}