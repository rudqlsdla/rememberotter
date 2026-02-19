import 'package:flutter/material.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';

class MonthCalendarWidget extends StatelessWidget {
  final DateTime month;
  final List<DateTime?> days;
  final int weeksCount;
  final DateTime? selectedDay;
  final Function(DateTime) onDaySelected;
  final bool Function(DateTime?, DateTime?) isSameDay;
  final bool Function(DateTime) isToday;
  final List<String> Function(DateTime)? getBirthdayNames;

  const MonthCalendarWidget({
    super.key,
    required this.month,
    required this.days,
    required this.weeksCount,
    required this.selectedDay,
    required this.onDaySelected,
    required this.isSameDay,
    required this.isToday,
    this.getBirthdayNames,
  });

  @override
  Widget build(BuildContext context) {
    final yearLabel = '${month.year % 100}년 ${month.month}월';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              yearLabel,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.75,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              if (day == null) return const SizedBox.shrink();

              final isTodayDate = isToday(day);
              final isSelected = isSameDay(day, selectedDay);
              final weekday = day.weekday;
              final names = getBirthdayNames?.call(day) ?? [];

              final dayColor = isSelected
                  ? Colors.white
                  : weekday == 7
                      ? AppColors.calendarWeekend
                      : weekday == 6
                          ? AppColors.primary
                          : AppColors.textPrimary;

              return GestureDetector(
                onTap: () => onDaySelected(day),
                child: Container(
                  margin: const EdgeInsets.all(1),
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isTodayDate
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      // 날짜 숫자
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isTodayDate || isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: dayColor,
                        ),
                      ),
                      // 생일 이름 표시
                      if (names.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        // 첫 번째 이름
                        Flexible(
                          child: Text(
                            names.first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.accent,
                            ),
                          ),
                        ),
                        // 두 번째 이름 or +N
                        if (names.length == 2)
                          Flexible(
                            child: Text(
                              names[1],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.accent,
                              ),
                            ),
                          )
                        else if (names.length > 2)
                          Flexible(
                            child: Text(
                              '+${names.length - 1}',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white70
                                    : AppColors.op(AppColors.accent, 0.7),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
