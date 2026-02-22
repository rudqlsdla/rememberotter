import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rememberotter/app/app_bindings.dart';
import 'package:rememberotter/app/app_pages.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/data/database/app_database.dart';
import 'package:rememberotter/data/database/seed_data.dart';
import 'package:rememberotter/firebase_options.dart';
import 'package:rememberotter/gen/fonts.gen.dart';
import 'package:rememberotter/shared/log/logger.dart';
import 'package:rememberotter/shared/services/notification_service.dart';
import 'package:rememberotter/shared/services/remote_config_service.dart';
import 'package:rememberotter/shared/services/settings_service.dart';
import 'package:rememberotter/shared/services/shopping_link_service.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  logger.i('앱 시작');

  // ─── Firebase 초기화 ────────────────────────────────────────────────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.i('Firebase 초기화 완료');

  // ─── Remote Config 초기화 ───────────────────────────────────────────────
  await RemoteConfigService().initialize();
  logger.i('RemoteConfig 초기화 완료');

  // ─── Shopping Link 초기화 (Firestore) ──────────────────────────────────
  await ShoppingLinkService().initialize();
  logger.i('ShoppingLinkService 초기화 완료');

  // ─── Settings 초기화 ────────────────────────────────────────────────────
  await SettingsService().initialize();
  logger.i('Settings 초기화 완료');

  // ─── 데이터베이스 초기화 ──────────────────────────────────────────────────
  AppDatabase.instance;
  logger.i('데이터베이스 초기화 완료');

  // ─── 더미 데이터 (테스트용, 배포 전 제거) ─────────────────────────────────
  await seedDummyData();

  // ─── 알림 초기화 ──────────────────────────────────────────────────────
  await NotificationService().initialize();
  logger.i('알림 서비스 초기화 완료');

  // ─── Orientation ──────────────────────────────────────────────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _designPhone = Size(390, 844);
  static const _designTablet = Size(674, 842);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return ScreenUtilInit(
      designSize: isTablet ? _designTablet : _designPhone,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1),
        ),
        child: GetMaterialApp(
          navigatorObservers: [
            routeObserver,
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
          ],
          debugShowCheckedModeBanner: false,
          title: '기억해달',
          theme: ThemeData(
            fontFamily: FontFamily.maplestory,
          ),
          initialRoute: AppRoutes.splash,
          getPages: AppPages.routes,
          initialBinding: AppBindings(),
        ),
      ),
    );
  }
}
