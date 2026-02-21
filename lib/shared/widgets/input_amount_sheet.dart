import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/shared/utils/price_formatter.dart';

class InputAmountSheet extends StatefulWidget {
  final int initialAmount;
  final String title;

  const InputAmountSheet({
    super.key,
    this.initialAmount = 0,
    this.title = '금액 입력',
  });

  /// 바텀시트를 열고 입력된 금액을 반환 (null이면 취소)
  static Future<int?> show(
    BuildContext context, {
    int initialAmount = 0,
    String title = '금액 입력',
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => InputAmountSheet(
        initialAmount: initialAmount,
        title: title,
      ),
    );
  }

  @override
  State<InputAmountSheet> createState() => _InputAmountSheetState();
}

class _InputAmountSheetState extends State<InputAmountSheet> {
  static const int _maxAmount = 1000000000; // 10억
  late int _amount;

  @override
  void initState() {
    super.initState();
    _amount = widget.initialAmount;
  }

  void _appendDigit(String digit) {
    HapticFeedback.lightImpact();
    final newStr = '$_amount$digit';
    final newAmount = int.tryParse(newStr) ?? 0;
    if (newAmount <= _maxAmount) {
      setState(() => _amount = newAmount);
    }
  }

  void _backspace() {
    HapticFeedback.lightImpact();
    final str = _amount.toString();
    if (str.length <= 1) {
      setState(() => _amount = 0);
    } else {
      setState(() => _amount = int.parse(str.substring(0, str.length - 1)));
    }
  }

  void _clear() {
    HapticFeedback.lightImpact();
    setState(() => _amount = 0);
  }

  void _addQuickAmount(int value) {
    HapticFeedback.lightImpact();
    final newAmount = _amount + value;
    if (newAmount <= _maxAmount) {
      setState(() => _amount = newAmount);
    }
  }

  void _confirm() {
    Navigator.pop(context, _amount);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 금액 표시
          _buildAmountDisplay(),
          const SizedBox(height: 16),

          // 빠른 금액 버튼
          _buildQuickAmountButtons(),
          const SizedBox(height: 16),

          // 숫자 패드
          _buildNumberPad(),
          const SizedBox(height: 16),

          // 확인 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildAmountDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _amount > 0 ? '${PriceFormatter.format(_amount)}원' : '0원',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _amount > 0
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            if (_amount > 0) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _clear,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountButtons() {
    const quickAmounts = [
      (10000, '+1만'),
      (50000, '+5만'),
      (100000, '+10만'),
      (1000000, '+100만'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: quickAmounts.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: OutlinedButton(
                onPressed: () => _addQuickAmount(entry.$1),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  entry.$2,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNumberPad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['00', '0', '⌫'],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: keys.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: row.map((key) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildKey(key),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKey(String key) {
    final isBackspace = key == '⌫';

    return Material(
      color: AppColors.surfaceVariant,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (isBackspace) {
            _backspace();
          } else {
            _appendDigit(key);
          }
        },
        onLongPress: isBackspace ? _clear : null,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: isBackspace
              ? const Icon(
                  Icons.backspace_outlined,
                  color: AppColors.textPrimary,
                  size: 22,
                )
              : Text(
                  key,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
        ),
      ),
    );
  }
}
