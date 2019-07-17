Pod::Spec.new do |s|
  s.name                  = 'JudoKitObjC'
  s.version               = '7.1.0'
  s.summary               = 'Judo Pay Full iOS Client Kit'
  s.homepage              = 'https://www.judopay.com/'
  s.license               = 'MIT'
  s.author                = { "James Lappin" => 'james.lappin@judopayments.com' }
  s.source                = { :git => 'https://github.com/Judopay/JudoKitObjC.git', :tag => s.version.to_s }
  
  s.documentation_url     = 'https://judopay.github.io/JudoKitObjC/'

  s.ios.deployment_target = '8.0'
  s.requires_arc          = true
  s.source_files          = 'Source/**/*.{m,h}'

  s.dependency 'DeviceDNA'
  s.dependency 'TrustKit'
  s.dependency 'ZappMerchantLib', :git => 'https://github.com/Judopay/ZappMerchantLib-R2-iOS.git', :branch => 'feature/carthage_support'

  s.frameworks            = 'CoreLocation', 'Security', 'CoreTelephony'
  s.pod_target_xcconfig   = { 'FRAMEWORK_SEARCH_PATHS'   => '$(inherited) ${PODS_ROOT}/DeviceDNA/Source' }

end
