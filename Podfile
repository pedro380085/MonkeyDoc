platform :ios, '7.0'

inhibit_all_warnings!

target 'MonkeyDoc' do
  pod 'AFNetworking', '~> 2.6.0'
  pod 'JTSImageViewController'
  pod 'MBProgressHUD'
  pod 'SDWebImage'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      target.build_settings(configuration.name)['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end