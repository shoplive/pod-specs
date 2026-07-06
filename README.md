# pod-specs

Shoplive iOS SDK용 CocoaPods Private Spec 저장소입니다.

> **⚠️ 이 저장소에 직접 git push로 podspec을 올리지 마세요.**
> 반드시 `pod spec lint` 검증 → `pod repo push` 순서로 배포합니다. 아래 [3. Podspec 검증](#3-podspec-검증-pod-lint) / [4. 배포](#4-배포-pod-repo-push)를 따라주세요.

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

**규칙 (CocoaPods가 강제하는 사항):**

| 항목 | 규칙 | 어기면 생기는 일 |
|---|---|---|
| 디렉토리 버전 | podspec의 `s.version`과 **완전히 동일**해야 함 (`1.0.0` 디렉토리 ↔ `s.version = '1.0.0'`) | `pod repo push`가 거부하거나, 소비자 쪽에서 해당 버전을 못 찾음 |
| 파일명 | `s.name`과 동일한 `{SDK명}.podspec` | pod 탐색 실패 |
| 한 디렉토리 = 한 버전 | 버전당 podspec 1개만 | 중복 정의로 resolve 실패 |

---

## 1. Spec Repo 로컬 등록

```bash
pod repo add shoplive-specs https://github.com/shoplive/pod-specs.git
```

등록 확인:
```bash
pod repo list
```

이미 등록된 상태에서 최신 스펙을 받으려면:
```bash
pod repo update shoplive-specs
```

---

## 2. Podfile 설정 (소비자 앱)

```ruby
source 'https://github.com/shoplive/pod-specs.git'  # private spec repo
source 'https://cdn.cocoapods.org/'                   # 공식 CocoaPods CDN
```

> private repo에 있는 pod과 공식 CDN pod 이름이 겹치지 않는 한, source 순서는 결과에 영향을 주지 않습니다. 다만 둘 다 명시하는 것을 잊으면 (`source`를 하나라도 쓰는 순간 기본 CDN이 암묵 적용되지 않으므로) 공식 pod 설치가 전부 실패합니다.

```ruby
target 'YourApp' do
  pod 'ShopliveSDK', '~> 1.0'
end
```

---

## 3. Podspec 검증 (pod lint)

### 3-0. lint 전에 반드시 확인할 것

이 저장소의 podspec은 **GitHub Release asset(XCFramework zip)을 `s.source`로 참조**합니다.
`pod spec lint`는 문법 검사만 하는 것이 아니라 **`s.source` URL에서 실제로 파일을 다운로드해 빌드 가능한지 검사**합니다. 따라서:

1. **`ios-sdk` 저장소에 해당 버전의 GitHub Release가 먼저 발행되어 있어야 하고,**
2. **그 Release에 `ShopliveSDK.xcframework.zip` asset이 업로드되어 있어야 합니다.**

이 순서를 지키지 않으면 lint가 `Failed to download` / 404로 실패합니다. **가장 흔한 실수이니, lint 실패 시 podspec을 고치기 전에 Release asset부터 확인하세요:**

```bash
# asset이 실제로 존재하는지 확인 (200 OK인지)
curl -sIL -o /dev/null -w "%{http_code}\n" \
  "https://github.com/shoplive/ios-sdk/releases/download/1.0.0/ShopliveSDK.xcframework.zip"
```

### 3-1. lint 명령 두 가지의 차이

| 명령 | 검사 대상 | 언제 쓰나 |
|---|---|---|
| `pod lib lint` | 로컬 소스 트리 (`s.source` 무시) | SDK 소스 저장소 안에서 개발 중 빠른 검사 |
| `pod spec lint` | **`s.source`에서 실제 다운로드** | **이 저장소에서 배포 전 최종 검증 — 항상 이걸 사용** |

이 저장소에서는 소스가 아니라 배포된 바이너리를 검증해야 하므로 **`pod spec lint`가 정답**입니다. `pod lib lint`가 통과했다고 배포 가능한 것이 아닙니다.

### 3-2. 실행

```bash
pod spec lint Specs/ShopliveSDK/1.0.0/ShopliveSDK.podspec \
  --private \
  --allow-warnings \
  --verbose
```

**옵션 설명 — 왜 붙이는지 알고 쓰세요:**

- `--private` : private pod 전용 검사 모드. 공개 pod에만 해당하는 경고(예: homepage 접근성 등)를 건너뜁니다. private repo용이므로 항상 붙입니다.
- `--allow-warnings` : 경고가 있어도 통과 처리. **먼저 `--allow-warnings` 없이 돌려서 경고 내용을 확인한 뒤**, 무시해도 되는 경고(라이선스 형식 등)인지 판단하고 붙이세요. 경고를 읽지도 않고 습관적으로 붙이는 것이 사고의 시작입니다.
- `--verbose` : 실패 시 원인(다운로드 실패인지, 빌드 실패인지)을 구분하려면 필수 수준으로 유용합니다.
- `--sources` : 이 podspec이 **다른 private pod에 의존**하는 경우에만 필요합니다. lint는 기본적으로 공식 CDN만 보므로, private 의존성이 있으면 다음처럼 명시합니다:
  ```bash
  pod spec lint ... --sources=https://github.com/shoplive/pod-specs.git,https://cdn.cocoapods.org/
  ```

### 3-3. lint에서 실제로 검사되는 것

- podspec Ruby 문법 및 필수 필드(name/version/source/license 등)
- `s.source` URL 다운로드 가능 여부
- zip 내부에 `s.vendored_frameworks` 경로(`ShopliveSDK.xcframework`)가 실제 존재하는지
- 명시한 `deployment_target`으로 테스트 프로젝트 빌드 통과 여부

즉 **lint 통과 = "소비자가 `pod install` 했을 때 되는 상태"의 근사치**입니다. 통과 로그(`ShopliveSDK.podspec passed validation.`)를 확인하기 전에는 다음 단계로 가지 마세요.

### 3-4. 자주 겪는 lint 실패와 원인

| 증상 | 원인 | 조치 |
|---|---|---|
| `Failed to download` / 404 | Release 미발행 또는 asset 미업로드, URL 오타 | 3-0의 curl로 asset 존재 확인. `#{s.version}` 보간이 태그명과 일치하는지 확인 (`1.0.0` vs `v1.0.0` 불일치 주의) |
| `file patterns: The 'vendored_frameworks' pattern did not match any file` | zip 내부 경로가 podspec과 다름 (zip을 폴더째 압축해서 한 겹 더 들어간 경우가 대부분) | `unzip -l ShopliveSDK.xcframework.zip`으로 최상위에 `ShopliveSDK.xcframework/`가 오는지 확인 |
| `Unable to find a specification for ...` | private 의존성이 있는데 `--sources` 누락 | 3-2의 `--sources` 옵션 추가 |
| 시뮬레이터/아키텍처 빌드 에러 | XCFramework에 시뮬레이터 slice 누락 | SDK 빌드 파이프라인에서 `-destination` 확인 후 재빌드·재업로드 (버전을 올려서!) |
| 어제는 됐는데 오늘 실패 | CocoaPods/Xcode 버전 차이 | `pod --version`, `xcodebuild -version`을 팀 표준과 맞춤 |

---

## 4. 배포 (pod repo push)

### 4-1. 반드시 `pod repo push`로 배포

```bash
pod repo push shoplive-specs Specs/ShopliveSDK/1.0.0/ShopliveSDK.podspec \
  --allow-warnings \
  --verbose
```

`pod repo push`는 다음을 한 번에 수행합니다:

1. 내부적으로 lint를 한 번 더 실행 (그래서 3단계를 건너뛰어도 걸러지지만, 실패 원인 파악이 어려우니 3단계를 먼저 하세요)
2. 로컬 spec repo(`~/.cocoapods/repos/shoplive-specs`)의 올바른 경로에 podspec 배치
3. git commit + push

**git으로 직접 push하면 안 되는 이유:** lint를 우회하게 되어 깨진 podspec이 그대로 배포되고, 소비자 전원의 `pod install`이 깨집니다. 이 저장소에 대한 직접 push는 CI 설정 변경 등 spec 외 파일에 한정하세요.

`pod repo push`도 내부에서 lint를 하므로 private 의존성이 있다면 여기서도 `--sources`가 필요합니다.

### 4-2. push 실패 시

- `[!] The repo is not clean` : 로컬 `~/.cocoapods/repos/shoplive-specs`에 커밋 안 된 변경이 있음. 해당 디렉토리에서 `git status` 확인 후 정리.
- push 도중 충돌 : 다른 사람이 먼저 배포한 경우. `pod repo update shoplive-specs` 후 재시도.
- 권한 에러 : GitHub 계정에 이 저장소 write 권한이 있는지 확인.

### 4-3. 배포 직후 검증 (이걸 해야 "배포 완료")

배포자는 소비자 입장에서 설치가 되는 것까지 확인합니다:

```bash
pod repo update shoplive-specs

# 새 버전이 검색되는지 확인
pod search ShopliveSDK  # 또는: ls ~/.cocoapods/repos/shoplive-specs/Specs/ShopliveSDK/

# 샘플/테스트 앱에서 실제 설치
pod install --repo-update
```

"push 성공 로그 봤으니 끝"이 아니라, **새 버전으로 `pod install`이 실제로 성공한 것을 확인한 시점**이 배포 완료입니다.

---

## 5. 새 버전 추가 절차 (요약 체크리스트)

순서가 중요합니다. **바이너리(Release asset)가 항상 podspec보다 먼저**입니다.

- [ ] 1. `ios-sdk` 저장소에서 새 버전 태그 + GitHub Release 발행, `ShopliveSDK.xcframework.zip` asset 업로드
- [ ] 2. `curl -sIL`로 asset URL 200 확인 (3-0 참고)
- [ ] 3. `Specs/ShopliveSDK/{새버전}/` 디렉토리 생성 (디렉토리명 = `s.version`)
- [ ] 4. 이전 버전 podspec 복사 후 수정 — 최소한 다음을 확인:
  - `s.version` — 새 버전으로
  - `s.source` — `#{s.version}` 보간을 쓰고 있다면 자동 반영되지만, **태그 명명 규칙이 바뀌지 않았는지** 확인
  - `deployment_target` / `swift_version` — SDK 빌드 설정과 일치하는지
- [ ] 5. `pod spec lint --private --verbose` (처음엔 `--allow-warnings` 없이) → 통과 확인
- [ ] 6. `pod repo push shoplive-specs ...` → 성공 확인
- [ ] 7. `pod repo update` 후 테스트 앱에서 `pod install`로 설치 검증
- [ ] 8. 소비자 팀에 새 버전 공지 (변경사항 / 최소 iOS 버전 변경 여부 포함)

---

## 6. 배포된 버전 관리 규칙

### 6-1. 배포된 버전은 절대 수정하지 않는다 (불변 원칙)

한 번 push된 `{버전}/podspec`과 그 버전의 Release asset은 **수정·재업로드 금지**입니다.

- CocoaPods는 소비자 로컬에 podspec과 다운로드 결과를 캐시합니다. 같은 버전의 내용을 바꾸면 **사람마다 다른 바이너리를 쓰는 상태**가 되고, checksum 불일치로 `pod install`이 깨지기도 합니다.
- 문제가 발견되면 → **패치 버전을 올려 새로 배포**합니다 (`1.0.0`에 문제 → `1.0.1` 발행). "방금 올렸으니까 조용히 덮어쓰자"가 가장 위험한 판단입니다.

### 6-2. 잘못 배포된 버전 내리기 (yank)

이미 소비자가 받아갔을 수 있으므로 신중히:

1. 먼저 수정된 새 버전을 배포하고,
2. 그 다음 문제 버전 디렉토리를 삭제하는 커밋을 이 저장소에 올립니다 (이 경우만 예외적으로 직접 git 조작).
3. 해당 버전을 사용 중인 소비자 팀에 반드시 공지합니다. (spec을 지워도 이미 설치된 쪽은 계속 동작하므로, 공지 없이는 아무도 모릅니다.)

### 6-3. 버전 규칙

[Semantic Versioning](https://semver.org/lang/ko/)을 따릅니다:

- **MAJOR** : API 호환성이 깨지는 변경
- **MINOR** : 하위 호환 기능 추가
- **PATCH** : 하위 호환 버그 수정

소비자가 `~> 1.0`처럼 optimistic 연산자를 쓰므로, **하위 호환이 깨지는 변경을 MINOR/PATCH로 내보내면 소비자 앱이 예고 없이 깨집니다.** 애매하면 MAJOR로 올리세요. `deployment_target` 상향도 소비자 빌드를 깨뜨릴 수 있는 변경이므로 최소 MINOR + 공지 대상입니다.

### 6-4. 여러 SDK를 관리할 때

- SDK 간 의존성이 있으면(`s.dependency 'ShopliveCommon', '~> x.y'`) **의존되는 쪽을 먼저 배포**합니다.
- lint/push 시 `--sources`에 이 repo를 포함해야 의존성 resolve가 됩니다 (3-2 참고).

---

## 7. 문제 해결 FAQ

**Q. 소비자가 "새 버전이 안 보인다"고 합니다.**
소비자 쪽에서 `pod repo update shoplive-specs` 또는 `pod install --repo-update`를 실행해야 합니다. 로컬 spec repo는 자동 갱신되지 않습니다.

**Q. lint는 통과했는데 소비자 설치가 실패합니다.**
소비자의 CocoaPods/Xcode 버전, Podfile의 `source` 누락, 다른 pod과의 `deployment_target` 충돌을 순서대로 확인하세요. 재현이 안 되면 소비자의 `pod install --verbose` 로그를 받아 비교합니다.

**Q. `s.source`의 태그를 `v1.0.0`으로 만들었는데 podspec은 `1.0.0`을 봅니다.**
`s.source` URL의 `#{s.version}` 앞에 `v`를 붙이거나, Release 태그 규칙을 `1.0.0`으로 통일하세요. **이 저장소는 `v` 없는 `1.0.0` 형식을 표준으로 합니다.**

**Q. 실수로 잘못된 podspec을 push해버렸습니다.**
당황하지 말고 6-2(yank) 절차를 따르세요. 핵심은 (1) 고친 새 버전 먼저, (2) 그 다음 삭제, (3) 공지입니다.
