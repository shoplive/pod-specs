Pod::Spec.new do |s|
  s.name             = 'ShopliveSDK'
  s.version          = '1.0.0'
  s.summary          = 'Shoplive iOS SDK'
  s.description      = 'Shoplive iOS SDK for live commerce integration.'

  s.homepage         = 'https://github.com/shoplive/ios-sdk'
  s.license          = { :type => 'Commercial', :text => 'Copyright (c) Shoplive. All rights reserved.' }
  s.author           = { 'Shoplive' => 'support@shoplive.com' }

  # GitHub Release asset로 배포되는 XCFramework zip
  s.source           = {
    :http => "https://github.com/shoplive/ios-sdk/releases/download/#{s.version}/ShopliveSDK.xcframework.zip"
  }

  s.platform         = :ios
  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.9'

  # XCFramework 지정
  s.vendored_frameworks = 'ShopliveSDK.xcframework'
end
