import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rememberotter/data/database/app_database.dart';
import 'package:rememberotter/domain/models/backup_data.dart';
import 'package:rememberotter/shared/log/logger.dart';
import 'package:rememberotter/shared/services/error_reporting_service.dart';

class BackupService {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  static const int _currentSchemaVersion = 1;

  AppDatabase get _db => AppDatabase.instance;

  // ── 내보내기 ──

  Future<bool> exportBackup() async {
    try {
      // DB에서 전체 데이터 조회
      final groupRows = await _db.select(_db.groups).get();
      final birthdayRows = await _db.select(_db.birthdays).get();
      final giftRows = await _db.select(_db.gifts).get();

      // Drift toJson()으로 직렬화
      final groupsJson = groupRows.map((r) => r.toJson()).toList();
      final birthdaysJson = birthdayRows.map((r) => r.toJson()).toList();
      final giftsJson = giftRows.map((r) => r.toJson()).toList();

      // 메타데이터 생성
      final metadata = BackupMetadata(
        appVersion: await _getAppVersion(),
        schemaVersion: _currentSchemaVersion,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        deviceInfo: await _getDeviceInfo(),
        birthdayCount: birthdayRows.length,
        giftCount: giftRows.length,
        groupCount: groupRows.length,
      );

      final backupData = BackupData(
        metadata: metadata,
        groups: groupsJson,
        birthdays: birthdaysJson,
        gifts: giftsJson,
      );

      // 임시 디렉토리에 파일 생성
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final fileName = 'rememberotter_backup_$timestamp.json';
      final file = File('${tempDir.path}/$fileName');

      final jsonString = const JsonEncoder.withIndent('  ')
          .convert(backupData.toJson());
      await file.writeAsString(jsonString);

      // 공유 시트 표시
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '기억해달 백업',
      );

      logger.i('백업 내보내기 성공: ${birthdayRows.length}건 생일, ${giftRows.length}건 선물, ${groupRows.length}건 그룹');
      return true;
    } catch (e, stack) {
      logger.e('백업 내보내기 실패: $e');
      ErrorReportingService().reportError(e, stack);
      return false;
    }
  }

  // ── 유효성 검증 ──

  Future<BackupValidationResult> validateBackupFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return BackupValidationResult(
          isValid: false,
          errorMessage: '파일을 찾을 수 없어요',
        );
      }

      final content = await file.readAsString();
      final Map<String, dynamic> json;
      try {
        json = jsonDecode(content) as Map<String, dynamic>;
      } catch (_) {
        return BackupValidationResult(
          isValid: false,
          errorMessage: '올바른 백업 파일이 아니에요',
        );
      }

      // 필수 키 확인
      if (!json.containsKey('metadata') ||
          !json.containsKey('birthdays') ||
          !json.containsKey('gifts')) {
        return BackupValidationResult(
          isValid: false,
          errorMessage: '올바른 백업 파일이 아니에요',
        );
      }

      final metadata = BackupMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>,
      );

      // schemaVersion 호환성
      if (metadata.schemaVersion > _currentSchemaVersion) {
        return BackupValidationResult(
          isValid: false,
          errorMessage: '앱을 업데이트한 후 다시 시도해주세요',
        );
      }

      return BackupValidationResult(
        isValid: true,
        metadata: metadata,
      );
    } catch (e, stack) {
      logger.e('백업 파일 검증 실패: $e');
      ErrorReportingService().reportError(e, stack);
      return BackupValidationResult(
        isValid: false,
        errorMessage: '파일을 읽는 중 오류가 발생했어요',
      );
    }
  }

  // ── 복원 ──

  Future<({bool success, String message})> restoreBackup(
    String filePath,
    RestoreMode mode,
  ) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final backupData = BackupData.fromJson(json);

      int restoredGroups = 0;
      int restoredBirthdays = 0;
      int restoredGifts = 0;
      int skippedCount = 0;

      if (mode == RestoreMode.overwrite) {
        await _db.transaction(() async {
          // FK 순서대로 삭제: Gifts → Birthdays → Groups
          await _db.delete(_db.gifts).go();
          await _db.delete(_db.birthdays).go();
          await _db.delete(_db.groups).go();

          // FK 순서대로 삽입: Groups → Birthdays → Gifts
          for (final groupJson in backupData.groups) {
            try {
              final row = GroupData.fromJson(groupJson);
              await _db.into(_db.groups).insert(GroupsCompanion.insert(
                id: row.id,
                name: row.name,
                colorValue: row.colorValue,
                sortOrder: row.sortOrder,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
              ));
              restoredGroups++;
            } catch (e) {
              logger.w('그룹 복원 건너뜀: $e');
              skippedCount++;
            }
          }

          for (final birthdayJson in backupData.birthdays) {
            try {
              final row = BirthdayData.fromJson(birthdayJson);
              await _db.into(_db.birthdays).insert(BirthdaysCompanion.insert(
                id: row.id,
                name: row.name,
                birthDate: row.birthDate,
                memo: Value(row.memo),
                profileImage: Value(row.profileImage),
                groupId: Value(row.groupId),
                isLunarCalendar: Value(row.isLunarCalendar),
                notificationEnabled: Value(row.notificationEnabled),
                notificationDaysBefore: Value(row.notificationDaysBefore),
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
              ));
              restoredBirthdays++;
            } catch (e) {
              logger.w('생일 복원 건너뜀: $e');
              skippedCount++;
            }
          }

          for (final giftJson in backupData.gifts) {
            try {
              final row = GiftData.fromJson(giftJson);
              await _db.into(_db.gifts).insert(GiftsCompanion.insert(
                id: row.id,
                birthdayId: row.birthdayId,
                year: row.year,
                given: Value(row.given),
                received: Value(row.received),
                givenGiftName: Value(row.givenGiftName),
                givenGiftPrice: Value(row.givenGiftPrice),
                receivedGiftName: Value(row.receivedGiftName),
                receivedGiftPrice: Value(row.receivedGiftPrice),
                memo: Value(row.memo),
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
              ));
              restoredGifts++;
            } catch (e) {
              logger.w('선물 복원 건너뜀: $e');
              skippedCount++;
            }
          }
        });
      } else {
        // 병합 모드: ID 기준 중복 건너뜀
        final existingGroupIds = (await _db.select(_db.groups).get())
            .map((r) => r.id)
            .toSet();
        final existingBirthdayIds = (await _db.select(_db.birthdays).get())
            .map((r) => r.id)
            .toSet();
        final existingGiftIds = (await _db.select(_db.gifts).get())
            .map((r) => r.id)
            .toSet();

        await _db.transaction(() async {
          for (final groupJson in backupData.groups) {
            try {
              final row = GroupData.fromJson(groupJson);
              if (existingGroupIds.contains(row.id)) {
                skippedCount++;
                continue;
              }
              await _db.into(_db.groups).insert(GroupsCompanion.insert(
                id: row.id,
                name: row.name,
                colorValue: row.colorValue,
                sortOrder: row.sortOrder,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
              ));
              restoredGroups++;
            } catch (e) {
              logger.w('그룹 병합 건너뜀: $e');
              skippedCount++;
            }
          }

          for (final birthdayJson in backupData.birthdays) {
            try {
              final row = BirthdayData.fromJson(birthdayJson);
              if (existingBirthdayIds.contains(row.id)) {
                skippedCount++;
                continue;
              }
              await _db.into(_db.birthdays).insert(BirthdaysCompanion.insert(
                id: row.id,
                name: row.name,
                birthDate: row.birthDate,
                memo: Value(row.memo),
                profileImage: Value(row.profileImage),
                groupId: Value(row.groupId),
                isLunarCalendar: Value(row.isLunarCalendar),
                notificationEnabled: Value(row.notificationEnabled),
                notificationDaysBefore: Value(row.notificationDaysBefore),
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
              ));
              restoredBirthdays++;
            } catch (e) {
              logger.w('생일 병합 건너뜀: $e');
              skippedCount++;
            }
          }

          for (final giftJson in backupData.gifts) {
            try {
              final row = GiftData.fromJson(giftJson);
              if (existingGiftIds.contains(row.id)) {
                skippedCount++;
                continue;
              }
              await _db.into(_db.gifts).insert(GiftsCompanion.insert(
                id: row.id,
                birthdayId: row.birthdayId,
                year: row.year,
                given: Value(row.given),
                received: Value(row.received),
                givenGiftName: Value(row.givenGiftName),
                givenGiftPrice: Value(row.givenGiftPrice),
                receivedGiftName: Value(row.receivedGiftName),
                receivedGiftPrice: Value(row.receivedGiftPrice),
                memo: Value(row.memo),
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
              ));
              restoredGifts++;
            } catch (e) {
              logger.w('선물 병합 건너뜀: $e');
              skippedCount++;
            }
          }
        });
      }

      final modeLabel = mode == RestoreMode.overwrite ? '덮어쓰기' : '병합';
      final message =
          '복원 완료: 생일 $restoredBirthdays건, 선물 $restoredGifts건, 그룹 $restoredGroups건'
          '${skippedCount > 0 ? ' (건너뜀 $skippedCount건)' : ''}';

      logger.i('백업 복원 성공 ($modeLabel): $message');
      return (success: true, message: message);
    } catch (e, stack) {
      logger.e('백업 복원 실패: $e');
      ErrorReportingService().reportError(e, stack);
      return (success: false, message: '복원 중 오류가 발생했어요');
    }
  }

  // ── 유틸 ──

  Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (_) {
      return '';
    }
  }

  Future<String> _getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        return 'iOS ${ios.systemVersion} | ${ios.utsname.machine}';
      } else if (Platform.isAndroid) {
        final android = await deviceInfo.androidInfo;
        return 'Android ${android.version.release} | ${android.manufacturer} ${android.model}';
      }
      return '';
    } catch (_) {
      return '';
    }
  }
}
