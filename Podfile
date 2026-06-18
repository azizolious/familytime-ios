# Uncomment this line to define a global platform for your project
platform :ios, '17.0'
use_frameworks!

target 'FamilyTime' do
    


pod 'GoogleMaps', '~> 8.4'
pod 'MBProgressHUD', '~> 0.9.2'
pod 'CCMPopup'
pod 'MSCellAccessory'
pod 'IQKeyboardManager'



pod 'HGCircularSlider', '~> 2.0.0'
pod 'Motis', '~>1.4.0'
pod 'GoogleSignIn', '~>3.0.0'
pod 'SwiftyJSON'

#---SANA PODS---//

pod 'MBCircularProgressBar'
pod 'Toast-Swift', '~> 4.0.0'

pod 'ActiveLabel'



pod 'NewPopMenu', '~> 2.0'

pod 'DropDown'
pod 'RangeSeekSlider'

#---REALM CRASH FIXING ON XCODE 11---#

#pod 'RealmSwift', '~> 3.20.0'

#---REALM CRASH FIXING ON XCODE 11---//



end

target 'FamilyTimeTests' do

end

post_install do |installer|
  # Floor every pod's deployment target (several podspecs declare pre-iOS-10
  # minimums that break under the current SDK; app min is iOS 17).
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
  # NewPopMenu ships `@available(iOS 10.0, *)` on enum cases that have associated
  # values, which the current Swift compiler rejects. The app's minimum target is
  # iOS 17, so these iOS-10 availability annotations are meaningless — strip them
  # so the pod compiles. (Durable across `pod install`.)
  haptics = File.join(__dir__, 'Pods/NewPopMenu/PopMenu/Classes/Helpers/Haptics.swift')
  if File.exist?(haptics)
    begin
      File.chmod(0644, haptics)
      text = File.read(haptics)
      text = text.gsub(/^[ \t]*@available\(iOS 10\.0, \*\)[ \t]*\n/, '')
      File.write(haptics, text)
    rescue => e
      Pod::UI.warn "Could not patch NewPopMenu Haptics.swift: #{e.message}"
    end
  end
end

