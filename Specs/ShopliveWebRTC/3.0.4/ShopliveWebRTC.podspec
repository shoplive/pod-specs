Pod::Spec.new do |spec|
  spec.name         = "ShopliveWebRTC"
  spec.version      = "3.0.4"
  spec.summary      = "WebRTC Framework bundled with the Shoplive iOS SDK"

  spec.homepage     = "http://shoplive.cloud"

  # SwiftPM 의 WebRTC binary target 에 대응한다. pod 이름을 "WebRTC" 로 하지 않은 것은
  # CocoaPods trunk(공식 CDN)에 같은 이름의 구 Google WebRTC pod 이 이미 있어서다.
  # 담긴 프레임워크와 모듈명은 그대로 WebRTC 다.
  spec.source = {
    :http    => "https://github.com/shoplive/shoplive-sdk-ios/releases/download/#{spec.version}/WebRTC.xcframework.zip",
    :sha256  => "30d43c4797d8e5eba0a98cc40e09dedb2b02582bd0e9f80d4978bf711daf6901",
    :flatten => false
  }

  # Shoplive 바이너리가 아니라 WebRTC 프로젝트(BSD) 빌드라, xcframework 에 동봉된 라이선스를 그대로 쓴다.
  spec.license = { :type => 'BSD', :file => 'WebRTC.xcframework/LICENSE.md' }

  spec.author             = { "Shoplive" => "shoplive-eng@shoplive.cloud" }
  spec.platform     = :ios
  spec.ios.deployment_target = '15.0'
  spec.vendored_frameworks = 'WebRTC.xcframework'
end
