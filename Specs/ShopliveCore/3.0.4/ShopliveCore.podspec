Pod::Spec.new do |spec|
  spec.name         = "ShopliveCore"
  spec.version      = "3.0.4"
  spec.summary      = "Shoplive Core Framework for iOS"

  spec.homepage     = "http://shoplive.cloud"

  # 3.x 는 1.x(ShopLive · ShopliveSDKCommon)와 별개 계열이다. pod 이름·모듈이 모두 다르다.
  # 배포처는 shoplive/shoplive-sdk-ios 릴리즈 에셋이고, SwiftPM binary target 과 같은 zip 을 쓴다.
  # 고객은 이 pod 을 직접 쓰지 않는다 — ShoplivePlayerSDK / ShopliveStreamerSDK 가
  # 의존으로 끌어오고 `@_exported import ShopliveCore` 로 다시 내보낸다.
  spec.source = {
    :http    => "https://github.com/shoplive/shoplive-sdk-ios/releases/download/#{spec.version}/ShopliveCore.xcframework.zip",
    :sha256  => "48ead8931ad910c4b76b4bff5d64cf7b009d4746e4a79cd100945ff2eefc426e",
    :flatten => false
  }

  spec.license = { :type => 'Copyright', :text => <<-LICENSE
                 Copyright 2021
                 Permission is granted to...
                 LICENSE
              }

  spec.author             = { "Shoplive" => "shoplive-eng@shoplive.cloud" }
  spec.platform     = :ios
  spec.ios.deployment_target = '15.0'
  spec.swift_version = "5.9"
  spec.vendored_frameworks = 'ShopliveCore.xcframework'
end
