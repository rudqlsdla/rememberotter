import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/shared/services/feedback_service.dart';

class FeedbackSheet extends StatefulWidget {
  const FeedbackSheet({super.key});

  static Future<void> show() {
    return Get.bottomSheet(
      const FeedbackSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet> {
  final _contentController = TextEditingController();
  final _feedbackService = FeedbackService();
  bool _isSending = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSending = true);

    final success = await _feedbackService.sendFeedback(content);

    setState(() => _isSending = false);

    if (success) {
      Get.back();
      Get.snackbar(
        '피드백 전송 완료',
        '소중한 의견 감사합니다!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        '전송 실패',
        '잠시 후 다시 시도해주세요',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '피드백 보내기',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 피드백 입력
          TextFormField(
            controller: _contentController,
            maxLines: 5,
            minLines: 3,
            decoration: InputDecoration(
              hintText: '불편한 점이나 개선 아이디어를 알려주세요',
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 전송 버튼
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isSending ? null : _send,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isSending
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                '보내기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SafeArea(child: const SizedBox.shrink()),
        ],
      ),
    );
  }
}
