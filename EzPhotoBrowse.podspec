Pod::Spec.new do |s|
  s.name             = 'EzPhotoBrowse'
  s.version          = '0.0.3'
  s.summary          = 'Lightweight image browser'
  s.homepage         = 'https://github.com/570262616/EzPhotoBrowse'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhang peng' => 'zhangpeng@ezbuy.com' }
  s.source           = { :git => 'https://github.com/570262616/EzPhotoBrowse.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'EzPhotoBrowse/Classes/**/*'
  s.resource_bundles = {
    'EzPhotoBrowse' => ['EzPhotoBrowse/Assets/*.png']
  }

  s.frameworks = 'UIKit'
  s.dependency 'SDWebImage'
  
end