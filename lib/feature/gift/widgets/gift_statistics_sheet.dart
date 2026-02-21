import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/birthday/controllers/birthday_controller.dart';
import 'package:rememberotter/feature/gift/controllers/gift_controller.dart';
import 'package:rememberotter/domain/models/gift.dart';
import 'package:rememberotter/shared/utils/price_formatter.dart';
import 'package:rememberotter/shared/widgets/year_picker_spinner.dart';

class GiftStatisticsSheet extends StatefulWidget {
  const GiftStatisticsSheet({super.key});

  static Future<void> show() {
    return Get.bottomSheet(
      const GiftStatisticsSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  State<GiftStatisticsSheet> createState() => _GiftStatisticsSheetState();
}

class _GiftStatisticsSheetState extends State<GiftStatisticsSheet> {
  int _selectedYear = DateTime.now().year;

  List<Gift> get _filteredGifts {
    final controller = Get.find<GiftController>();
    return controller.gifts.where((g) => g.year == _selectedYear).toList();
  }

  int get _givenTotal {
    return _filteredGifts
        .where((g) => g.given && g.givenGiftPrice != null)
        .fold(0, (sum, g) => sum + g.givenGiftPrice!);
  }

  int get _receivedTotal {
    return _filteredGifts
        .where((g) => g.received && g.receivedGiftPrice != null)
        .fold(0, (sum, g) => sum + g.receivedGiftPrice!);
  }

  int get _givenCount => _filteredGifts.where((g) => g.given).length;

  int get _receivedCount => _filteredGifts.where((g) => g.received).length;

  int get _difference => _givenTotal - _receivedTotal;

  void _selectYear() {
    int tempYear = _selectedYear;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 280,
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Text(
                      '연도 선택',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedYear = tempYear;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: YearPickerSpinner(
                    height: 150,
                    year: _selectedYear,
                    onChanged: (year) {
                      tempYear = year;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Obx로 감싸서 gifts 변경 시 자동 갱신
      final _ = Get.find<GiftController>().gifts.length;

      final gifts = _filteredGifts;
      final hasData = gifts.isNotEmpty;

      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _selectYear,
                    child: Row(
                      children: [
                        Text(
                          '$_selectedYear년 선물 통계',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            if (!hasData) ...[
              const SizedBox(height: 60),
              const Icon(
                Icons.card_giftcard,
                size: 48,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 16),
              const Text(
                '선물 기록이 없어요',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 60),
            ],

            if (hasData) ...[
              const SizedBox(height: 20),

              // 요약 카드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        label: '준 선물',
                        amount: _givenTotal,
                        count: _givenCount,
                        color: AppColors.primary,
                        icon: Icons.redeem,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        label: '받은 선물',
                        amount: _receivedTotal,
                        count: _receivedCount,
                        color: AppColors.accent,
                        icon: Icons.favorite,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 수지 표시
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildBalanceCard(),
              ),
              const SizedBox(height: 20),

              // 개별 내역 리스트
              const Padding(
                padding: EdgeInsets.only(left: 24, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '내역',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: gifts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return _buildGiftItem(gifts[index]);
                  },
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildSummaryCard({
    required String label,
    required int amount,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.op(color, 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            amount > 0 ? PriceFormatter.formatWithUnit(amount) : '-',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count건',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    final String message;
    final Color messageColor;

    if (_difference > 0) {
      message = '${PriceFormatter.formatWithUnit(_difference)} 더 썼어요!';
      messageColor = AppColors.primary;
    } else if (_difference < 0) {
      message = '${PriceFormatter.formatWithUnit(-_difference)} 더 받았어요!';
      messageColor = AppColors.accent;
    } else {
      message = '딱 맞아요!';
      messageColor = AppColors.success;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: messageColor,
          ),
        ),
      ),
    );
  }

  Widget _buildGiftItem(Gift gift) {
    final birthdayController = Get.find<BirthdayController>();
    final birthday = birthdayController.birthdays
        .firstWhereOrNull((b) => b.id == gift.birthdayId);
    final name = birthday?.name ?? '알 수 없음';

    final List<Widget> details = [];

    if (gift.given) {
      final priceText = gift.givenGiftPrice != null
          ? PriceFormatter.formatWithUnit(gift.givenGiftPrice!)
          : '';
      final giftName = gift.givenGiftName ?? '';
      final detail = [giftName, priceText].where((s) => s.isNotEmpty).join(' · ');
      details.add(
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.op(AppColors.primary, 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '준',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                detail.isNotEmpty ? detail : '선물함',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    if (gift.received) {
      final priceText = gift.receivedGiftPrice != null
          ? PriceFormatter.formatWithUnit(gift.receivedGiftPrice!)
          : '';
      final giftName = gift.receivedGiftName ?? '';
      final detail = [giftName, priceText].where((s) => s.isNotEmpty).join(' · ');
      details.add(
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.op(AppColors.accent, 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '받음',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                detail.isNotEmpty ? detail : '받음',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (details.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  ...details.map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: d,
                  )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
