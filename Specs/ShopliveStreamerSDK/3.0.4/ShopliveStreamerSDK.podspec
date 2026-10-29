Pod::Spec.new do |spec|
  spec.name         = "ShopliveStreamerSDK"
  spec.version      = "3.0.4"
  spec.summary      = "Shoplive Streamer SDK for iOS"

  spec.homepage     = "http://shoplive.cloud"

  # 3.x 송출(Streamer) 진입점. SwiftPM 의 ShopliveStreamerSDK product 와 같은 구성이다.
  spec.source = {
    :http    => "https://github.com/shoplive/shoplive-sdk-ios/releases/download/#{spec.version}/ShopliveStreamerSDK.xcframework.zip",
    :sha256  => "c26cb34aa3ebe5212e8fe4816b402d91b6256c22ee42f544322c4ecba0f1dd19",
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
