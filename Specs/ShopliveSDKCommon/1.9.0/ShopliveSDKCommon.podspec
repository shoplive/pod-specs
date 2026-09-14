Pod::Spec.new do |spec|
  spec.name         = "ShopliveSDKCommon"
  spec.version      = "1.9.0"
  spec.summary      = "ShopLive Common Framework for iOS"

  spec.homepage     = "http://shoplive.cloud"

  # 1.9.0 부터 배포처가 shoplive/shoplive-sdk-ios 의 릴리즈 에셋으로 바뀌었다.
  # 이 pod 은 프레임워크를 둘(ShopliveSDKCommon · ShopliveAPI) 담는데 CocoaPods 의
  # :http source 는 아카이브를 하나만 받으므로, SwiftPM 이 쓰는 모듈별 zip 과 별개로
  # 두 프레임워크를 함께 넣은 Pod 전용 zip 을 릴리즈에 따로 올린다.
  #   SwiftPM : ShopliveSDKCommon.xcframework.zip · ShopliveAPI.xcframework.zip (각각)
  #   Pod     : ShopliveSDKCommon-pod.zip (둘 다)
  # 이 에셋은 release.sh 의 MODULES 목록 밖이라 릴리즈 생성 후 gh release upload 로 붙인다.
  spec.source = {
    :http    => "https://github.com/shoplive/shoplive-sdk-ios/releases/download/#{spec.version}/ShopliveSDKCommon-pod.zip",
    :sha256  => "96d3bc8d71428f3c1451753fb314c306135685db54952128dd15aee0eb1e0cd6",
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
  spec.vendored_frameworks = 'ShopliveSDKCommon.xcframework', 'ShopliveAPI.xcframework'
end
