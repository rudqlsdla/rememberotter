import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/domain/models/birthday.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/birthday/controllers/birthday_controller.dart';
import 'package:rememberotter/feature/birthday/widgets/birthday_form_sheet.dart';
import 'package:rememberotter/feature/gift/widgets/gift_history_section.dart';

class BirthdayDetailPage extends StatelessWidget {
  const BirthdayDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String birthdayId = Get.arguments as String;
    final birthdayController = Get.find<BirthdayController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '생일 상세',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            final birthday = birthdayController.birthdays
                .where((b) => b.id == birthdayId)
                .firstOrNull;
            if (birthday == null) return const SizedBox();
            return IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
              onPressed: () => BirthdayFormSheet.show(birthday: birthday),
            );
          }),
        ],
      ),
      body: Obx(() {
        final birthday = birthdayController.birthdays
            .where((b) => b.id == birthdayId)
            .firstOrNull;

        if (birthday == null) {
          return const Center(
            child: Text('생일 정보를 찾을 수 없어요'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileSection(birthday),
              const SizedBox(height: 16),
              _buildInfoSection(birthday),
              const SizedBox(height: 16),
              GiftHistorySection(birthdayId: birthday.id),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileSection(Birthday birthday) {
    final daysUntil = birthday.daysUntilBirthday;
    final isToday = daysUntil == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: Column(
        children: [
          // 이름
          Text(
            birthday.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          // D-day 뱃지
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isToday ? AppColors.accent : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isToday ? '오늘 생일이에요!' : 'D-$daysUntil',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isToday ? Colors.white : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Birthday birthday) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '정보',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.cake_outlined,
            label: birthday.isLunarCalendar ? '생년월일 (음력)' : '생년월일',
            value: '${birthday.birthDate.year}년 ${birthday.birthDate.month}월 ${birthday.birthDate.day}일',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.person_outline,
            label: '나이',
            value: birthday.age != null ? '${birthday.age}세' : '-',
          ),
          if (birthday.memo != null && birthday.memo!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.note_outlined,
              label: '메모',
              value: birthday.memo!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}
