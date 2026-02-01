import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';

class YearPickerSpinner extends StatefulWidget {
  final double? height;
  final double? width;
  final int year;
  final Function(int) onChanged;

  const YearPickerSpinner({
    super.key,
    this.height,
    this.width,
    required this.year,
    required this.onChanged,
  });

  @override
  State<YearPickerSpinner> createState() => _YearPickerSpinnerState();
}

class _YearPickerSpinnerState extends State<YearPickerSpinner> {
  late FixedExtentScrollController _yearController;
  late List<int> _years;
  late double _width;
  late double _height;
  late int _currentYear;

  static const int _yearsToShow = 20;

  @override
  void initState() {
    super.initState();
    _width = widget.width ?? 150;
    _height = widget.height ?? 120;
    _currentYear = widget.year;

    // 현재 연도부터 과거 20년
    int nowYear = DateTime.now().year;
    _years = List.generate(_yearsToShow, (index) => nowYear - index);

    int initialIndex = _years.indexOf(_currentYear);
    if (initialIndex < 0) initialIndex = 0;

    _yearController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: ListWheelScrollView(
            controller: _yearController,
            onSelectedItemChanged: (int i) {
              HapticFeedback.lightImpact();
              setState(() {
                _currentYear = _years[i];
              });
              widget.onChanged(_years[i]);
            },
            squeeze: 0.7,
            perspective: 0.00001,
            physics: const FixedExtentScrollPhysics(),
            itemExtent: 30,
            children: List.generate(
              _years.length,
              (index) => Center(
                child: Text(
                  '${_years[index]}년',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _years[index] == _currentYear
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
