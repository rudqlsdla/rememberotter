import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rememberotter/shared/log/logger.dart';
import 'package:rememberotter/shared/services/error_reporting_service.dart';

/// 업데이트 상태
enum UpdateStatus {
  none, // 업데이트 불필요
  soft, // 선택 업데이트
  hard, // 강제 업데이트
}

/// Firebase Remote Config 서비스
class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// 버전 체크 결과 캐시
  UpdateStatus _updateStatus = UpdateStatus.none;
  bool updateSheetShown = false;

  UpdateStatus get updateStatus => _updateStatus;

  /// Remote Config 초기화 및 fetch
  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );

      await _remoteConfig.setDefaults({
        'hard_latest_version': '1.0.0',
        'soft_latest_version': '1.0.0',
        'latest_version': '1.0.0',
        'feedback_webhook_url': '',
      });

      await _remoteConfig.fetchAndActivate();
      logger.i('RemoteConfig 초기화 완료');
    } catch (e, stack) {
      logger.e('RemoteConfig 초기화 실패: $e');
      ErrorReportingService().reportError(e, stack);
    }
  }

  /// 스플래시에서 호출 - 버전 체크 결과 저장
  Future<void> checkAndStoreUpdateStatus() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      _currentVersion = currentVersion;

      final softLatestVersion = _remoteConfig.getString('soft_latest_version');
      final hardLatestVersion = _remoteConfig.getString('hard_latest_version');

      logger.i('현재 버전: $currentVersion');
      logger.i('소프트 최신 버전: $softLatestVersion');
      logger.i('하드 최신 버전: $hardLatestVersion');

      if (_isVersionOlder(currentVersion, hardLatestVersion)) {
        _updateStatus = UpdateStatus.hard;
      } else if (_isVersionOlder(currentVersion, softLatestVersion)) {
        _updateStatus = UpdateStatus.soft;
      } else {
        _updateStatus = UpdateStatus.none;
      }

      updateSheetShown = false;
      logger.i('업데이트 상태: $_updateStatus');
    } catch (e, stack) {
      logger.e('버전 체크 실패: $e');
      ErrorReportingService().reportError(e, stack);
      _updateStatus = UpdateStatus.none;
    }
  }

  /// 시맨틱 버전 비교 - current가 latest보다 오래된 경우 true
  bool _isVersionOlder(String current, String latest) {
    final currentParts = current.split('.').map(int.parse).toList();
    final latestParts = latest.split('.').map(int.parse).toList();
    final maxLength = currentParts.length > latestParts.length
        ? currentParts.length
        : latestParts.length;

    for (int i = 0; i < maxLength; i++) {
      final currentVal = i < currentParts.length ? currentParts[i] : 0;
      final latestVal = i < latestParts.length ? latestParts[i] : 0;

      if (currentVal < latestVal) return true;
      if (currentVal > latestVal) return false;
    }

    return false;
  }

  /// 최신 버전 (UI 표시용)
  String get latestVersion => _remoteConfig.getString('latest_version');

  /// 현재 버전이 최신 버전보다 낮은지 확인
  bool get hasNewVersion => _isVersionOlder(_currentVersion, latestVersion);

  String _currentVersion = '';

  /// 피드백 Webhook URL (Remote Config에서 관리)
  String get feedbackWebhookUrl => _remoteConfig.getString('feedback_webhook_url');

  /// 플랫폼별 스토어 URL
  String get storeUrl {
    if (Platform.isIOS) {
      return 'https://apps.apple.com/app/6758571069';
    }
    return 'https://play.google.com/store/apps/details?id=com.rudqlsdla.rememberotter';
  }
}
