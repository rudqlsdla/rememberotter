import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rememberotter/shared/log/logger.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  static const String _webhookUrl =
      'https://discord.com/api/webhooks/1473940341349421198/WmfuWbKZ4ejYYLPGvr_l8HGyZThsrAOyirqH6BW6OGRXlU5n3eU6NtOKnIOionEGYPl3';

  Future<bool> sendFeedback(String content) async {
    try {
      final footerText = await _getDeviceInfo();

      final body = jsonEncode({
        'embeds': [
          {
            'title': '\u{1F4EC} 새로운 피드백',
            'description': content,
            'color': 12100582, // #B8A3E6
            'footer': {'text': footerText},
            'timestamp': DateTime.now().toUtc().toIso8601String(),
          }
        ],
      });

      final response = await http.post(
        Uri.parse(_webhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        logger.i('피드백 전송 성공');
        return true;
      } else {
        logger.e('피드백 전송 실패: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      logger.e('피드백 전송 에러: $e');
      return false;
    }
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
      return 'v? | 기기 정보 수집 실패';
    }
  }
}
