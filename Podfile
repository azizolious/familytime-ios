# Uncomment this line to define a global platform for your project
platform :ios, '17.0'
use_frameworks!

target 'FamilyTime' do
    


# P4 (June 2026): pod set reduced to the two still used after the P3 legacy
# teardown — GoogleMaps (AppDelegate) + SwiftyJSON (UserProfile model).
# GoogleSignIn is now SPM 7.x. The 11 removed pods (MBProgressHUD, CCMPopup,
# IQKeyboardManager, HGCircularSlider, Motis, MBCircularProgressBar, Toast-Swift,
# ActiveLabel, NewPopMenu, DropDown, RangeSeekSlider) had zero callers.
pod 'GoogleMaps', '~> 8.4'
pod 'SwiftyJSON'



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

