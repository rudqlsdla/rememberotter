import 'package:get/get.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/feature/splash/pages/splash_page.dart';
import 'package:rememberotter/feature/onboarding/pages/notification_consent_page.dart';
import 'package:rememberotter/feature/main/pages/main_page.dart';
import 'package:rememberotter/feature/birthday/pages/birthday_detail_page.dart';
import 'package:rememberotter/feature/settings/pages/settings_page.dart';
import 'package:rememberotter/feature/settings/pages/oss_licenses_page.dart';
import 'package:rememberotter/feature/contact/pages/contact_import_page.dart';
import 'package:rememberotter/feature/onboarding/pages/contact_import_onboarding_page.dart';
import 'package:rememberotter/feature/group/pages/group_management_page.dart';

/// 앱의 페이지와 라우트 매핑
abstract class AppPages {
  static final routes = <GetPage>[
    // 스플래시 화면
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),

    // 알림 동의 화면
    GetPage(
      name: AppRoutes.notificationConsent,
      page: () => const NotificationConsentPage(),
    ),

    // 메인 화면
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
    ),

    // 생일 상세 화면
    GetPage(
      name: AppRoutes.birthdayDetail,
      page: () => const BirthdayDetailPage(),
    ),

    // 설정 화면
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
    ),

    // 오픈소스 라이선스 화면
    GetPage(
      name: AppRoutes.ossLicenses,
      page: () => const OssLicensesPage(),
    ),

    // 연락처 가져오기 화면
    GetPage(
      name: AppRoutes.contactImport,
      page: () => const ContactImportPage(),
    ),

    // 온보딩 연락처 가져오기 화면
    GetPage(
      name: AppRoutes.onboardingContactImport,
      page: () => const ContactImportOnboardingPage(),
    ),

    // 그룹 관리 화면
    GetPage(
      name: AppRoutes.groupManagement,
      page: () => const GroupManagementPage(),
    ),
  ];
}