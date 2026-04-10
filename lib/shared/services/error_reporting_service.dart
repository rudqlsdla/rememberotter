import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rememberotter/shared/log/logger.dart';

class ErrorReportingService {
  static final ErrorReportingService _instance =
      ErrorReportingService._internal();
  factory ErrorReportingService() => _instance;
  ErrorReportingService._internal();

  static const String _webhookUrl =
      'https://discord.com/api/webhooks/1492190176024461344/6H9gsXh-J4U0SQRvCiMXby1PysDdPgQsq1vH1i22RJc_5ESJ0o6Cfaealbc91_VrkFcV';

  // 레이트 리미팅
  final Map<String, DateTime> _lastReportedErrors = {};
  int _reportsThisMinute = 0;
  DateTime _minuteWindowStart = DateTime.now();

  /// 에러를 디스코드 웹훅으로 전송
  Future<void> reportError(dynamic error, StackTrace? stackTrace) async {
    if (kDebugMode) return;

    final errorKey = error.toString();
    if (!_shouldReport(errorKey)) return;

    try {
      final footerText = await _getDeviceInfo();
      final errorMessage = errorKey.length > 2048
          ? '${errorKey.substring(0, 2045)}...'
          : errorKey;

      final fields = <Map<String, dynamic>>[];
      if (stackTrace != null) {
        var trace = stackTrace.toString();
        if (trace.length > 1024) {
          trace = '${trace.substring(0, 1021)}...';
        }
        fields.add({
          'name': 'Stack Trace',
          'value': '```\n$trace\n```',
          'inline': false,
        });
      }

      final body = jsonEncode({
        'embeds': [
          {
            'title':
                '\u{1F6A8} ${error.runtimeType}',
            'description': errorMessage,
            'color': 16711680, // 0xFF0000 (빨간색)
            'fields': fields,
            'footer': {'text': footerText},
            'timestamp': DateTime.now().toUtc().toIso8601String(),
          }
        ],
      });

      await http.post(
        Uri.parse(_webhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
    } catch (_) {
      // 에러 리포팅 자체가 실패해도 앱에 영향 없도록 silent fail
    }
  }

  /// 레이트 리미팅 체크
  bool _shouldReport(String errorKey) {
    final now = DateTime.now();

    // 분당 윈도우 리셋
    if (now.difference(_minuteWindowStart).inSeconds >= 60) {
      _reportsThisMinute = 0;
      _minuteWindowStart = now;
    }

    // 분당 최대 10건
    if (_reportsThisMinute >= 10) return false;

    // 동일 에러 60초 쿨다운
    final lastReported = _lastReportedErrors[errorKey];
    if (lastReported != null &&
        now.difference(lastReported).inSeconds < 60) {
      return false;
    }

    _lastReportedErrors[errorKey] = now;
    _reportsThisMinute++;
    return true;
  }

  Future<String> _getDeviceInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfo = DeviceInfoPlugin();
      String deviceModel = '';
      String osVersion = '';

      if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        deviceModel = ios.utsname.machine;
        osVersion = 'iOS ${ios.systemVersion}';
      } else if (Platform.isAndroid) {
        final android = await deviceInfo.androidInfo;
        deviceModel = '${android.manufacturer} ${android.model}';
        osVersion = 'Android ${android.version.release}';
      }

      return 'v${packageInfo.version} | $osVersion | $deviceModel';
    } catch (e) {
      logger.e('기기 정보 수집 실패: $e');
      return 'v? | 기기 정보 수집 실패';
    }
  }
}
