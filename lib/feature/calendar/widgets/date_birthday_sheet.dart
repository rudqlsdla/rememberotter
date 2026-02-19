import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/domain/models/birthday.dart';
import 'package:rememberotter/feature/birthday/controllers/birthday_controller.dart';
import 'package:rememberotter/feature/birthday/widgets/birthday_form_sheet.dart';
import 'package:rememberotter/shared/widgets/otter_image.dart';

class DateBirthdaySheet extends StatelessWidget {
  final DateTime date;
  final List<Birthday> birthdays;

  const DateBirthdaySheet({
    super.key,
    required this.date,
    required this.birthdays,
  });

  static Future<void> show(DateTime date) {
    final controller = Get.find<BirthdayController>();
    final birthdays = controller.getBirthdaysOnDate(date);

    return Get.bottomSheet(
      DateBirthdaySheet(date: date, birthdays: birthdays),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final isThisYear = date.year == now.year;
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];

    if (isThisYear) {
      return '${date.month}월 ${date.day}일 ($weekday)';
    }
    return '${date.year}년 ${date.month}월 ${date.day}일 ($weekday)';
  }

  @override
  Widget build(BuildContext context) {
    final hasNoBirthdays = birthdays.isEmpty;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(date),
                  style: const TextStyle(
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
            // 생일 목록 또는 빈 상태
            if (hasNoBirthdays)
              _buildEmptyState()
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: birthdays.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 48),
                  itemBuilder: (context, index) {
                    final birthday = birthdays[index];
                    return _buildBirthdayItem(birthday);
                  },
                ),
              ),
            const SizedBox(height: 24),
            // 생일 추가 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  BirthdayFormSheet.show();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '추가하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OtterImage(type: OtterType.empty, size: 80),
            const SizedBox(height: 16),
            const Text(
              '이 날에 등록된 생일이 없어요',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBirthdayItem(Birthday birthday) {
    final daysUntil = birthday.daysUntilBirthday;
    final isToday = daysUntil == 0;

    return ListTile(
      onTap: () {
        Get.back();
        Get.toNamed(AppRoutes.birthdayDetail, arguments: birthday.id);
      },
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: isToday ? AppColors.accent : AppColors.primaryLight,
        child: Text(
          birthday.name.isNotEmpty ? birthday.name[0] : '?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isToday ? Colors.white : AppColors.primary,
          ),
        ),
      ),
      title: Text(
        birthday.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        '${birthday.birthDate.year}년생${birthday.ageText != null ? ' (${birthday.ageText})' : ''}',
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: isToday
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '오늘!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            )
          : const Icon(Icons.chevron_right, color: AppColors.textTertiary),
    );
  }
}
