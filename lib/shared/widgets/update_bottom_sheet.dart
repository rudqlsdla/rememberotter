import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/shared/services/remote_config_service.dart';
import 'package:rememberotter/shared/widgets/otter_image.dart';

/// 업데이트 안내 바텀시트
class UpdateBottomSheet {
  /// 업데이트가 필요한 경우 바텀시트 표시
  /// 바텀시트가 닫힐 때까지 기다림
  static Future<void> showIfNeeded() async {
    final service = RemoteConfigService();

    if (service.updateStatus == UpdateStatus.none || service.updateSheetShown) {
      return;
    }

    service.updateSheetShown = true;
    final isHard = service.updateStatus == UpdateStatus.hard;

    await Get.bottomSheet(
      _UpdateSheetContent(isHard: isHard),
      isDismissible: !isHard,
      enableDrag: !isHard,
      backgroundColor: Colors.transparent,
    );
  }
}

class _UpdateSheetContent extends StatelessWidget {
  final bool isHard;

  const _UpdateSheetContent({required this.isHard});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isHard,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 해달 캐릭터
              const OtterImage(type: OtterType.wave, size: 100),
              const SizedBox(height: 20),

              // 제목
              Text(
                isHard ? '필수 업데이트가 있어요!' : '새로운 버전이 나왔어요!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              // 설명
              Text(
                isHard
                    ? '앱을 계속 사용하려면\n최신 버전으로 업데이트해주세요.'
                    : '더 나은 기억해달을 위해\n업데이트를 권장해요.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // 업데이트 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _openStore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '업데이트하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // 나중에 버튼 (soft update만)
              if (!isHard) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '나중에 할게요',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _openStore() async {
    final url = Uri.parse(RemoteConfigService().storeUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
