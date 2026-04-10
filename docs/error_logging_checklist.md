# 에러 로깅 체크리스트

새로운 기능 추가 시 에러 리포팅이 빠지지 않도록 확인하는 체크리스트.

---

## 1. try-catch 블록 확인

- [ ] 새로 추가한 `catch` 블록에 `ErrorReportingService().reportError(e, stack)` 호출이 있는가?
- [ ] `catch (e)` 가 아닌 `catch (e, stack)` 으로 스택트레이스도 받고 있는가?
- [ ] 기존 logger 호출(`logger.e`, `logger.w`)은 유지하면서 **추가로** 웹훅 전송하는가?

```dart
// 올바른 패턴
try {
  await someOperation();
} catch (e, stack) {
  logger.e('작업 실패: $e');
  ErrorReportingService().reportError(e, stack);
}
```

## 2. 예외: 웹훅 호출하지 않아도 되는 경우

| 경우 | 이유 |
|------|------|
| `ErrorReportingService` 내부 catch | 무한루프 방지 |
| `_getDeviceInfo()` 같은 부가 정보 수집 | 리포팅 자체에 종속된 로직 |
| 의도적으로 무시하는 에러 (예: 취소된 요청) | 노이즈 방지 — 주석으로 사유 명시 |

## 3. 새 서비스/컨트롤러 추가 시

- [ ] import 추가: `import 'package:rememberotter/shared/services/error_reporting_service.dart';`
- [ ] 네트워크 호출, DB 쿼리, 외부 SDK 호출 등 실패 가능한 코드에 try-catch + 에러 리포팅 적용
- [ ] 빈 catch 블록 (`catch (_) {}`) 금지

## 4. 글로벌 에러 핸들러 (main.dart)

이미 설정되어 있으므로 건드릴 필요 없음. 참고용:

- `FlutterError.onError` → 위젯 빌드/렌더링 에러
- `PlatformDispatcher.instance.onError` → 비동기 에러

> catch 블록에서 잡은 에러는 글로벌 핸들러로 전파되지 않으므로, catch 블록마다 직접 `reportError`를 호출해야 한다.

## 5. PR 셀프 리뷰 시 확인

- [ ] `catch` 로 검색해서 모든 catch 블록에 에러 리포팅이 있는지 확인
- [ ] 새로 추가한 비동기 함수에서 에러가 적절히 처리되는지 확인