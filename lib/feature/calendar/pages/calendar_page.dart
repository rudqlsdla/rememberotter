import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/birthday/controllers/birthday_controller.dart';
import 'package:rememberotter/feature/calendar/widgets/date_birthday_sheet.dart';
import 'package:rememberotter/shared/services/analytics_service.dart';
import 'package:rememberotter/feature/calendar/widgets/month_calendar_widget.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;

  // CustomScrollView의 center key (현재 달 기준점)
  final GlobalKey _centerKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  // 범위 제한: 과거/미래 각 5년 (60개월)
  static const int _monthRange = 60;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();

    // 생일 데이터 변경 시 캘린더 갱신
    final controller = Get.find<BirthdayController>();
    ever(controller.birthdays, (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 현재 달 기준으로 offset 계산 (양수: 미래, 음수: 과거)
  DateTime _getMonthFromOffset(int offset) {
    final now = DateTime.now();
    return DateTime(now.year, now.month + offset, 1);
  }

  List<DateTime?> _getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    final daysInMonth = lastDay.day;

    // 시작 요일 (일요일: 0, 월요일: 1, ...)
    final startWeekday = firstDay.weekday % 7;

    List<DateTime?> days = [];

    // 이전 달 자리는 빈 칸
    for (int i = 0; i < startWeekday; i++) {
      days.add(null);
    }

    // 현재 달의 날짜들
    for (int i = 0; i < daysInMonth; i++) {
      days.add(DateTime(date.year, date.month, i + 1));
    }

    // 마지막 주 남은 칸은 빈 칸
    final totalCells = ((days.length / 7).ceil()) * 7;
    final remaining = totalCells - days.length;
    for (int i = 0; i < remaining; i++) {
      days.add(null);
    }

    return days;
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return _isSameDay(day, now);
  }

  void _scrollToToday() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onDaySelected(DateTime day) {
    HapticFeedback.selectionClick();
    AnalyticsService().logCalendarDateSelect();
    setState(() {
      _selectedDay = day;
    });
    DateBirthdaySheet.show(day);
  }

  List<String> _getBirthdayNames(DateTime date) {
    final controller = Get.find<BirthdayController>();
    return controller
        .getBirthdaysOnDate(date)
        .map((b) => b.name)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];

    return Column(
      children: [
        // 요일 헤더 (고정)
        Container(
          color: AppColors.background,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
          child: Row(
            children: weekdays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: day == '일'
                          ? AppColors.calendarWeekend
                          : day == '토'
                              ? AppColors.primary
                              : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 1),
        // 세로 스크롤 캘린더 (CustomScrollView로 양방향 스크롤)
        Expanded(
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                center: _centerKey,
                slivers: [
                  // 과거 달들 (위로 스크롤) - 5년 제한
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // index 0 = 1달 전, index 1 = 2달 전, ...
                        final month = _getMonthFromOffset(-(index + 1));
                        final days = _getDaysInMonth(month);

                        return MonthCalendarWidget(
                          month: month,
                          days: days,
                          weeksCount: days.length ~/ 7,
                          selectedDay: _selectedDay,
                          onDaySelected: (day) => _onDaySelected(day),
                          isSameDay: _isSameDay,
                          isToday: _isToday,
                          getBirthdayNames: _getBirthdayNames,
                        );
                      },
                      childCount: _monthRange, // 과거 5년으로 제한
                    ),
                  ),
                  // 현재 달 (center key로 지정)
                  SliverToBoxAdapter(
                    key: _centerKey,
                    child: MonthCalendarWidget(
                      month: _getMonthFromOffset(0),
                      days: _getDaysInMonth(_getMonthFromOffset(0)),
                      weeksCount:
                          _getDaysInMonth(_getMonthFromOffset(0)).length ~/ 7,
                      selectedDay: _selectedDay,
                      onDaySelected: (day) => _onDaySelected(day),
                      isSameDay: _isSameDay,
                      isToday: _isToday,
                      getBirthdayNames: _getBirthdayNames,
                    ),
                  ),
                  // 미래 달들 (아래로 스크롤) - 5년 제한
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // index 0 = 1달 후, index 1 = 2달 후, ...
                        final month = _getMonthFromOffset(index + 1);
                        final days = _getDaysInMonth(month);

                        return MonthCalendarWidget(
                          month: month,
                          days: days,
                          weeksCount: days.length ~/ 7,
                          selectedDay: _selectedDay,
                          onDaySelected: (day) => _onDaySelected(day),
                          isSameDay: _isSameDay,
                          isToday: _isToday,
                          getBirthdayNames: _getBirthdayNames,
                        );
                      },
                      childCount: _monthRange, // 미래 5년으로 제한
                    ),
                  ),
                ],
              ),
              // 오늘 버튼 (FAB 위에 위치)
              Positioned(
                right: 16,
                bottom: 76,
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.primary,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _scrollToToday();
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(child: Text('오늘', style: TextStyle(color: Colors.white))),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
