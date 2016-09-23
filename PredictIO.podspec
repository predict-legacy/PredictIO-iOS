Pod::Spec.new do |s|
  # 1
    s.platform = :ios
    s.ios.deployment_target = '7.0'
    s.name = "PredictIO"
    s.summary = "The parking detection API (patent pending) allows you to retrieve real-time updates on the parking status of a user."
    s.requires_arc = true

  # 2
    s.version = "3.0.1"

  # 3
    s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  # 4
    s.author           = { "predict.io" => "developer@predict.io" }

  # 5
    s.homepage         = 'https://github.com/predict-io/PredictIO-iOS'

  # 6
    s.source           = { :git => 'https://github.com/predict-io/PredictIO-iOS.git', :tag => s.version.to_s }

  #7
    s.source_files = ['PredictIO-iOS/Classes/*.h']
    s.preserve_paths = ['PredictIO-iOS/PredictIO.modulemap', 'LICENSE']
    s.header_dir = 'PredictIO-iOS/Classes'
    s.public_header_files = 'PredictIO-iOS/Classes/*.h'
    s.vendored_library = 'PredictIO-iOS/libPredictIO.a'
    s.frameworks = 'UIKit', 'CoreMotion', 'CoreLocation', 'CoreTelephony', 'AdSupport', 'AVFoundation', 'CoreBluetooth', 'SystemConfiguration', 'ExternalAccessory'

  #8
    s.description = "You may use the parking updates to trigger events or notifications specific to your use case. The parking detection service stack leverages all available phone sensors. Sensor usage is extremely battery optimized. Incremental battery consumption does not exceed 10% in typical cases. Also we strongly suggest you ensure inclusion of LBS in your T&C and Privacy Policies. By using this API you explicitly agree to our license agreement, terms and conditions and privacy policy. If you are unsure about any item, please contact us at support@parktag.mobi."

    s.ios.module_map = 'PredictIO-iOS/PredictIO.modulemap'
    s.module_name = 'PredictIO'
    s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
end
