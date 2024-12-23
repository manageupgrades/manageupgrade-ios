Pod::Spec.new do |s|
  s.name             = 'ManageUpgrades'
  s.version          = '1.0.0'
  s.summary          = 'A Swift package for managing app updates and maintenance mode'
  s.description      = <<-DESC
  ManageUpgrades is a Swift package that helps you manage app updates and maintenance mode in your iOS applications.
  It provides features like force updates, optional updates, and maintenance mode handling.
                       DESC

  s.homepage         = 'https://github.com/yourusername/manageupgrades_ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'your.email@example.com' }
  s.source           = { :git => 'https://github.com/yourusername/manageupgrades_ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'ios/Classes/**/*'
  
  s.frameworks = 'UIKit', 'SafariServices'
  s.dependency 'Flutter'
end
