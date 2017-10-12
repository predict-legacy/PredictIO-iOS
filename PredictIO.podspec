Pod::Spec.new do |s|
    s.platform = :ios
    s.ios.deployment_target = '8.0'
    s.name = "PredictIO"
    s.summary = "A battery-optimized SDK for iOS to get real-time updates with context information when a user starts or ends a journey."
    s.description = "predict.io offers mobile developers a battery-optimized SDK to get normalised sensor results. Available for iOS and Android. It gives you real-time updates when a user starts or ends a journey. With this trigger come contextual details for the mode of transportation (car vs. non-car)."
    s.requires_arc = true
    s.version = "4.9.0-beta.1"
    s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
    s.author           = { "predict.io" => "developer@predict.io" }
    s.homepage         = 'https://github.com/predict-io/PredictIO-iOS'
    s.public_header_files = 'PredictIO-iOS/**/*.h'
    s.source_files = 'PredictIO-iOS/**/*.h', 'PredictIO-iOS/Classes/*.m'
    s.preserve_paths = 'PredictIO-iOS/**/*.h'
    s.frameworks = 'UIKit', 'CoreMotion', 'CoreLocation', 'AdSupport', 'SystemConfiguration', 'Accelerate'
    s.header_dir = 'PredictIO-iOS'
    s.module_name = 'PredictIO'

    # Default to latest Swift version
    # s.source = { http: "https://s3-eu-west-1.amazonaws.com/predict-io-apps/io.predict.ios.sdk/PredictIO-v#{s.version}.swift4.0.zip" }
    s.source           = { :git => 'https://github.com/predict-io/PredictIO-iOS.git', :branch => 'sdk5' }
    s.vendored_frameworks = 'PredictIO.framework'

    s.subspec 'Swift3.1' do |sp|
      # sp.source = { http: "https://s3-eu-west-1.amazonaws.com/predict-io-apps/io.predict.ios.sdk/PredictIO-v#{s.version}.swift3.1.zip" }
      sp.vendored_frameworks = 'Frameworks/swift3.1/PredictIO.framework'
    end

    s.subspec 'Swift4.0' do |sp|
      # sp.source = { http: "https://s3-eu-west-1.amazonaws.com/predict-io-apps/io.predict.ios.sdk/PredictIO-v#{s.version}.swift4.0.zip" }
      sp.vendored_frameworks = 'Frameworks/swift4.0/PredictIO.framework'
    end

    s.dependency "Alamofire", "~> 4.5.0"
    s.dependency "Moya/RxSwift", "~> 8.0.0"
    s.dependency "RxSwift", "~> 3.6.2"
    s.dependency "RxCocoa", "~> 3.6.2"
    s.dependency "RxCoreMotion", "~> 1.2.0"
    s.dependency "RxSwiftExt", "~> 2.5.0"
    s.dependency "SwiftyJSON", "~> 3.1.0"
    s.dependency "ReachabilitySwift", "~> 4.0.0"
    s.dependency "SwiftyUserDefaults", "~> 3.0.0"
    s.dependency "Realm", "~> 2.10.0"
    s.dependency "RealmSwift", "~> 2.10.0"
end
