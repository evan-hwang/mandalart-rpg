# 한다라트

만다라트를 한다! 목표 달성을 위한 5x5 만다라트 앱

## 주요 기능

- **5x5 만다라트 그리드**: 메인 1개, 서브 4개, 세부 20개 목표 관리
- **목표 상태 관리**: 할일/진행중/완료 상태 토글 (롱프레스)
- **자동 완료 시스템**: 세부 목표 완료 시 서브/메인 자동 완료
- **진행률 표시**: 그라데이션 프로그레스 바로 달성률 시각화
- **공유 기능**: 만다라트를 이미지로 공유
- **로컬 데이터 저장**: Drift(SQLite) 기반 영구 저장

## 스크린샷

| 홈 화면 | 만다라트 그리드 |
|--------|--------------|
| 만다라트 목록 | 5x5 목표 관리 |

## 개발 환경 설정

### 요구사항
- Flutter SDK 3.x
- Xcode (iOS 개발)
- Android Studio (Android 개발)

### 설치 및 실행

```bash
# 의존성 설치
flutter pub get

# iOS 시뮬레이터 실행
flutter emulators --launch apple_ios_simulator
flutter run

# Android 에뮬레이터 실행
flutter run -d android

# macOS 실행
flutter run -d macos
```

### 릴리즈 빌드

```bash
# Android AAB (Google Play 업로드용)
flutter build appbundle --release

# iOS (App Store 업로드용)
flutter build ipa --release
```

## 프로젝트 구조

```
lib/
├── app/              # 앱 설정 (테마, 라우팅)
├── core/             # 상수, 모델, 서비스
│   ├── constants/    # 색상, 그리드 상수
│   ├── models/       # Goal 모델
│   └── services/     # SharedPreferences
├── data/             # 데이터 레이어
│   └── db/           # Drift 데이터베이스
└── features/         # 기능별 화면
    ├── home/         # 홈 화면, 만다라트 생성
    ├── mandalart/    # 만다라트 그리드 화면
    └── startup/      # 스플래시 화면
```

## 기술 스택

- **Flutter** - 크로스 플랫폼 UI
- **Drift** - SQLite ORM
- **Screenshot** - 이미지 캡처
- **Share Plus** - 공유 기능
- **Pretendard** - 한글 폰트

## 라이선스

MIT License
