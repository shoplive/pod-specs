Pod::Spec.new do |spec|
  spec.name         = "ShopliveStreamerSDK"
  spec.version      = "3.0.5"
  spec.summary      = "Shoplive Streamer SDK for iOS"

  spec.homepage     = "http://shoplive.cloud"

  # 3.x 송출(Streamer) 진입점. SwiftPM 의 ShopliveStreamerSDK product 와 같은 구성이다.
  spec.source = {
    :http    => "https://github.com/shoplive/shoplive-sdk-ios/releases/download/#{spec.version}/ShopliveStreamerSDK.xcframework.zip",
    :sha256  => "8bd19a85338f36ded6af03e53b282160a9f87c6a6a1dca82de8bd6ee5707068c",
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
  spec.vendored_frameworks = 'ShopliveStreamerSDK.xcframework'

  # 바이너리가 @rpath 로 링크하는 세 프레임워크. 같은 릴리즈끼리만 맞물리므로 정확히 고정한다.
  spec.dependency 'ShopliveCore', spec.version.to_s
  spec.dependency 'ShopLiveWebRTCHelperSDK', spec.version.to_s
  spec.dependency 'ShopliveWebRTC', spec.version.to_s
end
