
Pod::Spec.new do |s|
  s.name             = 'FriendCircle'
  s.version          = '1.0.0'
  s.summary          = 'FriendCircle like WeChat for iOS'

  s.description      = <<-DESC
FriendCircle like WeChat for iOS.
                       DESC

  s.homepage         = 'https://github.com/roshanman/FriendCircle'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'morenotepad@163.com' => 'morenotepad@163.com' }
  s.source           = { :git => 'https://github.com/roshanman/FriendCircle.git', :tag => s.version.to_s }

  s.resource_bundles = {
    'FriendCircle' => ['FriendCircle/Assets/*.png']
  }
  s.ios.deployment_target = '8.0'
  s.source_files = 'FriendCircle/Classes/**/*'
  s.dependency 'Kingfisher', '~> 3.13.1'
  s.dependency 'Then'
  s.dependency 'KMPlaceholderTextView'
end
