Pod::Spec.new do |spec|
  spec.name         = "ShopLive"
  spec.version      = "1.9.0"
  spec.summary      = "ShopLive SDK for iOS"

  spec.homepage     = "http://shoplive.cloud"

  # 1.9.0 부터 배포처가 shoplive/shoplive-sdk-ios 의 릴리즈 에셋으로 바뀌었다.
  # 1.8.x 까지는 shoplive/ios-sdk 의 git 태그를 체크아웃해 그 안의 Frameworks/ 를 썼다.
  # zip 루트에 xcframework 가 바로 놓이는 형식이라 SwiftPM binary target 과 같은 파일을 쓴다.
  # pod 이름(ShopLive)은 1.8.x 와 동일하게 두었다 — 고객 Podfile 은 버전만 바뀐다.
  # 모듈명은 ShopLiveSDK 이며(import ShopLiveSDK), pod 이름과 다른 것은 1.8.x 와 같다.
  spec.source = {
    :http    => "https://github.com/shoplive/shoplive-sdk-ios/releases/download/#{spec.version}/ShopLiveSDK.xcframework.zip",
    :sha256  => "a67ff7e67aa9eb456659e3fb2ee056afd5b7223837673e844af29f23a0e6c898",
    :flatten => false
  }

  spec.license = { :type => 'Copyright', :text => <<-LICENSE
                 Copyright 2021
                 Permission is granted to...
                 LICENSE
              }

  spec.author             = { "Shoplive" => "shoplive-eng@shoplive.cloud" }
  spec.platform     = :ios
  # Xcode 27 대응으로 1.9.0 에서 11.0 에서 올라왔다.
  spec.ios.deployment_target = '15.0'
  spec.swift_version = "5"
  spec.ios.frameworks = 'VideoToolbox'
  spec.vendored_frameworks = 'ShopLiveSDK.xcframework'
end
