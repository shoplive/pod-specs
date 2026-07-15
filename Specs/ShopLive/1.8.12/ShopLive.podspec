Pod::Spec.new do |spec|
  spec.name         = "ShopLive"
  spec.version      = "1.8.12"
  spec.summary      = "ShopLive SDK for iOS"

  spec.homepage     = "http://shoplive.cloud"
  spec.source   = { :git => 'https://github.com/shoplive/ios-sdk.git', :tag => spec.version }
  spec.license = { :type => 'Copyright', :text => <<-LICENSE
                 Copyright 2021
                 Permission is granted to...
                 LICENSE
              }

  spec.author             = { "Shoplive" => "shoplive-eng@shoplive.cloud" }
  spec.platform     = :ios
  spec.ios.deployment_target = '11.0'
  spec.swift_version = "5"
  spec.ios.frameworks = 'VideoToolbox'
  spec.vendored_frameworks = 'Frameworks/ShopLiveSDK.xcframework'
end
