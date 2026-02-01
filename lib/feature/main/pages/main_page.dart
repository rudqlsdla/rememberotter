import 'package:flutter/material.dart';
import 'package:memocal/design_system/variable/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    _CalendarPage(),
    _FriendsPage(),
    _SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('기억해달'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '친구',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}

// 캘린더 탭 페이지
class _CalendarPage extends StatefulWidget {
  @override
  State<_CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<_CalendarPage> {
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

                    return _MonthCalendarWidget(
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
                    );
                  },
                  childCount: _monthRange, // 과거 5년으로 제한
                ),
              ),
              // 현재 달 (center key로 지정)
              SliverToBoxAdapter(
                key: _centerKey,
                child: _MonthCalendarWidget(
                  month: _getMonthFromOffset(0),
                  days: _getDaysInMonth(_getMonthFromOffset(0)),
                  weeksCount: _getDaysInMonth(_getMonthFromOffset(0)).length ~/ 7,
                  selectedDay: _selectedDay,
                  onDaySelected: (day) {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                  isSameDay: _isSameDay,
                  isToday: _isToday,
                ),
              ),
              // 미래 달들 (아래로 스크롤) - 5년 제한
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // index 0 = 1달 후, index 1 = 2달 후, ...
                    final month = _getMonthFromOffset(index + 1);
                    final days = _getDaysInMonth(month);

                    return _MonthCalendarWidget(
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

// 개별 월 캘린더 위젯
class _MonthCalendarWidget extends StatelessWidget {
  final DateTime month;
  final List<DateTime> days;
  final int weeksCount;
  final DateTime? selectedDay;
  final Function(DateTime) onDaySelected;
  final bool Function(DateTime?, DateTime?) isSameDay;
  final bool Function(DateTime) isToday;

  const _MonthCalendarWidget({
    required this.month,
    required this.days,
    required this.weeksCount,
    required this.selectedDay,
    required this.onDaySelected,
    required this.isSameDay,
    required this.isToday,
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
                  child: Center(
                    child: Text(
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

// 친구 목록 탭 페이지
class _FriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 80, color: Colors.blue),
          const SizedBox(height: 20),
          Text(
            '친구 목록',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('친구를 추가하고 관리하세요'),
        ],
      ),
    );
  }
}

// 설정 탭 페이지
class _SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            '설정',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('앱 설정을 관리하세요'),
        ],
      ),
    );
  }
}