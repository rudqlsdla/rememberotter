import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/gift/controllers/gift_controller.dart';
import 'package:rememberotter/feature/gift/widgets/gift_form_sheet.dart';
import 'package:rememberotter/feature/gift/widgets/gift_list_item.dart';
import 'package:rememberotter/shared/widgets/otter_image.dart';

class GiftHistorySection extends StatelessWidget {
  final String birthdayId;

  const GiftHistorySection({
    super.key,
    required this.birthdayId,
  });

  @override
  Widget build(BuildContext context) {
    final giftController = Get.find<GiftController>();

    return Obx(() {
      // gifts 리스트 변경 감지를 위해 length 접근
      giftController.gifts.length;
      final gifts = giftController.getGiftsByBirthdayId(birthdayId);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '선물 기록',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => GiftFormSheet.show(birthdayId: birthdayId),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('추가'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          if (gifts.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gifts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final gift = gifts[index];
                return GiftListItem(
                  gift: gift,
                  onTap: () => GiftFormSheet.show(
                    birthdayId: birthdayId,
                    gift: gift,
                  ),
                  onDelete: () => _deleteGift(gift.id),
                );
              },
            ),
        ],
      );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OtterImage(type: OtterType.gift, size: 80),
          SizedBox(height: 16),
          Text(
            '아직 선물 기록이 없어요',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '위의 추가 버튼을 눌러 기록해보세요',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  void _deleteGift(String id) {
    Get.find<GiftController>().deleteGift(id);
  }
}
