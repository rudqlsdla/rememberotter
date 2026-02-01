import 'package:flutter/material.dart';
import 'package:memocal/design_system/variable/app_colors.dart';

class MonthCalendarWidget extends StatelessWidget {
  final DateTime month;
  final List<DateTime> days;
  final int weeksCount;
  final DateTime? selectedDay;
  final Function(DateTime) onDaySelected;
  final bool Function(DateTime?, DateTime?) isSameDay;
  final bool Function(DateTime) isToday;
  final bool Function(DateTime)? hasBirthday;

  const MonthCalendarWidget({
    super.key,
    required this.month,
    required this.days,
    required this.weeksCount,
    required this.selectedDay,
    required this.onDaySelected,
    required this.isSameDay,
    required this.isToday,
    this.hasBirthday,
  });

  bool _isCurrentMonth(DateTime day) {
    return day.month == month.month && day.year == month.year;
  }

  @override
  Widget build(BuildContext context) {
    // 년도 표시: 2025 -> 25
    final yearLabel = '${month.year % 100}년 ${month.month}월';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 년월 라벨
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
          // 날짜 그리드
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isTodayDate = isToday(day);
              final isSelected = isSameDay(day, selectedDay);
              final isCurrentMonthDay = _isCurrentMonth(day);
              final weekday = day.weekday;
              final hasBirthdayOnDay = hasBirthday?.call(day) ?? false;

              return GestureDetector(
                onTap: () => onDaySelected(day),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isTodayDate
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isTodayDate || isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : !isCurrentMonthDay
                                  ? AppColors.calendarDisabled
                                  : weekday == 7
                                      ? AppColors.calendarWeekend
                                      : weekday == 6
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                        ),
                      ),
                      // 생일 마커
                      if (hasBirthdayOnDay && isCurrentMonthDay)
                        Positioned(
                          bottom: 6,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
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
