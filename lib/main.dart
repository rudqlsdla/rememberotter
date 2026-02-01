import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rememberotter/app/app_bindings.dart';
import 'package:rememberotter/app/app_pages.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/data/models/birthday.dart';
import 'package:rememberotter/shared/log/logger.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  logger.i('앱 시작');

  // ─── Hive 초기화 ──────────────────────────────────────────────────────
  await Hive.initFlutter();
  Hive.registerAdapter(BirthdayAdapter());
  await Hive.openBox<Birthday>('birthdays');
  logger.i('Hive 초기화 완료');

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
          navigatorObservers: [routeObserver],
          debugShowCheckedModeBanner: false,
          title: '기억해달',
          theme: ThemeData(
            fontFamily: 'Maplestory',
          ),
          initialRoute: AppRoutes.splash,
          getPages: AppPages.routes,
          initialBinding: AppBindings(),
        ),
      ),
    );
  }
}