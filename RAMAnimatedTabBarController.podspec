Pod::Spec.new do |s|
  s.name = 'RAMAnimatedTabBarController'
  s.version = '2.1.1'
  s.license = 'MIT'
  s.summary = 'RAMAnimatedTabBarController is a Swift module for adding animation to tabbar items.'
  s.homepage = 'https://github.com/Ramotion/animated-tab-bar'
  s.authors = { 'Juri Vasylenko' => 'juri.v@ramotion.com' }
  s.source = { :git => 'https://github.com/Ramotion/animated-tab-bar.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = "RAMAnimatedTabBarController/*.swift", "RAMAnimatedTabBarController/**/*.swift"
end
