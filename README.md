# pod-specs

Shoplive iOS SDK 배포용 CocoaPods Spec 저장소입니다.

이 문서는 **Shoplive SDK를 연동하는 고객사 개발자**를 위한 가이드입니다.
SDK 팀 내부용 podspec 검증(pod lint)·배포·버전 관리 절차는 👉 **[MAINTAINING.md](MAINTAINING.md)** 를 참고하세요.

---

## 1. SDK 계열 선택 (1.x / 3.x)

이 저장소는 **1.x와 3.x 두 계열**을 함께 제공합니다. 두 계열은 pod 이름·모듈·API가 서로 다른 별개 제품이므로, 앱에 맞는 쪽을 **하나만** 골라 사용하세요.

| | 1.x | 3.x |
|---|---|---|
| Podfile 선언 | `ShopLive` + `ShopliveSDKCommon` (**각각 직접 선언**) | `ShoplivePlayerSDK` 및/또는 `ShopliveStreamerSDK` |
| import | `import ShopLiveSDK` | `import ShoplivePlayerSDK` / `import ShopliveStreamerSDK` |
| 내부 의존 pod | 자동으로 따라오지 않음 — 필요한 pod을 모두 명시 | 자동 포함 (`ShopliveCore`·`ShopLiveWebRTCHelperSDK`·`ShopliveWebRTC`는 직접 선언 불필요) |
| 최소 iOS | 1.9.0: **15.0** / 1.8.x: 11.0 | **15.0** |

> - 한 앱에 1.x와 3.x를 **함께 넣는 구성은 지원하지 않습니다.**
> - 1.x → 3.x 전환은 버전만 올리는 업데이트가 아닙니다. Podfile의 pod 이름을 바꾸고, 릴리스 공지의 마이그레이션 안내에 따라 코드를 수정해야 합니다.
> - 3.x는 SwiftPM(`https://github.com/shoplive/shoplive-sdk-ios`)으로도 배포되며, CocoaPods로 받는 바이너리와 동일합니다.

---

## 2. 요구사항

| 항목 | 버전 |
|---|---|
| iOS Deployment Target | 사용할 SDK 버전의 최소 iOS 이상 ([1](#1-sdk-계열-선택-1x--3x)의 표 참고) |
| Swift | 5.9 |
| CocoaPods | 1.9 이상 (XCFramework 지원 버전) |

> 정확한 요구사항은 사용하려는 SDK 버전의 podspec 기준입니다. 버전별 변경 사항(특히 최소 iOS 버전 변경)은 릴리스 공지를 확인하세요.

---

## 3. 설치

### 3-1. Podfile 설정

**3.x**

```ruby
source 'https://github.com/shoplive/pod-specs.git'  # Shoplive spec repo
source 'https://cdn.cocoapods.org/'                   # 공식 CocoaPods CDN

platform :ios, '15.0'

target 'YourApp' do
  pod 'ShoplivePlayerSDK', '~> 3.0'      # 시청(Player)
  # pod 'ShopliveStreamerSDK', '~> 3.0'  # 송출(Streamer) — 필요할 때만
end
```

**1.x**

```ruby
source 'https://github.com/shoplive/pod-specs.git'  # Shoplive spec repo
source 'https://cdn.cocoapods.org/'                   # 공식 CocoaPods CDN

platform :ios, '15.0'

target 'YourApp' do
  # 1.x 는 의존 pod 이 자동으로 따라오지 않으므로 각각 선언한다.
  pod 'ShopLive', '~> 1.9'
  pod 'ShopliveSDKCommon', '~> 1.9'
end
```

> **⚠️ `source` 두 줄을 모두 명시하세요.**
> Podfile에 `source`를 하나라도 쓰는 순간 기본 CDN이 자동 적용되지 않습니다. 공식 CDN 줄을 빼먹으면 Shoplive SDK가 아닌 **다른 모든 pod의 설치가 실패**합니다.

### 3-2. 설치 실행

```bash
pod install --repo-update
```

`--repo-update`는 spec 저장소를 최신으로 갱신한 뒤 설치합니다. 처음 연동하거나 새 버전 설치 시 항상 붙이는 것을 권장합니다.

---

## 4. SDK 버전 업데이트

새 버전이 공지되면 사용 중인 pod을 업데이트합니다:

```bash
pod update ShoplivePlayerSDK                 # 3.x
pod update ShopLive ShopliveSDKCommon        # 1.x — 함께 선언한 pod은 함께 올린다
```

- Podfile의 버전 제약(`~> 3.0`, `~> 1.9`) **범위 안에서** 최신 버전으로 올라갑니다.
- MAJOR 버전 업그레이드는 API 호환성이 깨질 수 있는 변경이므로, Podfile의 제약을 직접 수정해야 하며 릴리스 공지의 마이그레이션 안내를 먼저 확인하세요. 1.x → 3.x 전환은 [1](#1-sdk-계열-선택-1x--3x)을 참고하세요.

---

## 5. 자주 겪는 문제

| 증상 | 원인 | 해결 |
|---|---|---|
| 새 버전이 안 보임 | 로컬 spec repo 캐시가 오래됨 (자동 갱신되지 않음) | `pod install --repo-update` 또는 `pod repo update` 후 재시도 |
| `Unable to find a specification for ShoplivePlayerSDK` 등 | Podfile에 spec repo `source` 누락 | [3-1](#3-1-podfile-설정)의 source 확인 |
| Shoplive 외 다른 pod 설치 실패 | 공식 CDN `source` 누락 | [3-1](#3-1-podfile-설정)의 두 번째 source 추가 |
| deployment target 관련 빌드 에러 | 앱 타겟의 최소 iOS 버전이 SDK 요구보다 낮음 | 프로젝트 Deployment Target을 [1](#1-sdk-계열-선택-1x--3x)의 최소 iOS 이상으로 |
| 1.x에서 `No such module 'ShopliveSDKCommon'` 등 링크/모듈 에러 | 1.x는 의존 pod이 자동으로 따라오지 않음 | [3-1](#3-1-podfile-설정)의 1.x 예시처럼 pod을 각각 선언 |
| 3.x에서 `WebRTC` 모듈·심볼 중복 에러 | 앱이 다른 WebRTC 라이브러리(예: `WebRTC-SDK`, `GoogleWebRTC`)를 함께 사용 | 3.x는 자체 `WebRTC.framework`를 포함하므로 다른 WebRTC 라이브러리와 함께 쓸 수 없습니다. 문의해 주세요 |

해결되지 않으면 [GitHub 이슈](https://github.com/shoplive/pod-specs/issues/new)로 문의해 주세요. 아래 내용을 함께 남겨주시면 빠르게 확인할 수 있습니다.

---

## 6. 문의

연동 중 문제가 있으면 **[GitHub 이슈](https://github.com/shoplive/pod-specs/issues/new)** 로 등록해 주세요.

재현과 확인을 위해 다음을 포함해 주세요:

- 사용 중인 SDK 계열과 버전 (Podfile.lock의 Shoplive pod 버전)
- `pod --version` / Xcode 버전 / iOS Deployment Target
- 에러 메시지와 `pod install --verbose` 출력 (민감 정보는 제외)
- Podfile의 `source` 및 `pod` 선언 부분

---

## SDK 팀용 문서

podspec 검증(pod spec lint) · 배포(pod repo push) · 버전 관리 규칙 · PR 자동 검증(CI)은
👉 **[MAINTAINING.md](MAINTAINING.md)** 에서 다룹니다. 고객사 개발자는 볼 필요가 없습니다.
