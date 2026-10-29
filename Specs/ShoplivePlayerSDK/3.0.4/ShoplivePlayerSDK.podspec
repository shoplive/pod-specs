Pod::Spec.new do |spec|
  spec.name         = "ShoplivePlayerSDK"
  spec.version      = "3.0.4"
  spec.summary      = "Shoplive Player SDK for iOS"

  spec.homepage     = "http://shoplive.cloud"

  # 3.x 시청(Player) 진입점. SwiftPM 의 ShoplivePlayerSDK product 와 같은 구성이다.
  # 1.x 의 ShopLive pod 과는 별개 계열이라 pod 이름·모듈(import ShoplivePlayerSDK)이 다르다.
  spec.source = {
    :http    => "https://github.com/shoplive/shoplive-sdk-ios/releases/download/#{spec.version}/ShoplivePlayerSDK.xcframework.zip",
    :sha256  => "f3ef5db69bb63d88f397b558c04ca3685b2cd624a8096ba56689b34a66a80212",
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
  spec.vendored_frameworks = 'ShoplivePlayerSDK.xcframework'

  # 바이너리가 @rpath 로 링크하는 세 프레임워크. 같은 릴리즈끼리만 맞물리므로 정확히 고정한다.
  spec.dependency 'ShopliveCore', spec.version.to_s
  spec.dependency 'ShopLiveWebRTCHelperSDK', spec.version.to_s
  spec.dependency 'ShopliveWebRTC', spec.version.to_s
end
