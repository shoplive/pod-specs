# pod-specs

Shoplive iOS SDK용 CocoaPods Private Spec 저장소입니다.

## 디렉토리 구조

```
Specs/
└── {SDK명}/
    └── {버전}/
        └── {SDK명}.podspec
```

예시:
```
Specs/
└── ShopliveSDK/
    └── 1.0.0/
        └── ShopliveSDK.podspec
```

---

## 1. Spec Repo 로컬 등록

```bash
pod repo add shoplive-specs https://github.com/shoplive/pod-specs.git
```

등록 확인:
```bash
pod repo list
```

---

## 2. Podfile 설정 (소비자 앱)

```ruby
source 'https://github.com/shoplive/pod-specs.git'  # private spec repo
source 'https://cdn.cocoapods.org/'                   # 공식 CocoaPods CDN

target 'YourApp' do
  pod 'ShopliveSDK', '~> 1.0'
end
```

---

## 3. Podspec 검증 및 배포

```bash
# 문법 검증 (네트워크 접근 없이)
pod spec lint Specs/ShopliveSDK/1.0.0/ShopliveSDK.podspec --private --allow-warnings

# Private spec repo에 push
pod repo push shoplive-specs Specs/ShopliveSDK/1.0.0/ShopliveSDK.podspec --allow-warnings
```

---

## 4. 새 버전 추가 절차

1. `Specs/{SDK명}/{새버전}/` 디렉토리 생성
2. podspec 파일 복사 후 `s.version` 및 `s.source` URL 수정
3. `pod repo push` 로 배포
