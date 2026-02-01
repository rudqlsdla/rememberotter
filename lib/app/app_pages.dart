import 'package:get/get.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/feature/splash/pages/splash_page.dart';
import 'package:rememberotter/feature/main/pages/main_page.dart';
import 'package:rememberotter/feature/birthday/pages/birthday_detail_page.dart';
import 'package:rememberotter/feature/settings/pages/settings_page.dart';

/// 앱의 페이지와 라우트 매핑
abstract class AppPages {
  static final routes = <GetPage>[
    // 스플래시 화면
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
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
  ];
}