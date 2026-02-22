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
    ('김민지', DateTime(2001, 5, 7), '고등학교 동창', 'friends' as String?),
    ('이서준', DateTime(1998, 3, 15), '대학 선배', 'friends'),
    ('박지영', DateTime(2000, 11, 22), null as String?, null as String?),
    ('정우진', DateTime(1995, 1, 3), '회사 동료', 'work'),
    ('최수아', DateTime(1999, 8, 30), '절친', 'friends'),
    ('강도현', DateTime(1997, 12, 25), '크리스마스 아기', 'friends'),
    ('윤서연', DateTime(2002, 7, 14), '동생 친구', 'friends'),
    ('임재혁', DateTime(1996, 4, 1), '만우절 생일', 'etc'),
    ('한소희', DateTime(2000, 2, 28), '동아리 후배', 'friends'),
    ('오승우', DateTime(1994, 10, 10), '형', 'family'),
    ('신예진', DateTime(2003, 6, 21), '사촌 동생', 'family'),
    ('황민호', DateTime(1993, 9, 5), '아버지 지인 아들', 'etc'),
    ('조유나', DateTime(2001, 3, 8), '회사 동기', 'work'),
    ('배준서', DateTime(1998, 12, 12), null, null),
    ('류하은', DateTime(2000, 1, 20), '중학교 동창', 'friends'),
    ('문지훈', DateTime(1997, 7, 7), '럭키세븐', 'friends'),
    ('송다은', DateTime(1999, 5, 25), '소개팅으로 만남', null),
    ('권현우', DateTime(1996, 11, 11), '빼빼로데이 생일', 'work'),
    ('장서윤', DateTime(2002, 4, 16), null, null),
    ('고태양', DateTime(1995, 8, 15), '광복절 아기', 'family'),
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

  // 김민지 - 2024, 2025 선물 기록
  await giftRepo.add(
    birthdayId: allBirthdays[0].id,
    year: 2024,
    given: true,
    received: true,
    givenGiftName: '향수',
    givenGiftPrice: 85000,
    receivedGiftName: '지갑',
    receivedGiftPrice: 120000,
  );
  await giftRepo.add(
    birthdayId: allBirthdays[0].id,
    year: 2025,
    given: true,
    givenGiftName: '에어팟',
    givenGiftPrice: 250000,
  );

  // 최수아 - 2025 선물
  await giftRepo.add(
    birthdayId: allBirthdays[4].id,
    year: 2025,
    given: true,
    received: true,
    givenGiftName: '케이크',
    givenGiftPrice: 35000,
    receivedGiftName: '립스틱',
    receivedGiftPrice: 45000,
    memo: '같이 밥도 먹음',
  );

  // 이서준 - 가격만 있는 케이스
  await giftRepo.add(
    birthdayId: allBirthdays[1].id,
    year: 2025,
    given: true,
    givenGiftPrice: 50000,
  );

  // 정우진 - 이름만 있는 케이스
  await giftRepo.add(
    birthdayId: allBirthdays[3].id,
    year: 2024,
    given: true,
    received: true,
    givenGiftName: '넥타이',
    receivedGiftName: '커피 기프티콘',
  );

  // 강도현 - 받기만 한 케이스
  await giftRepo.add(
    birthdayId: allBirthdays[5].id,
    year: 2025,
    received: true,
    receivedGiftName: '머플러',
    receivedGiftPrice: 68000,
  );

  // 오승우 - 여러 해 기록
  await giftRepo.add(
    birthdayId: allBirthdays[9].id,
    year: 2023,
    given: true,
    givenGiftName: '운동화',
    givenGiftPrice: 150000,
  );
  await giftRepo.add(
    birthdayId: allBirthdays[9].id,
    year: 2024,
    given: true,
    received: true,
    givenGiftName: '시계',
    givenGiftPrice: 300000,
    receivedGiftName: '가방',
    receivedGiftPrice: 200000,
  );
  await giftRepo.add(
    birthdayId: allBirthdays[9].id,
    year: 2025,
    given: true,
    givenGiftName: '골프공',
    givenGiftPrice: 80000,
  );

  logger.i('더미 데이터 시드 완료: ${allBirthdays.length}명, 선물 기록 8건');
}
