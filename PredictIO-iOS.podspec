Pod::Spec.new do |s|
  s.name             = 'PredictIO-iOS'
  s.version          = '0.3.0'
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE.txt" }
  s.homepage         = 'https://github.com/predict-io/PredictIO-iOS'
  s.summary          = 'The parking detection API (patent pending) allows you to retrieve real-time updates on the parking status of a user.'
  s.author           = { "predict.io" => "developer@predict.io" }

  s.source           = { :git => 'https://github.com/predict-io/PredictIO-iOS.git', :tag => s.version.to_s }
  
  s.platform = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'PredictIO-iOS/Classes/**/*'
  s.public_header_files = 'PredictIO-iOS/Classes/**/*.h'
  
s.vendored_library = 'PredictIO-iOS/libPredictIO.a'

  s.frameworks = 'UIKit', 'CoreMotion', 'CoreLocation', 'CoreTelephony', 'AdSupport', 'AVFoundation', 'CoreBluetooth', 'SystemConfiguration', 'ExternalAccessory'

end
