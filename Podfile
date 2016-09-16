# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.1'
xcodeproj 'Guardioes da Saude.xcodeproj'
pod 'AFNetworking', '~> 2.6.1'
pod 'PTEHorizontalTableView'
pod 'ASHorizontalScrollViewForObjectiveC', '~> 1.0'
pod 'JSONModel'
pod 'Charts', :git => "https://github.com/opswhisperer/Charts.git", :branch => "xcode8_swift23"
pod 'JTCalendar', '~> 2.0'
pod 'Fabric'
pod 'TwitterKit'
pod 'TwitterCore'
pod 'Google/SignIn'
pod 'GoogleMaps'
pod 'Google/Analytics'
pod 'Google/CloudMessaging'
pod 'DownPicker'
pod 'RMDateSelectionViewController'
pod 'MBProgressHUD', '~> 0.9.2'
pod 'Fabric'
pod 'Crashlytics'
pod 'PKHUD'

post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '2.3'
            end
        end
end

target 'Guardioes da Saude' do

end
