import 'package:flutter/material.dart';
import 'package:memocal/data/models/birthday.dart';
import 'package:memocal/design_system/variable/app_colors.dart';

class BirthdayListItem extends StatelessWidget {
  final Birthday birthday;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const BirthdayListItem({
    super.key,
    required this.birthday,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final daysUntil = birthday.daysUntilBirthday;
    final isToday = daysUntil == 0;

    return Dismissible(
      key: Key(birthday.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          '${birthday.birthDate.month}월 ${birthday.birthDate.day}일${birthday.age != null ? ' (${birthday.age}세)' : ''}',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isToday ? AppColors.accent : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isToday ? '오늘!' : 'D-$daysUntil',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isToday ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
