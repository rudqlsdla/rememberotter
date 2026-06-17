import 'package:flutter_test/flutter_test.dart';
import 'package:rememberotter/domain/models/birthday.dart';

void main() {
  Birthday make({String? phoneNumber}) => Birthday(
        id: '1',
        name: 'A',
        birthDate: DateTime(2000, 1, 1),
        phoneNumber: phoneNumber,
        createdAt: DateTime(2020),
        updatedAt: DateTime(2020),
      );

  group('Birthday.phoneNumber', () {
    test('생성자로 전화번호를 보관한다', () {
      expect(make(phoneNumber: '010-1234-5678').phoneNumber, '010-1234-5678');
    });

    test('기본값은 null', () {
      expect(make().phoneNumber, isNull);
    });

    test('copyWith로 전화번호를 변경한다', () {
      final b = make(phoneNumber: '010').copyWith(phoneNumber: () => '999');
      expect(b.phoneNumber, '999');
    });

    test('copyWith로 전화번호를 null로 지운다', () {
      final b = make(phoneNumber: '010').copyWith(phoneNumber: () => null);
      expect(b.phoneNumber, isNull);
    });

    test('copyWith에 phoneNumber 미지정 시 기존값 유지', () {
      final b = make(phoneNumber: '010').copyWith(name: 'B');
      expect(b.phoneNumber, '010');
    });
  });
}
