import 'package:get/get.dart';
import 'package:rememberotter/domain/models/gift.dart';
import 'package:rememberotter/domain/repositories/gift_repository.dart';

class GiftController extends GetxController {
  final GiftRepository _repository = GiftRepository();

  final RxList<Gift> gifts = <Gift>[].obs;
  final RxMap<String, List<Gift>> giftsByBirthdayId = <String, List<Gift>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadGifts();
  }

  /// 모든 선물 기록 로드
  void loadGifts() {
    gifts.value = _repository.getAll();
  }

  /// Birthday ID로 선물 기록 조회
  List<Gift> getGiftsByBirthdayId(String birthdayId) {
    return _repository.getByBirthdayId(birthdayId);
  }

  /// Birthday ID와 연도로 선물 기록 조회
  Gift? getGiftByBirthdayIdAndYear(String birthdayId, int year) {
    return _repository.getByBirthdayIdAndYear(birthdayId, year);
  }

  /// 선물 기록 추가
  Future<void> addGift({
    required String birthdayId,
    required int year,
    bool given = false,
    bool received = false,
    String? givenGiftName,
    String? receivedGiftName,
    String? memo,
  }) async {
    await _repository.add(
      birthdayId: birthdayId,
      year: year,
      given: given,
      received: received,
      givenGiftName: givenGiftName,
      receivedGiftName: receivedGiftName,
      memo: memo,
    );
    loadGifts();
  }

  /// 선물 기록 수정
  Future<void> updateGift(Gift gift) async {
    await _repository.update(gift);
    loadGifts();
  }

  /// 선물 기록 삭제
  Future<void> deleteGift(String id) async {
    await _repository.delete(id);
    loadGifts();
  }

  /// Birthday 삭제 시 관련 선물 기록 모두 삭제
  Future<void> deleteGiftsByBirthdayId(String birthdayId) async {
    await _repository.deleteByBirthdayId(birthdayId);
    loadGifts();
  }
}
