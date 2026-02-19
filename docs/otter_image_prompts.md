# 해달 캐릭터 이미지 생성 프롬프트

## 사용 방법

1. GPT에 **기존 해달 이미지** (`assets/images/splash/splash_otter.png`)를 첨부
2. 아래 프롬프트를 입력
3. 512×512px로 생성, 배경 투명 처리 후 `assets/images/otter/`에 저장

---

## 공통 프리픽스 (모든 프롬프트 앞에 붙이기)

```
Create a variation of the attached sea otter character.
Keep the exact same face, body shape, fur color, eye style, and art style as the original.
512×512px, transparent background, full body visible.
```

---

## 1. empty — 빈 목록 상태

> 생일이 등록되지 않은 빈 화면에 표시. 살짝 아쉬우면서도 기대하는 표정.

```
The otter is sitting on the ground, tilting its head slightly to one side.
It is holding a small pink birthday cake with both paws. The cake has a single unlit candle on top.
Its expression is gently expectant and a little wistful, as if waiting for someone's birthday to celebrate.
```

**파일명**: `img_otter_empty.png`

---

## 2. celebrate — 생일 축하

> 생일 당일 축하 화면에 표시. 신나고 즐거운 분위기.

```
The otter is wearing a small pink party hat and jumping with both arms raised in excitement.
One paw is holding a small birthday cake with a lit candle.
Colorful confetti and small star sparkles are scattered around.
Its mouth is open in a cheerful "yay!" expression. The mood is joyful and festive.
```

**파일명**: `img_otter_celebrate.png`

---

## 3. gift — 선물 기록

> 선물 히스토리 빈 화면에 표시. 소중한 선물을 아끼는 따뜻한 느낌.

```
The otter is sitting and hugging a pink gift box with a ribbon bow using both paws.
Its eyes are gently closed with a warm, content smile, as if cherishing the gift.
A small heart floats above its head. The mood is warm and heartfelt.
```

**파일명**: `img_otter_gift.png`

---

## 4. wave — 인사 / 안내

> 온보딩, 권한 요청, 업데이트 안내 등에 표시. 친근하게 인사하는 모습.

```
The otter is standing upright, waving one paw cheerfully at the viewer.
The other paw rests on its round belly. It has a bright, welcoming smile.
Small sparkle effects appear near the waving paw. The mood is friendly and approachable.
```

**파일명**: `img_otter_wave.png`

---

## 5. error — 에러 상태

> 오류 발생 시 표시. 당황하지만 여전히 귀여운 모습.

```
The otter is sitting, scratching the back of its head with one paw, while the other paw is raised palm-out in a "sorry" gesture.
Small sweat drops appear near its head, and a tiny exclamation mark floats beside it.
Its expression is flustered and apologetic, but still adorable.
```

**파일명**: `img_otter_error.png`

---

## 적용 방법

1. 위 프롬프트 + 기존 해달 이미지 첨부하여 생성
2. 배경이 투명하지 않으면 배경 제거 처리
3. 파일을 `assets/images/otter/` 폴더에 저장
4. `flutter pub run build_runner build` 실행 (assets.gen.dart 재생성)
5. `OtterImage` 위젯의 `asset` getter에 매핑 추가
