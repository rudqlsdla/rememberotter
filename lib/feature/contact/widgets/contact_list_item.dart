import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';

class ContactListItem extends StatelessWidget {
  final Contact contact;
  final DateTime? birthday;
  final bool isSelected;
  final bool isAlreadyImported;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onSetBirthday;

  const ContactListItem({
    super.key,
    required this.contact,
    required this.birthday,
    required this.isSelected,
    required this.isAlreadyImported,
    this.onChanged,
    this.onSetBirthday,
  });

  @override
  Widget build(BuildContext context) {
    final name = contact.displayName;
    final initial = name.isNotEmpty ? name[0] : '?';
    final hasBirthday = birthday != null;
    final canSelect = hasBirthday && !isAlreadyImported;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isAlreadyImported ? true : isSelected,
              onChanged: canSelect ? onChanged : null,
              activeColor: isAlreadyImported ? AppColors.textTertiary : AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundColor: isAlreadyImported
                ? AppColors.surfaceVariant
                : hasBirthday
                    ? AppColors.primaryLight
                    : AppColors.surfaceVariant,
            child: Text(
              initial,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isAlreadyImported
                    ? AppColors.textTertiary
                    : hasBirthday
                        ? AppColors.primary
                        : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isAlreadyImported
              ? AppColors.textTertiary
              : AppColors.textPrimary,
        ),
      ),
      subtitle: hasBirthday
          ? Text(
              '${birthday!.month}월 ${birthday!.day}일',
              style: TextStyle(
                fontSize: 13,
                color: isAlreadyImported
                    ? AppColors.textTertiary
                    : AppColors.textSecondary,
              ),
            )
          : GestureDetector(
              onTap: onSetBirthday,
              child: const Text(
                '생일을 입력해주세요',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),
            ),
      trailing: isAlreadyImported
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '추가됨',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
            )
          : !hasBirthday
              ? GestureDetector(
                  onTap: onSetBirthday,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '생일 입력',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                )
              : null,
      onTap: isAlreadyImported
          ? null
          : hasBirthday
              ? () => onChanged?.call(!isSelected)
              : onSetBirthday,
    );
  }
}
