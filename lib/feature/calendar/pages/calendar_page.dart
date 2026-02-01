import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memocal/design_system/variable/app_colors.dart';
import 'package:memocal/feature/birthday/controllers/birthday_controller.dart';
import 'package:memocal/feature/calendar/widgets/month_calendar_widget.dart';

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

  List<DateTime> _getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    final daysInMonth = lastDay.day;

    // 시작 요일 (일요일: 0, 월요일: 1, ...)
    final startWeekday = firstDay.weekday % 7;

    List<DateTime> days = [];

    // 이전 달의 날짜들로 채우기
    for (int i = startWeekday - 1; i >= 0; i--) {
      days.add(firstDay.subtract(Duration(days: i + 1)));
    }

    // 현재 달의 날짜들
    for (int i = 0; i < daysInMonth; i++) {
      days.add(DateTime(date.year, date.month, i + 1));
    }

    // 다음 달의 날짜들로 채우기 (6주가 되도록)
    final totalCells = ((days.length / 7).ceil()) * 7;
    final remaining = totalCells - days.length;
    for (int i = 0; i < remaining; i++) {
      days.add(lastDay.add(Duration(days: i + 1)));
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

  bool _hasBirthday(DateTime date) {
    final controller = Get.find<BirthdayController>();
    return controller.hasBirthdayOnDate(date);
  }

  @override
  Widget build(BuildContext context) {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];

    return Column(
      children: [
        // 요일 헤더 (고정)
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: weekdays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 14,
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
                          onDaySelected: (day) {
                            setState(() {
                              _selectedDay = day;
                            });
                          },
                          isSameDay: _isSameDay,
                          isToday: _isToday,
                          hasBirthday: _hasBirthday,
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
                      onDaySelected: (day) {
                        setState(() {
                          _selectedDay = day;
                        });
                      },
                      isSameDay: _isSameDay,
                      isToday: _isToday,
                      hasBirthday: _hasBirthday,
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
                          onDaySelected: (day) {
                            setState(() {
                              _selectedDay = day;
                            });
                          },
                          isSameDay: _isSameDay,
                          isToday: _isToday,
                          hasBirthday: _hasBirthday,
                        );
                      },
                      childCount: _monthRange, // 미래 5년으로 제한
                    ),
                  ),
                ],
              ),
              // 오늘 버튼
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton.small(
                  onPressed: _scrollToToday,
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.today, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
