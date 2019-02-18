
Pod::Spec.new do |s|
  s.name        = "KituraContracts"
  s.version     = "1.1.1"
  s.summary     = "KituraContracts is a library containing type definitions shared by client and server code."
  s.homepage    = "https://github.com/IBM-Swift/KituraContracts"
  s.license     = { :type => "Apache License, Version 2.0" }
  s.author     = "IBM"
  s.module_name  = 'KituraContracts'
  s.osx.deployment_target = "10.11"
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "9.1"
  s.watchos.deployment_target = "2.0"
  s.source   = { :git => "https://github.com/IBM-Swift/KituraContracts.git", :tag => s.version }
  s.source_files = "Sources/**/*.swift"
  s.dependency 'LoggerAPI', '~> 1.7'
end
