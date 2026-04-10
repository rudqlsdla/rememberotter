import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rememberotter/shared/log/logger.dart';
import 'package:rememberotter/shared/services/error_reporting_service.dart';

/// Firestore에서 쇼핑 링크를 관리하는 서비스
class ShoppingLinkService {
  static final ShoppingLinkService _instance = ShoppingLinkService._internal();
  factory ShoppingLinkService() => _instance;
  ShoppingLinkService._internal();

  static const _defaultKakaoShoppingUrl =
      'https://search.shopping.daum.net/search?keyword=';
  static const _defaultNaverShoppingUrl =
      'https://search.shopping.naver.com/search/all?query=';
  static const _defaultCoupangShoppingUrl =
      'https://www.coupang.com/np/search?component=&q=';
  static const _defaultShoppingQuery = '생일선물';

  String _kakaoShoppingUrl = _defaultKakaoShoppingUrl;
  String _naverShoppingUrl = _defaultNaverShoppingUrl;
  String _coupangShoppingUrl = _defaultCoupangShoppingUrl;
  String _defaultQuery = _defaultShoppingQuery;

  String get kakaoShoppingUrl => _kakaoShoppingUrl;
  String get naverShoppingUrl => _naverShoppingUrl;
  String get coupangShoppingUrl => _coupangShoppingUrl;
  String get defaultShoppingQuery => _defaultQuery;

  /// Firestore에서 쇼핑 링크 설정을 1회 읽기
  Future<void> initialize() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('shopping_links')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _kakaoShoppingUrl =
            data['kakao_shopping_url'] as String? ?? _defaultKakaoShoppingUrl;
        _naverShoppingUrl =
            data['naver_shopping_url'] as String? ?? _defaultNaverShoppingUrl;
        _coupangShoppingUrl =
            data['coupang_shopping_url'] as String? ??
            _defaultCoupangShoppingUrl;
        _defaultQuery =
            data['default_shopping_query'] as String? ??
            _defaultShoppingQuery;
      }

      logger.i('ShoppingLinkService 초기화 완료');
    } catch (e, stack) {
      logger.e('ShoppingLinkService 초기화 실패 (기본값 사용): $e');
      ErrorReportingService().reportError(e, stack);
    }
  }
}
