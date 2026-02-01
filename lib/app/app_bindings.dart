import 'package:get/get.dart';
import 'package:rememberotter/feature/birthday/controllers/birthday_controller.dart';
import 'package:rememberotter/feature/gift/controllers/gift_controller.dart';

/// 앱 전체에서 사용할 글로벌 바인딩
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BirthdayController>(() => BirthdayController(), fenix: true);
    Get.lazyPut<GiftController>(() => GiftController(), fenix: true);
  }
}