Pod::Spec.new do |s|
    s.platform = :ios
    s.ios.deployment_target = '8.0'
    s.name = "PredictIO"
    s.summary = "A battery-optimized SDK for iOS to get real-time updates with context information when a user starts or ends a journey."
    s.description = "predict.io offers mobile developers a battery-optimized SDK to get normalised sensor results. Available for iOS and Android. It gives you real-time updates when a user starts or ends a journey. With this trigger come contextual details for the mode of transportation (car vs. non-car)."
    s.requires_arc = true
    s.version = "5.1.2"
    s.license = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
    s.author = { "predict.io" => "developer@predict.io" }
    s.homepage = 'https://github.com/predict-io/PredictIO-iOS'
    s.frameworks = 'UIKit', 'CoreMotion', 'CoreLocation', 'AdSupport', 'SystemConfiguration'
    s.header_dir = 'PredictIO-iOS'
    s.module_name = 'PredictIO'
    s.source = { :git => 'https://github.com/predict-io/PredictIO-iOS.git', :tag => s.version.to_s.gsub(/^v/, "") }

    # Default to latest Swift version
    s.vendored_framework = 'Frameworks/PredictIO.framework'

    s.dependency "RxSwift", "~> 4.0.0"
    s.dependency "SwiftyJSON", "~> 3.1.0"
    s.dependency "ReachabilitySwift", "~> 4.0.0"
    s.dependency "SwiftyUserDefaults", "~> 3.0.0"
    s.dependency "Realm", "~> 2.10.0"
    s.dependency "RealmSwift", "~> 2.10.0"
end
