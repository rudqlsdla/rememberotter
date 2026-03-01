import 'package:rememberotter/domain/repositories/birthday_repository.dart';
import 'package:rememberotter/domain/repositories/gift_repository.dart';
import 'package:rememberotter/shared/log/logger.dart';

/// 테스트용 더미 데이터 시드 (개발 중에만 사용)
Future<void> seedDummyData() async {
  final birthdayRepo = BirthdayRepository();
  final giftRepo = GiftRepository();

  // 이미 데이터가 있으면 스킵
  final existing = await birthdayRepo.getAll();
  if (existing.isNotEmpty) return;

  logger.i('더미 데이터 시드 시작');

  // groupId: 'family', 'friends', 'work', 'etc', null(미분류)
  final people = [
    ('귀여운해달', DateTime(2001, 5, 7), '눈이 동그란 막내', 'family' as String?),
    ('다정한해달', DateTime(1998, 3, 15), '항상 따뜻한 말 한마디', 'friends'),
    ('반짝이는해달', DateTime(2000, 11, 22), '눈이 별처럼 빛나는', 'friends'),
    ('똑똑한해달', DateTime(1995, 1, 3), '회의 때 빛나는 해달', 'work'),
    ('웃긴해달', DateTime(1999, 8, 30), '개그 본능 장착', 'friends'),
    ('배고픈해달', DateTime(1997, 12, 25), '항상 간식 찾는 해달', 'friends'),
    ('씩씩한해달', DateTime(2002, 7, 14), '무서운 거 없는 해달', 'friends'),
    ('졸린해달', DateTime(1996, 4, 1), '배 위에서 낮잠 중', 'etc'),
    ('수줍은해달', DateTime(2000, 2, 28), '볼이 빨개지는 해달', 'friends'),
    ('든든한해달', DateTime(1994, 10, 10), '우리 가족 기둥', 'family'),
    ('깜찍한해달', DateTime(2003, 6, 21), '손 잡고 잠드는 해달', 'family'),
    ('활발한해달', DateTime(1993, 9, 5), '바다에서 제일 빠른', 'etc'),
    ('부지런한해달', DateTime(2001, 3, 8), '아침형 해달', 'work'),
    ('자유로운해달', DateTime(1998, 12, 12), '바람 따라 떠나는 해달', null as String?),
    ('조용한해달', DateTime(2000, 1, 20), '책 읽는 걸 좋아해', 'friends'),
    ('예쁜해달', DateTime(1997, 7, 7), '돌 고르는 센스가 남달라', 'friends'),
    ('신나는해달', DateTime(1999, 5, 25), '파도 타기 챔피언', null),
    ('꼼꼼한해달', DateTime(1996, 11, 11), '조개 정리의 달인', 'work'),
    ('몽글몽글해달', DateTime(2002, 4, 16), '구름 같은 털을 가진', null),
    ('포근한해달', DateTime(1995, 8, 15), '안기면 잠이 오는 해달', 'family'),
  ];

  for (final (name, birthDate, memo, groupId) in people) {
    await birthdayRepo.add(
      name: name,
      birthDate: birthDate,
      memo: memo,
      groupId: groupId,
    );
  }

  // 일부 생일에 선물 기록 추가
  final allBirthdays = await birthdayRepo.getAll();

  // 사랑해달 - 2024, 2025 선물 기록
  await giftRepo.add(
    birthdayId: allBirthdays[0].id,
    year: 2024,
    given: true,
    received: true,
    givenGiftName: '조개 목걸이',
    givenGiftPrice: 85000,
    receivedGiftName: '반짝이 돌멩이',
    receivedGiftPrice: 120000,
  );
  await giftRepo.add(
    birthdayId: allBirthdays[0].id,
    year: 2025,
    given: true,
    givenGiftName: '미역 케이크',
    givenGiftPrice: 45000,
  );

  // 웃겨해달 - 2025 선물
  await giftRepo.add(
    birthdayId: allBirthdays[4].id,
    year: 2025,
    given: true,
    received: true,
    givenGiftName: '성게 인형',
    givenGiftPrice: 35000,
    receivedGiftName: '전복 쿠키',
    receivedGiftPrice: 28000,
    memo: '같이 바다 놀러감',
  );

  // 응원해달 - 가격만 있는 케이스
  await giftRepo.add(
    birthdayId: allBirthdays[1].id,
    year: 2025,
    given: true,
    givenGiftPrice: 50000,
  );

  // 도와해달 - 이름만 있는 케이스
  await giftRepo.add(
    birthdayId: allBirthdays[3].id,
    year: 2024,
    given: true,
    received: true,
    givenGiftName: '다시마 세트',
    receivedGiftName: '해초 비누',
  );

  // 먹어해달 - 받기만 한 케이스
  await giftRepo.add(
    birthdayId: allBirthdays[5].id,
    year: 2025,
    received: true,
    receivedGiftName: '연어 세트',
    receivedGiftPrice: 68000,
  );

  // 지켜해달 - 여러 해 기록
  await giftRepo.add(
    birthdayId: allBirthdays[9].id,
    year: 2023,
    given: true,
    givenGiftName: '방수 시계',
    givenGiftPrice: 150000,
  );
  await giftRepo.add(
    birthdayId: allBirthdays[9].id,
    year: 2024,
    given: true,
    received: true,
    givenGiftName: '잠수 고글',
    givenGiftPrice: 95000,
    receivedGiftName: '돌 컬렉션',
    receivedGiftPrice: 200000,
  );
  await giftRepo.add(
    birthdayId: allBirthdays[9].id,
    year: 2025,
    given: true,
    givenGiftName: '해달 쿠션',
    givenGiftPrice: 38000,
  );

  logger.i('더미 데이터 시드 완료: ${allBirthdays.length}명, 선물 기록 8건');
}
