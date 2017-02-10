Pod::Spec.new do |s|
  # 1
    s.platform = :ios
    s.ios.deployment_target = '8.0'
    s.name = "PredictIO"
    s.summary = "A battery-optimized SDK for iOS to get real-time updates with context information when a user starts or ends a journey."
    s.requires_arc = true

  # 2
    s.version = "3.3.0"

  # 3
    s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  # 4
    s.author           = { "predict.io" => "developer@predict.io" }

  # 5
    s.homepage         = 'https://github.com/predict-io/PredictIO-iOS'

  # 6
    s.source           = { :git => 'https://github.com/predict-io/PredictIO-iOS.git', :tag => s.version.to_s }

  #7
    s.public_header_files = 'PredictIO-iOS/**/*.h'
    s.source_files = 'PredictIO-iOS/**/*.h', 'PredictIO-iOS/Classes/*.m'
    s.preserve_paths = 'PredictIO-iOS/**/*.h'
    s.vendored_library = 'PredictIO-iOS/libPredictIOSDK.a'
    s.frameworks = 'UIKit', 'CoreMotion', 'CoreLocation', 'CoreTelephony', 'AdSupport', 'AVFoundation', 'CoreBluetooth', 'SystemConfiguration'
    s.module_map = 'PredictIO-iOS/PredictIO.modulemap'
    s.header_dir = 'PredictIO-iOS'
    s.module_name = 'PredictIO'
    s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }

  #8
    s.description = "predict.io offers mobile developers a battery-optimized SDK to get normalised sensor results. Available for iOS and Android. It gives you real-time updates when a user starts or ends a journey. With this trigger come contextual details for the mode of transportation (car vs. non-car)."

end
