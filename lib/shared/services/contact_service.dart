import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rememberotter/shared/log/logger.dart';

class ContactService {
  static final ContactService _instance = ContactService._internal();
  factory ContactService() => _instance;
  ContactService._internal();

  /// 연락처 권한이 허용되었는지 확인
  Future<bool> isPermissionGranted() async {
    final status = await Permission.contacts.status;
    return status.isGranted;
  }

  /// 연락처 권한이 영구 거부되었는지 확인
  Future<bool> isPermissionPermanentlyDenied() async {
    final status = await Permission.contacts.status;
    return status.isPermanentlyDenied;
  }

  /// 연락처 권한 요청
  Future<bool> requestPermission() async {
    final status = await Permission.contacts.request();
    logger.i('연락처 권한 요청 결과: $status');
    return status.isGranted;
  }

  /// 앱 설정 화면 열기
  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  /// 모든 연락처 목록 반환
  Future<List<Contact>> getAllContacts() async {
    final granted = await isPermissionGranted();
    if (!granted) {
      logger.w('연락처 권한 없음');
      return [];
    }

    final contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: false,
    );

    final withBirthday = contacts.where((c) =>
        c.events.any((e) => e.label == EventLabel.birthday)).length;
    logger.i('연락처: ${contacts.length}명 (생일 있는 연락처: $withBirthday명)');
    return contacts;
  }
}
