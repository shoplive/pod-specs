# pod-specs

Shoplive iOS SDK용 CocoaPods Private Spec 저장소입니다.

이 문서는 **Shoplive SDK를 연동하는 고객사 개발자**를 위한 가이드입니다.
SDK 팀 내부용 podspec 검증(pod lint)·배포·버전 관리 절차는 👉 **[MAINTAINING.md](MAINTAINING.md)** 를 참고하세요.

---

## 1. 요구사항

| 항목 | 버전 |
|---|---|
| iOS Deployment Target | **13.0 이상** |
| Swift | 5.9 |
| CocoaPods | 1.9 이상 (XCFramework 지원 버전) |

> 정확한 요구사항은 사용하려는 SDK 버전의 podspec 기준입니다. 버전별 변경 사항(특히 최소 iOS 버전 변경)은 릴리스 공지를 확인하세요.

---

## 2. 저장소 접근 권한

이 spec 저장소가 비공개(private)로 운영되는 경우, `pod install` 시 CocoaPods가 이 저장소를 git으로 clone할 수 있어야 합니다.

- Shoplive 담당자에게 저장소 읽기 권한(GitHub 계정 초대 또는 접근 토큰)을 요청하세요.
- 발급받은 자격 증명은 로컬 git에 설정되어 있어야 하며, **CI/CD 환경에서 빌드하는 경우 CI에도 동일하게 설정**해야 합니다.
- 접근 권한이 없으면 `pod install` 단계에서 clone/인증 에러가 발생합니다.

---

## 3. 설치

### 3-1. Podfile 설정

```ruby
source 'https://github.com/shoplive/pod-specs.git'  # Shoplive private spec repo
source 'https://cdn.cocoapods.org/'                   # 공식 CocoaPods CDN

target 'YourApp' do
  pod 'ShopliveSDK', '~> 1.0'
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

새 버전이 공지되면:

```bash
pod update ShopliveSDK
```

- Podfile의 버전 제약(`~> 1.0`) **범위 안에서** 최신 버전으로 올라갑니다.
- MAJOR 버전 업그레이드(예: 1.x → 2.x)는 API 호환성이 깨질 수 있는 변경이므로, Podfile의 제약을 직접 수정해야 하며(`~> 2.0`) 릴리스 공지의 마이그레이션 안내를 먼저 확인하세요.

---

## 5. 자주 겪는 문제

| 증상 | 원인 | 해결 |
|---|---|---|
| 새 버전이 안 보임 | 로컬 spec repo 캐시가 오래됨 (자동 갱신되지 않음) | `pod install --repo-update` 또는 `pod repo update` 후 재시도 |
| `Unable to find a specification for ShopliveSDK` | Podfile에 spec repo `source` 누락, 또는 저장소 접근 권한 없음 | [3-1](#3-1-podfile-설정)의 source 확인 → [2](#2-저장소-접근-권한)의 접근 권한 확인 |
| Shoplive 외 다른 pod 설치 실패 | 공식 CDN `source` 누락 | [3-1](#3-1-podfile-설정)의 두 번째 source 추가 |
| deployment target 관련 빌드 에러 | 앱 타겟의 최소 iOS 버전이 SDK 요구(13.0)보다 낮음 | 프로젝트 Deployment Target을 13.0 이상으로 |
| clone / 인증 에러 | private 저장소 접근 자격 증명 미설정 (로컬 또는 CI) | [2](#2-저장소-접근-권한) 참고 |

해결되지 않으면 [GitHub 이슈](https://github.com/shoplive/pod-specs/issues/new)로 문의해 주세요. 아래 내용을 함께 남겨주시면 빠르게 확인할 수 있습니다.

---

## 6. 문의

연동 중 문제가 있으면 **[GitHub 이슈](https://github.com/shoplive/pod-specs/issues/new)** 로 등록해 주세요.

재현과 확인을 위해 다음을 포함해 주세요:

- 사용 중인 SDK 버전 (`pod 'ShopliveSDK', '...'`)
- `pod --version` / Xcode 버전 / iOS Deployment Target
- 에러 메시지와 `pod install --verbose` 출력 (민감 정보는 제외)
- Podfile의 `source` 및 `pod` 선언 부분

---

## SDK 팀용 문서

podspec 검증(pod spec lint) · 배포(pod repo push) · 버전 관리 규칙 · PR 자동 검증(CI)은
👉 **[MAINTAINING.md](MAINTAINING.md)** 에서 다룹니다. 고객사 개발자는 볼 필요가 없습니다.
