Pod::Spec.new do |s|
  s.name             = 'EzPhotoBrowser'
  s.version          = '0.0.4'
  s.summary          = 'Lightweight image browser'
  s.homepage         = 'https://github.com/570262616/EzPhotoBrowser'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhang peng' => 'zhangpeng@ezbuy.com' }
  s.source           = { :git => 'https://github.com/570262616/EzPhotoBrowser.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'EzPhotoBrowser/Classes/**/*'
  s.resource_bundles = {
    'EzPhotoBrowser' => ['EzPhotoBrowser/Assets/*.png']
  }

  s.frameworks = 'UIKit'
  s.dependency 'SDWebImage'
  
end
