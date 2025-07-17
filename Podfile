# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

#platform :ios, '13.0'

abstract_target 'BackpackerPods' do
  use_frameworks!

  pod 'CountryPickerView'
  pod 'PhoneNumberKit', '~> 4.0'
  pod 'Alamofire'
  pod 'Cosmos', '~> 23.0'
  pod 'FSCalendar'

  target 'Backpacker'
  target 'BackpackerHire'
end
post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
    end
end
