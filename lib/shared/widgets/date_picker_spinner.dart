import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';

class DatePickerSpinner extends StatefulWidget {
  final double? height;
  final double? width;
  final DateTime date;
  final Function(DateTime) onChanged;

  const DatePickerSpinner({
    super.key,
    this.height,
    this.width,
    required this.date,
    required this.onChanged,
  });

  @override
  State<DatePickerSpinner> createState() => _DatePickerSpinnerState();
}

class _DatePickerSpinnerState extends State<DatePickerSpinner> {
  late FixedExtentScrollController _yearController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;
  List<String> _year = [];
  List<String> _month = [];
  List<String> _day = [];
  late double _width;
  late double _height;
  late Size _itemSize;
  late ValueNotifier<String> currentDate;

  static const int _startYear = 1900;

  @override
  void initState() {
    super.initState();
    currentDate = ValueNotifier(
      widget.date.toString().replaceAll("-", "").substring(0, 8),
    );
    _width = widget.width ?? 300;
    _height = widget.height ?? 120;
    _itemSize = Size(_width / 3, _height);

    // 1900년부터 현재 년도까지
    int currentYear = DateTime.now().year;
    _year = List.generate(
      currentYear - _startYear + 1,
      (index) => "${_startYear + index}",
    );

    _updateMonthList();
    _updateDayList(initial: true);

    int initialYear = _year.indexOf(currentDate.value.substring(0, 4));
    int initialMonth = _month.indexOf(currentDate.value.substring(4, 6));
    int initialDay = _day.indexOf(currentDate.value.substring(6, 8));

    // 범위를 벗어난 경우 보정
    if (initialYear < 0) initialYear = _year.length - 1;
    if (initialMonth < 0) initialMonth = _month.length - 1;
    if (initialDay < 0) initialDay = _day.length - 1;

    _yearController = FixedExtentScrollController(initialItem: initialYear);
    _monthController = FixedExtentScrollController(initialItem: initialMonth);
    _dayController = FixedExtentScrollController(initialItem: initialDay);
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    currentDate.dispose();
    super.dispose();
  }

  void _updateMonthList() {
    int selectedYear = int.parse(currentDate.value.substring(0, 4));
    int now = DateTime.now().year;
    int currentMonth = DateTime.now().month;

    // 현재 년도면 현재 월까지만, 아니면 12월까지
    int maxMonth = selectedYear == now ? currentMonth : 12;
    _month = List.generate(
      maxMonth,
      (index) => index < 9 ? "0${index + 1}" : "${index + 1}",
    );
  }

  void _updateDayList({bool initial = false}) {
    int selectedYear = int.parse(currentDate.value.substring(0, 4));
    int selectedMonth = int.parse(currentDate.value.substring(4, 6));
    int now = DateTime.now().year;
    int currentMonth = DateTime.now().month;
    int currentDay = DateTime.now().day;

    // 해당 월의 마지막 날 계산
    int lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;

    // 현재 년월이면 오늘까지만
    int maxDay = (selectedYear == now && selectedMonth == currentMonth)
        ? currentDay
        : lastDayOfMonth;

    _day = List.generate(
      maxDay,
      (index) => index < 9 ? "0${index + 1}" : "${index + 1}",
    );

    // 선택된 일이 범위를 벗어나면 조정
    if (!initial && _dayController.hasClients) {
      int selectedDayItem = _dayController.selectedItem;
      if (selectedDayItem >= _day.length) {
        _dayController.jumpToItem(_day.length - 1);
      }
    }
  }

  void _changedDate(int dateType, int index) {
    String currentYear = currentDate.value.substring(0, 4);
    String currentMonth = currentDate.value.substring(4, 6);
    String currentDay = currentDate.value.substring(6, 8);

    switch (dateType) {
      case 0: // 년 변경
        currentDate.value = _year[index] + currentMonth + currentDay;
        _updateMonthList();
        // 월이 범위를 벗어나면 조정
        int monthIndex = _month.indexOf(currentMonth);
        if (monthIndex < 0) {
          _monthController.jumpToItem(_month.length - 1);
          currentDate.value = _year[index] + _month.last + currentDay;
        }
        _updateDayList();
        break;
      case 1: // 월 변경
        currentDate.value = currentYear + _month[index] + currentDay;
        _updateDayList();
        break;
      case 2: // 일 변경
        currentDate.value = currentYear + currentMonth + _day[index];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: currentDate,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
            SizedBox(
              height: _height,
              width: _width,
              child: Row(
                children: [
                  _pickerForm(
                    label: '년',
                    controller: _yearController,
                    date: _year,
                    dateIndex: 0,
                    current: value.substring(0, 4),
                  ),
                  _pickerForm(
                    label: '월',
                    controller: _monthController,
                    date: _month,
                    dateIndex: 1,
                    current: value.substring(4, 6),
                  ),
                  _pickerForm(
                    label: '일',
                    controller: _dayController,
                    date: _day,
                    dateIndex: 2,
                    current: value.substring(6, 8),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Expanded _pickerForm({
    required String label,
    required List<String> date,
    required int dateIndex,
    required String current,
    required FixedExtentScrollController controller,
  }) {
    return Expanded(
      child: ListWheelScrollView(
        controller: controller,
        onSelectedItemChanged: (int i) {
          HapticFeedback.lightImpact();
          _changedDate(dateIndex, i);
          final year = int.parse(currentDate.value.substring(0, 4));
          final month = int.parse(currentDate.value.substring(4, 6));
          final day = int.parse(currentDate.value.substring(6, 8));
          widget.onChanged(DateTime(year, month, day));
        },
        squeeze: 0.7,
        perspective: 0.00001,
        physics: const FixedExtentScrollPhysics(),
        itemExtent: 30,
        children: List.generate(
          date.length,
          (index) => Center(
            child: Text(
              '${date[index]}$label',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: date[index] == current
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
