
Pod::Spec.new do |s|
  s.name        = "KituraContracts"
  s.version     = "0.0.21"
  s.summary     = "A library containing type definitions shared by client and server Kitura code."
  s.homepage    = "https://github.com/IBM-Swift/KituraContracts"
  s.license     = { :type => "Apache License, Version 2.0" }
  s.author     = "IBM"
  s.module_name  = 'KituraContracts'
  s.requires_arc = true
  s.ios.deployment_target = "10.0"
  s.source   = { :git => "https://github.com/IBM-Swift/KituraContracts.git", :tag => s.version }
  s.source_files = "Sources/KituraContracts/*.swift", "Sources/KituraContracts/CodableQuery/*.swift"
  s.pod_target_xcconfig =  {
        'SWIFT_VERSION' => '4.0.3',
  }
  s.dependency 'LoggerAPI', '~> 1.7.2'
end