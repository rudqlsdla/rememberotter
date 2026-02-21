class PriceFormatter {
  /// 숫자를 콤마 포맷으로 변환 (50000 → "50,000")
  static String format(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  /// 숫자를 콤마 포맷 + 원 단위로 변환 (50000 → "50,000원")
  static String formatWithUnit(int price) {
    return '${format(price)}원';
  }
}
