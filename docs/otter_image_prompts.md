# 해달 캐릭터 이미지 생성 프롬프트

## 사용 방법

1. GPT에 **기존 해달 이미지** (`assets/images/splash/splash_otter.png`)를 첨부
2. 아래 프롬프트를 입력
3. 512×512px로 생성, 배경 투명 처리 후 `assets/images/otter/`에 저장

---

## 공통 프리픽스 (모든 프롬프트 앞에 붙이기)

```
Create a variation of the attached sea otter character.
Keep the exact same face, body shape, fur color, eye style, and art style as the original.eㄷe
512×512px, transparent background, full body visible.
```

---

## 1. empty — 빈 목록 상태

> 생일이 등록되지 않은 빈 화면에 표시. 살짝 아쉬우면서도 기대하는 표정.

```
Create a variation of the attached sea otter character.
Keep the exact same face, body shape, fur color, eye style, and art style as the original.
512×512px, transparent background, full body visible.

The otter is sitting on the ground, tilting its head slightly to one side.
It is holding a small pink birthday cake with both paws. The cake has a single unlit candle on top.
Its expression is gently expectant and a little wistful, as if waiting for someone's birthday to celebrate.

꼭 PNG로 뒤에 흰색 배경 지우고 체커보드 지운 이미지로 만들어줘야돼
```

**파일명**: `img_otter_empty.png`

---

## 2. celebrate — 생일 축하

> 생일 당일 축하 화면에 표시. 신나고 즐거운 분위기.

```
Create a variation of the attached sea otter character.
Keep the exact same face, body shape, fur color, eye style, and art style as the original.
512×512px, transparent background, full body visible.

The otter is wearing a small pink party hat and jumping with both arms raised in excitement.
One paw is holding a small birthday cake with a lit candle.
Colorful confetti and small star sparkles are scattered around.
Its mouth is open in a cheerful "yay!" expression. The mood is joyful and festive.

꼭 PNG로 뒤에 흰색 배경 지우고 체커보드 지운 이미지로 만들어줘야돼
```

**파일명**: `img_otter_celebrate.png`

---

## 3. gift — 선물 기록

> 선물 히스토리 빈 화면에 표시. 소중한 선물을 아끼는 따뜻한 느낌.

```
Create a variation of the attached sea otter character.
Keep the exact same face, body shape, fur color, eye style, and art style as the original.
512×512px, transparent background, full body visible.

The otter is sitting and hugging a pink gift box with a ribbon bow using both paws.
Its eyes are gently closed with a warm, content smile, as if cherishing the gift.
A small heart floats above its head. The mood is warm and heartfelt.

꼭 PNG로 뒤에 흰색 배경 지우고 체커보드 지운 이미지로 만들어줘야돼
```

**파일명**: `img_otter_gift.png`

---

## 4. wave — 인사 / 안내

> 온보딩, 권한 요청, 업데이트 안내 등에 표시. 친근하게 인사하는 모습.

```
Create a variation of the attached sea otter character.
Keep the exact same face, body shape, fur color, eye style, and art style as the original.
512×512px, transparent background, full body visible.

The otter is standing upright, waving one paw cheerfully at the viewer.
The other paw rests on its round belly. It has a bright, welcoming smile.
Small sparkle effects appear near the waving paw. The mood is friendly and approachable.

꼭 PNG로 뒤에 흰색 배경 지우고 체커보드 지운 이미지로 만들어줘야돼
```

**파일명**: `img_otter_wave.png`

---

## 5. error — 에러 상태

> 오류 발생 시 표시. 당황하지만 여전히 귀여운 모습.

```
Create a variation of the attached sea otter character.
Keep the exact same face, body shape, fur color, eye style, and art style as the original.
512×512px, transparent background, full body visible.

The otter is sitting, scratching the back of its head with one paw, while the other paw is raised palm-out in a "sorry" gesture.
Small sweat drops appear near its head, and a tiny exclamation mark floats beside it.
Its expression is flustered and apologetic, but still adorable.

꼭 PNG로 뒤에 흰색 배경 지우고 체커보드 지운 이미지로 만들어줘야돼
```

**파일명**: `img_otter_error.png`

---

## 6. splash — 스플래시 화면 (기존 이미지)

> 앱 실행 시 스플래시 화면에 표시. 생일 파티 분위기의 밝고 활기찬 모습.

```
Create a variation of the attached sea otter character.
Keep the exact same face, body shape, fur color, eye style, and art style as the original.
512×512px, transparent background, full body visible.

The otter is standing upright, wearing a small pink-and-yellow striped party hat with a pink pom-pom on top.
Its right paw is raised and waving cheerfully at the viewer, and its left paw is holding a small pink birthday cake with three lit candles.
It has big sparkly eyes, rosy pink cheeks, a wide open happy smile, and a light cream-colored belly.
The fur is soft lavender purple. The pose is lively and welcoming.
512×512px, transparent background, full body visible from head to feet.

꼭 PNG로 뒤에 흰색 배경 지우고 체커보드 지운 이미지로 만들어줘야돼
```

**파일명**: `splash_otter.png`
**경로**: `assets/images/splash/`

---

## 7. app_icon — 앱 아이콘

> 앱 스토어 및 홈 화면에 표시되는 앱 아이콘. 스플래시 해달의 얼굴 클로즈업.

```
A close-up portrait of the same sea otter character, framed from the chest up.
It is wearing the same pink-and-yellow striped party hat with a pink pom-pom.
Both paws are holding a small pink birthday cake with three lit candles at the bottom of the frame.
Big sparkly eyes, rosy pink cheeks, wide open happy smile, soft lavender purple fur, light cream belly.
The background is a solid soft pink (#FDE8F0). NOT transparent.
512×512px, square composition, suitable for an app icon.
```

**파일명**: `app_icon.png`
**경로**: `assets/images/logo/`

---

## 적용 방법

1. 위 프롬프트 + 기존 해달 이미지 첨부하여 생성
2. 배경이 투명하지 않으면 배경 제거 처리
3. 파일을 `assets/images/otter/` 폴더에 저장
4. `flutter pub run build_runner build` 실행 (assets.gen.dart 재생성)
5. `OtterImage` 위젯의 `asset` getter에 매핑 추가
