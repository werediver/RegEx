Pod::Spec.new do |s|
  s.name             = 'RegEx'
  s.version          = '0.2.0'
  s.summary          = 'Wrapper for NSRegularExpression'

  s.homepage         = 'https://github.com/werediver/RegEx'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Raman Fedaseyeu' => 'werediver@gmail.com' }
  s.source           = { :git => 'https://github.com/werediver/RegEx.git', :tag => 'v' + s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Sources/**/*.{swift,h}'
  
  s.frameworks = 'Foundation'
end
