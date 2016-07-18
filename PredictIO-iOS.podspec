Pod::Spec.new do |s|
  s.name             = 'PredictIO-iOS'
  s.version          = '0.1.0'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage         = 'https://github.com/predict-io/PredictIO-iOS'
  s.summary          = 'The parking detection API (patent pending) allows you to retrieve real-time updates on the parking status of a user.'
  s.author           = { 'haseebOptini' => 'ahaseeb91@gmail.com' }

  s.source           = { :git => 'https://github.com/predict-io/PredictIO-iOS.git', :tag => s.version.to_s }
  
  s.platform = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'PredictIO-iOS/Classes/**/*'
  s.public_header_files = 'PredictIO-iOS/Classes/**/*.h'
  
  s.frameworks = 'UIKit', 'CoreMotion', 'CoreLocation', 'CoreTelephony', 'AdSupport', 'AVFoundation', 'CoreBluetooth', 'SystemConfiguration', 'ExternalAccessory'

end
