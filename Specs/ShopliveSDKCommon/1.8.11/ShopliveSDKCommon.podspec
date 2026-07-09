Pod::Spec.new do |spec|
  spec.name         = "ShopliveSDKCommon"
  spec.version      = "1.8.11"
  spec.summary      = "ShopLive Common Framework for iOS"

  spec.homepage     = "http://shoplive.cloud"
  spec.source   = { :git => 'https://github.com/shoplive/common-ios.git', :tag => spec.version.to_s }
  spec.license = { :type => 'Copyright', :text => <<-LICENSE
                 Copyright 2021
                 Permission is granted to...
                 LICENSE
                 }

  spec.author             = { "Shoplive" => "shoplive-eng@shoplive.cloud" }
  spec.platform     = :ios
  spec.ios.deployment_target = '11.0'
  spec.swift_version = "5"
  spec.vendored_frameworks = 'Frameworks/ShopliveSDKCommon.xcframework'
end
