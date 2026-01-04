# 한다라트

만다라트를 한다! 목표 달성을 위한 만다라트 앱

## 개발 환경 설정

### 요구사항
- Flutter SDK
- Xcode (iOS 개발)

### 시뮬레이터 실행 방법

```bash
# 1. iOS 시뮬레이터 실행
flutter emulators --launch apple_ios_simulator

# 2. 시뮬레이터에서 앱 실행
flutter run

# 또는 특정 시뮬레이터 지정
flutter run -d "iPhone 17 Pro"
```

### macOS에서 실행

```bash
flutter run -d macos
```

### 실제 기기에서 실행

실제 iPhone 기기는 코드 사이닝이 필요합니다:
1. `open ios/Runner.xcworkspace`
2. Runner 타겟 → Signing & Capabilities에서 Team 설정
3. `flutter run -d iPhone`

## 프로젝트 구조

```
lib/
├── app/              # 앱 설정
├── core/             # 테마, 상수 등
├── data/             # 데이터베이스
└── features/         # 기능별 화면
    ├── home/         # 홈 화면
    ├── mandalart/    # 만다라트 그리드
    └── startup/      # 시작 화면
```
