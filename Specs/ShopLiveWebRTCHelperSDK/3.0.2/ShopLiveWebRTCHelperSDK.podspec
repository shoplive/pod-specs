Pod::Spec.new do |spec|
  spec.name         = "ShopLiveWebRTCHelperSDK"
  spec.version      = "3.0.2"
  spec.summary      = "Shoplive WebRTC signalling helper for iOS"

  spec.homepage     = "http://shoplive.cloud"

  # Player · Streamer 가 공유하는 시그널링 헬퍼. 공개 API 가 아니라 구현 세부지만,
  # 두 모듈의 swiftinterface 가 import 하므로 빠지면 고객 쪽 모듈 검증이 깨진다.
  spec.source = {
    :http    => "https://github.com/shoplive/shoplive-sdk-ios/releases/download/#{spec.version}/ShopLiveWebRTCHelperSDK.xcframework.zip",
    :sha256  => "66238f7dcb0ffe7bc0eb8cd2bbdf617302d9f0585f41e543a5409daf49cd293f",
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
  spec.vendored_frameworks = 'ShopLiveWebRTCHelperSDK.xcframework'

  # 같은 릴리즈에서 빌드된 바이너리끼리만 섞이도록 버전을 정확히 고정한다.
  spec.dependency 'ShopliveWebRTC', spec.version.to_s
end
