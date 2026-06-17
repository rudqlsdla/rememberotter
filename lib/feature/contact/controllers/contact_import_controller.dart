import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:rememberotter/feature/birthday/controllers/birthday_controller.dart';
import 'package:rememberotter/shared/log/logger.dart';
import 'package:rememberotter/shared/services/contact_service.dart';

class ContactImportController extends GetxController {
  final ContactService _contactService = ContactService();

  final RxList<Contact> contacts = <Contact>[].obs;
  final RxSet<String> selectedContactIds = <String>{}.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasPermission = false.obs;
  final Set<String> _importedKeys = {};

  /// 연락처에 생일이 없는 경우 사용자가 직접 입력한 생일
  final RxMap<String, DateTime> manualBirthdays = <String, DateTime>{}.obs;

  List<Contact> get filteredContacts {
    if (searchQuery.value.isEmpty) return contacts;
    final query = searchQuery.value.toLowerCase();
    return contacts.where((c) => c.displayName.toLowerCase().contains(query)).toList();
  }

  int get selectableCount {
    return filteredContacts
        .where((c) => !isAlreadyImported(c) && getBirthday(c) != null)
        .length;
  }

  bool get isAllSelected {
    if (selectableCount == 0) return false;
    return filteredContacts
        .where((c) => !isAlreadyImported(c) && getBirthday(c) != null)
        .every((c) => selectedContactIds.contains(c.id));
  }

  @override
  void onInit() {
    super.onInit();
    _buildAlreadyImportedKeys();
    _loadContacts();
  }

  /// 기존 생일 데이터에서 중복 감지용 키 생성
  void _buildAlreadyImportedKeys() {
    final birthdayController = Get.find<BirthdayController>();
    _importedKeys.clear();
    for (final birthday in birthdayController.birthdays) {
      final key = _makeDuplicateKey(
        birthday.name,
        birthday.birthDate.month,
        birthday.birthDate.day,
      );
      _importedKeys.add(key);
    }
  }

  String _makeDuplicateKey(String name, int month, int day) {
    return '${name.trim().toLowerCase()}|$month-$day';
  }

  /// 연락처의 생일 가져오기 (연락처 자체 or 수동 입력)
  DateTime? getBirthday(Contact contact) {
    // 수동 입력된 생일 우선
    final manual = manualBirthdays[contact.id];
    if (manual != null) return manual;

    // 연락처에 저장된 생일
    final birthdayEvent = contact.events
        .where((e) => e.label == EventLabel.birthday)
        .firstOrNull;
    if (birthdayEvent == null) return null;

    final year = birthdayEvent.year ?? 2000;
    return DateTime(year, birthdayEvent.month, birthdayEvent.day);
  }

  /// 연락처의 첫 번째 전화번호 (없으면 null)
  String? getPhone(Contact contact) {
    return contact.phones.firstOrNull?.number;
  }

  /// 연락처에 생일 정보가 있는지 확인
  bool hasContactBirthday(Contact contact) {
    return contact.events.any((e) => e.label == EventLabel.birthday);
  }

  /// 이미 앱에 등록된 연락처인지 확인
  bool isAlreadyImported(Contact contact) {
    final birthday = getBirthday(contact);
    if (birthday == null) return false;
    final key = _makeDuplicateKey(
      contact.displayName,
      birthday.month,
      birthday.day,
    );
    return _importedKeys.contains(key);
  }

  /// 생일 직접 입력/수정
  void setBirthday(String contactId, DateTime date) {
    manualBirthdays[contactId] = date;
    // 생일 설정 후 자동 선택
    if (!selectedContactIds.contains(contactId)) {
      final contact = contacts.firstWhereOrNull((c) => c.id == contactId);
      if (contact != null && !isAlreadyImported(contact)) {
        selectedContactIds.add(contactId);
      }
    }
  }

  /// 연락처 로드
  Future<void> _loadContacts() async {
    isLoading.value = true;

    final granted = await _contactService.isPermissionGranted();
    if (!granted) {
      final requested = await _contactService.requestPermission();
      hasPermission.value = requested;
      if (!requested) {
        isLoading.value = false;
        return;
      }
    } else {
      hasPermission.value = true;
    }

    final result = await _contactService.getAllContacts();
    // 이름순 정렬
    result.sort((a, b) => a.displayName.compareTo(b.displayName));
    contacts.value = result;
    isLoading.value = false;
  }

  /// 권한 재요청
  Future<void> retryPermission() async {
    // 권한 재요청 시도 (Android에서는 다이얼로그가 다시 뜰 수 있음)
    final granted = await _contactService.requestPermission();
    if (granted) {
      hasPermission.value = true;
      await _loadContacts();
      return;
    }

    // iOS: 한 번 거부하면 request()로는 다이얼로그가 뜨지 않으므로 설정으로 이동
    await _contactService.openSettings();
  }

  /// 앱 포커스 복귀 시 권한 재확인
  Future<void> recheckPermission() async {
    final granted = await _contactService.isPermissionGranted();
    if (granted && !hasPermission.value) {
      hasPermission.value = true;
      await _loadContacts();
    }
  }

  /// 연락처 선택/해제 토글 (생일이 있는 경우만 선택 가능)
  void toggleContact(String contactId) {
    if (selectedContactIds.contains(contactId)) {
      selectedContactIds.remove(contactId);
    } else {
      selectedContactIds.add(contactId);
    }
  }

  /// 전체 선택/해제 (생일이 있는 연락처만)
  void toggleSelectAll() {
    if (isAllSelected) {
      for (final contact in filteredContacts) {
        selectedContactIds.remove(contact.id);
      }
    } else {
      for (final contact in filteredContacts) {
        if (!isAlreadyImported(contact) && getBirthday(contact) != null) {
          selectedContactIds.add(contact.id);
        }
      }
    }
  }

  /// 선택된 연락처 일괄 가져오기
  Future<int> importSelected() async {
    final birthdayController = Get.find<BirthdayController>();
    final selectedContacts = contacts
        .where((c) => selectedContactIds.contains(c.id))
        .toList();

    final List<({String name, DateTime birthDate, String? groupId, String? phoneNumber})> toImport = [];

    for (final contact in selectedContacts) {
      final birthday = getBirthday(contact);
      if (birthday == null) continue;
      if (isAlreadyImported(contact)) continue;

      toImport.add((
        name: contact.displayName,
        birthDate: birthday,
        groupId: null,
        phoneNumber: getPhone(contact),
      ));
    }

    if (toImport.isEmpty) return 0;

    await birthdayController.addBirthdayBatch(toImport);

    // 중복 키 갱신
    _buildAlreadyImportedKeys();
    selectedContactIds.clear();

    logger.i('${toImport.length}명 연락처 가져오기 완료');
    return toImport.length;
  }
}
