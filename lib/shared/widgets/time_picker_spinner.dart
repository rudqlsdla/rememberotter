import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';

class TimePickerSpinner extends StatefulWidget {
  final double? height;
  final double? width;
  final TimeOfDay time;
  final Function(TimeOfDay) onChanged;

  const TimePickerSpinner({
    super.key,
    this.height,
    this.width,
    required this.time,
    required this.onChanged,
  });

  @override
  State<TimePickerSpinner> createState() => _TimePickerSpinnerState();
}

class _TimePickerSpinnerState extends State<TimePickerSpinner> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late double _width;
  late double _height;
  late int _selectedHour;
  late int _selectedMinute;

  // 시간 목록 (0-23)
  final List<String> _hours = List.generate(24, (i) => i.toString().padLeft(2, '0'));
  // 분 목록 (0-59)
  final List<String> _minutes = List.generate(60, (i) => i.toString().padLeft(2, '0'));

  @override
  void initState() {
    super.initState();
    _width = widget.width ?? 200;
    _height = widget.height ?? 120;

    _selectedHour = widget.time.hour;
    _selectedMinute = widget.time.minute;

    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _onTimeChanged() {
    widget.onChanged(TimeOfDay(hour: _selectedHour, minute: _selectedMinute));
  }

  String _formatHourLabel(int hour) {
    if (hour == 0) return '오전 12';
    if (hour < 12) return '오전 $hour';
    if (hour == 12) return '오후 12';
    return '오후 ${hour - 12}시';
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
          child: Row(
            children: [
              // 시간
              Expanded(
                flex: 2,
                child: ListWheelScrollView(
                  controller: _hourController,
                  onSelectedItemChanged: (int i) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _selectedHour = i;
                    });
                    _onTimeChanged();
                  },
                  squeeze: 0.7,
                  perspective: 0.00001,
                  physics: const FixedExtentScrollPhysics(),
                  itemExtent: 30,
                  children: List.generate(
                    _hours.length,
                    (index) => Center(
                      child: Text(
                        _formatHourLabel(index),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: index == _selectedHour
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 분
              Expanded(
                child: ListWheelScrollView(
                  controller: _minuteController,
                  onSelectedItemChanged: (int i) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _selectedMinute = i;
                    });
                    _onTimeChanged();
                  },
                  squeeze: 0.7,
                  perspective: 0.00001,
                  physics: const FixedExtentScrollPhysics(),
                  itemExtent: 30,
                  children: List.generate(
                    _minutes.length,
                    (index) => Center(
                      child: Text(
                        '${_minutes[index]}분',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: index == _selectedMinute
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                        ),
                      ),
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
