//
//  SwiftAppDelegate.swift
//  FamilyTime
//
//  Created by Sana-Ullah-IOS on 12/03/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//

import UIKit
import AuthenticationServices
import Firebase
import IQKeyboardManager
import UserNotifications
import CoreData

let appDeleg = (UIApplication.shared.delegate as! AppDelegate)
var delegate: AppDelegate? = nil

class SwiftAppDelegate: UIResponder {
    
    var window: UIWindow?
    var userDefault: UserDefaults?
    var parent = UserModel()
    var shareModel = LocationShareModel()
    var centerNavController: UINavigationController?
    var drawerCont: SwiftParentDrawer?
    var jasidePanel: JASidePanelController?
    var tokenCallback: deviceTokenReceived?
    var childPush: PushModel?
    var family: FamilyModel?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        ChatStyling.apply()
//        ZendeskChatManager.initializeChat()
        
        //NSSetUncaughtExceptionHandler(<#T##((NSException) -> Void)?##((NSException) -> Void)?##(NSException) -> Void#>)
        
        UserDefaults.standard.set(kYES, forKey: kUpdateParentDataOnce)
        UserDefaults.standard.synchronize()
        
        GIDSignIn.sharedInstance().clientID = "181235234645-bfr0co1kg4bn179g0rgec24tk1374v1t.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().delegate = self
        
        IQKeyboardManager.shared().isEnabled = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        //self.userDefault = [NSUserDefaults standardUserDefaults];
        userDefault = UserDefaults.standard
        
        do {
            if let object = userDefault?.object(forKey: "user") as? [String : Any] {
                parent = try UserModel(dictionary: object)
            }
        } catch {
        }
        
//        register(forRemoteNotifications: application)
        shareModel = LocationShareModel.sharedModel() as! LocationShareModel
        //set Google map key
        GMSServices.provideAPIKey(kGoogleMapKey)
        
        if isUserExists() {
            self.setNavigationbarAppearence(false)
            setupDrawer(0)
        } else {
            self.setNavigationbarAppearence(true)
            setupDrawer(1)
        }
        
        IAPUtility().setupIAP()
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
            appearance.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().standardAppearance = appearance
        }
        
        return true
        
    }
    
    func getUTCFormateDate(_ localDate: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dateString: String? = nil
        if let localDate = localDate {
            dateString = dateFormatter.string(from: localDate)
        }
        print("\(dateString ?? "")")
        return dateString
    }
    
    func isUserExists() -> Bool {
        let user = userDefault?.object(forKey: "user") as? UserModel
        if user != nil || (user?.user_id.count ?? 0) > 0 {
            return true
        }
        return false
    }
    
    func taketoEmailVerificationScreen() -> Bool {
        if !emailVerified() {
            let email = userDefault?.string(forKey: kUserEmail)
            if email != nil || (email?.count ?? 0) > 0 {
                return true
            }
        }
        return false
    }
    
    func emailVerified() -> Bool {
        return ((userDefault?.bool(forKey: kEmailVerified)) != nil)
    }
    
    func setNavigationbarAppearence(_ isWhite: Bool) {
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = kPrimaryColor()
    }
    
    func setNavigationbarAppearence(_ isWhite: Bool, cont: UIViewController?) {
    }
    
    func setUpLocaitonUpdates(_ launchOptions: [AnyHashable : Any]?) {

    }

    func registerRegion(withCircularOverlay region: CLCircularRegion?) {

    }
    
    func addStatusBarImageNamed(_ image: String?, removeOnExit remove: Bool) {

    }
    
    class func appDelegate() -> AppDelegate? {
        
        if delegate == nil {
            delegate = UIApplication.shared.delegate as? AppDelegate
        }
        return delegate
    }
    
    class func getSharedAppDelegateForSwift() -> AppDelegate? {
        if delegate == nil {
            delegate = UIApplication.shared.delegate as? AppDelegate
        }
        return delegate
    }
    
    func showSplash() {
        
        let splash = SplashView(frame: UIScreen.main.bounds)
        splash?.animation = SplashViewAnimationFade
        splash?.delay = 1
        splash?.touchAllowed = false
        splash?.startSplash()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        UserDefaults.standard.set(false, forKey: "HasLaunchedOnce")
        UserDefaults.standard.synchronize()
    }
}
//MARK:- Extension App Delegate

extension SwiftAppDelegate: UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    
    func register(forRemoteNotifications application: UIApplication?) {
        if #available(iOS 10.0, *) {

            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            center.requestAuthorization(options: [.sound, .alert, .badge]) { granted, error in
                if error == nil {
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            
            if ((application?.responds(to: #selector(getter: UIApplication.isRegisteredForRemoteNotifications))) != nil) {
                // iOS 8 Notifications
                application?.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
                application?.registerForRemoteNotifications()
            } else {
                // iOS < 8 Notifications
                application?.registerForRemoteNotifications(
                    matching: [.badge, .alert, .sound])
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("DEVICE TOKEN = \(deviceToken)")

        let newToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("new token for ios 13 = \(newToken)")
        
        if newToken != "" {
            self.userDefault?.setValue(newToken, forKey: kDeviceToken)
        } else {
            self.userDefault?.setValue("", forKey: kDeviceToken)
        }
        userDefault?.synchronize()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if (self.tokenCallback != nil) {
                self.tokenCallback!(newToken)
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to get token, error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        handlePush(userInfo)
    }
    
    func handlePush(_ userInfo: [AnyHashable : Any]?) {

        print("push info \(userInfo ?? [:])")
        let pushtype = (userInfo?["aps"] as? NSObject)?.value(forKey: "pushtype") as? String
        
        if pushtype?.lowercased() == "signup_auth_ios" {
            if !(userDefault?.bool(forKey: kEmailVerified))! {
                userDefault?.set(true, forKey: kEmailVerified)
                let topVC = UIApplication.shared.keyWindow?.rootViewController
                if topVC is UINavigationController {
                    let topNav = topVC as? UINavigationController
                    if (topNav?.viewControllers.count ?? 0) > 0 {
                        if topNav?.viewControllers.last is EmailConfirmationVC {
                            let vc = topNav?.viewControllers.last as? EmailConfirmationVC
                            vc?.callSignupAuthAPI()
                        }
                    }
                }
            }
            return
        }
        
        if !isUserExists() {
            return
        }

        childPush = PushModel()
        childPush?.child_id = (userInfo?["aps"] as? NSObject)?.value(forKey: "senderid") as? String
        let childName = (userInfo?["aps"] as? NSObject)?.value(forKey: "sendername") as? String
        childPush?.lat = (userInfo?["aps"] as? NSObject)?.value(forKey: "lat") as? String
        childPush?.longi = (userInfo?["aps"] as? NSObject)?.value(forKey: "long") as? String
        childPush?.imgsrc = (userInfo?["aps"] as? NSObject)?.value(forKey: "imgsrc") as? String
        childPush?.placeName = (userInfo?["aps"] as? NSObject)?.value(forKey: "placename") as? String
        childPush?.accuracy = (userInfo?["aps"] as? NSObject)?.value(forKey: "accuracy") as? String
        childPush?.gender = (userInfo?["aps"] as? NSObject)?.value(forKey: "gender") as? String

        childPush?.time = (userInfo?["aps"] as? NSObject)?.value(forKey: "pushtime") as? String
        childPush!.descriptionn = (userInfo?["aps"] as? NSObject)?.value(forKey: "alert") as? String
        childPush!.address = (userInfo?["aps"] as? NSObject)?.value(forKey: "address") as? String
        childPush!.push_content = (userInfo?["aps"] as? NSObject)?.value(forKey: "push_content") as? String
        
        let voilatorName = (userInfo?["aps"] as? NSObject)?.value(forKey: "name") as? String

        let alertType = (userInfo?["aps"] as? NSObject)?.value(forKey: "alertType") as? String
        let childId = (userInfo?["aps"] as? NSObject)?.value(forKey: "childId") as? String
        var deviceName = (userInfo?["aps"] as? NSObject)?.value(forKey: "deviceName") as? String
        
        childPush?.speedLimit = (userInfo?["aps"] as? NSObject)?.value(forKey: "speedLimit") as? String
        childPush?.currentSpeed = (userInfo?["aps"] as? NSObject)?.value(forKey: "currentSpeed") as? String

        let alertTime = (userInfo?["aps"] as? NSObject)?.value(forKey: "alertTime") as? String
        
        if (deviceName == nil) {
            deviceName = childName
        }
        
        childPush?.startLatitude = (userInfo?["aps"] as? NSObject)?.value(forKey: "startLatitude") as? String
        childPush?.startLongitude = (userInfo?["aps"] as? NSObject)?.value(forKey: "startLongitude") as? String

        childPush?.endLatitude = (userInfo?["aps"] as? NSObject)?.value(forKey: "endLatitude") as? String
        childPush?.endLongitude = (userInfo?["aps"] as? NSObject)?.value(forKey: "endLongitude") as? String
        
        print("device name = \(String(describing: deviceName)) and userInfo dict = \(String(describing: userInfo))")
        childPush?.childName = childName ?? deviceName
        childPush?.pushType = pushtype
        
        UserDefaults.standard.setValue(childPush?.child_id, forKey: "push_child_id")
        UserDefaults.standard.synchronize()

        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        
        DispatchQueue.main.async {
            
            let state = UIApplication.shared.applicationState
            if !(state == .background || state == .inactive || state == .active) {
                self.setupDrawer(0)
            }
        }
        
        if pushtype == "childPermission" {
            let pickupCont = SwiftPermissionScreenViewControllerPush(nibName: "PermissionScreenViewControllerPush", bundle: nil)
            pickupCont.rowDic = userInfo!
            pickupCont.strDeviceName = deviceName ?? ""
            let activeCont = centerNavController?.viewControllers.last
            pickupCont.modalPresentationStyle = .fullScreen
            activeCont?.present(pickupCont, animated: true)
            
        } else if (pushtype == "ruleActivated") || (pushtype == "ruleDeactivated") {
            var pickupCont: SwiftLimitScreentimeActivatedPushViewController? = nil
            if UI_USER_INTERFACE_IDIOM() == .pad {
                pickupCont = SwiftLimitScreentimeActivatedPushViewController(nibName: "LimitScreentimeActivatedPushViewControllerIPAD", bundle: nil)
            } else {
                pickupCont = SwiftLimitScreentimeActivatedPushViewController(nibName: "LimitScreentimeActivatedPushViewController~iphone", bundle: nil)
            }
            
            print("user info = \(String(describing: userInfo)) and device name = \(String(describing: deviceName))")
            
            pickupCont?.mainTitle = (userInfo?["aps"] as? NSObject)?.value(forKey: "title") as? String ?? ""
            pickupCont?.subTitle = (userInfo?["aps"] as? NSObject)?.value(forKey: "alert") as? String ?? ""

            let activeCont = centerNavController?.viewControllers.last
            pickupCont?.modalPresentationStyle = .fullScreen
            activeCont?.present(pickupCont!, animated: true)
            
        }
        
        if pushtype == "FirstTimeData" {
            NotificationCenter.default.post(
                name: NSNotification.Name("RemoveSteps"),
                object: self)
            NotificationCenter.default.post(name: NSNotification.Name("ReloadHome"), object: nil, userInfo: userInfo)
            
            //Firebase Log Event for activating first child
            let status = UserDefaults.standard.integer(forKey: "setup_complete_key")
            if status == 0 {
                CommonUtility.shared.setFirebaseEvents(eventName: "Child Activated", screenTitle: "ChildActivation", itemName: "Setup completed")
            }
        } else if (pushtype == "pickup") || (pushtype == "panic") {
            let stb = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = stb.instantiateViewController(withIdentifier: "CommonPopupVC") as? CommonPopupVC
            let activeCont = centerNavController?.viewControllers.last
            vc?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            if let vc = vc {
                activeCont?.present(vc, animated: true)
            }
            
        } else if pushtype == "contact_watchlist" {
            SwiftFTUtils.showSwiftPremiumPopup(on: window?.rootViewController)
        } else if pushtype == "app_blocking" {
            SwiftFTUtils.showSwiftPremiumPopup(on: window?.rootViewController)
        } else if (pushtype == "phonelocked") || (pushtype == "phoneunlocked") {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: KPhoneLockStatus), object: nil)
        } else if pushtype == "panic_back" {
            
        } else if (pushtype == "checkin") || (pushtype == "checkout") {
            let stb = UIStoryboard(name: "Dashboard", bundle: nil)

            print("lat = \(String(describing: appDeleg.childPush?.lat)) and long = \(String(describing: appDeleg.childPush?.longi))")
            UserDefaults.standard.setValue("\(String(describing: appDeleg.childPush?.lat))", forKey: "kGeofenceLatitude")
            UserDefaults.standard.setValue("\(String(describing: appDeleg.childPush?.longi))", forKey: "kGeofenceLongitude")
            UserDefaults.standard.synchronize()
            
            let vc = stb.instantiateViewController(withIdentifier: "GeoFencePopupVC") as? GeoFencePopupVC
            let activeCont = centerNavController?.viewControllers.last
            vc?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            if let vc = vc {
                activeCont?.present(vc, animated: true)
            }
            
        } else if (alertType == "normalSpeed") || (alertType == "overSpeed") {
            
            let stb = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = stb.instantiateViewController(withIdentifier: "SpeedPopupVC") as? SpeedPopupVC
            let activeCont = centerNavController?.viewControllers.last
            vc?.modalPresentationStyle = .fullScreen
            activeCont?.present(vc!, animated: true)
            
        } else if alertType == "FirstTimeData" {
            
            NotificationCenter.default.post(name: NSNotification.Name("RemoveSteps"), object: self)
            NotificationCenter.default.post(name: NSNotification.Name("ReloadHome"), object: nil, userInfo: userInfo)
            
        } else if alertType == "All Set" {
            
            NotificationCenter.default.post(
                name: NSNotification.Name("RemoveSteps"),
                object: self)
            
        } else if alertType == "All Set!" {
            
            NotificationCenter.default.post(
                name: NSNotification.Name("RemoveSteps"),
                object: self)
            
        } else {
            
            let title = (userInfo?["aps"] as? NSObject)?.value(forKey: "title") as? String
            if title == "All Set!" {
                NotificationCenter.default.post(
                    name: NSNotification.Name("RemoveSteps"),
                    object: self)
                
            } else if title == "All Set" {
                NotificationCenter.default.post(
                    name: NSNotification.Name("RemoveSteps"),
                    object: self)
            }
        }
    }
    
    func getChildGender(_ childId: Int) -> Bool {
        
        let childModel = family?.children as! [ChildModel]
        for i in 0..<childModel.count {
            if Int(childModel[i].child_id) == childId {
                if childModel[i].gender == "male" {
                    return true
                }
                return false
            }
        }
        return false
    }
}

extension SwiftAppDelegate {
    
 
    func setupDrawer(_ flag: Int) {
        
        DispatchQueue.main.async {
            if flag == 0 {
                let stb = UIStoryboard(name: "Dashboard", bundle: nil)
                //DashboardVC *vc = [stb instantiateViewControllerWithIdentifier:@"DashboardVC"];
                let dashboardRoot = stb.instantiateViewController(withIdentifier: "DashboardRootNavig") as? UINavigationController
                self.setNavigationbarAppearence(false)
                self.centerNavController = dashboardRoot
                
                if self.drawerCont == nil {
                    self.drawerCont = SwiftParentDrawer(nibName: "ParentDrawer", bundle: nil)
                }
                self.drawerCont?.reloadView()

                self.jasidePanel = JASidePanelController()
                self.centerNavController?.isNavigationBarHidden = false
                self.jasidePanel?.leftPanel = self.drawerCont
                self.jasidePanel?.leftFixedWidth = 257
                self.jasidePanel?.centerPanel = self.centerNavController
                
                self.jasidePanel?.allowLeftOverpan = false

                self.window?.rootViewController = self.jasidePanel
                self.window?.makeKeyAndVisible()
                
            } else {
                let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
                let initialNavigVC = storyboard.instantiateViewController(withIdentifier: "LoginNavigVC") as? UINavigationController
                
                if self.taketoEmailVerificationScreen() {
                    let vc = storyboard.instantiateViewController(withIdentifier: "EmailConfirmationVC") as? EmailConfirmationVC
                    //[vc.btnBack setHidden:YES];
                    if let vc = vc {
                        initialNavigVC?.pushViewController(vc, animated: false)
                    }
                    if self.emailVerified() {
                        vc?.callSignupAuthAPI()
                    }
                    
                } else if self.isUserExists() && !(self.userDefault?.bool(forKey: kChildAdded))! {
                    
                    let storyboard = UIStoryboard(name: "Dashboard", bundle: Bundle.main)
                    let vc = storyboard.instantiateViewController(withIdentifier: "AddDeviceVC1") as? AddDeviceVC1
                    initialNavigVC?.viewControllers = [vc].compactMap { $0 }
                    
                } else if self.isUserExists() {
                    self.setupDrawer(0)
                    return
                }
                self.window?.rootViewController = initialNavigVC
                self.window?.makeKeyAndVisible()
            }
        }
    }
    
    /*
    func setupDrawer(_ showDashboard: Int) {
        
        if showDashboard == 0 {
            
            let dashboard = HLStoryboard.loadDashboardVC()
            let centerVC = UINavigationController(rootViewController: dashboard)
            centerVC.isNavigationBarHidden = true
            self.drawerCont = ParentDrawer(nibName: "ParentDrawer", bundle: nil)
            self.drawerCont.reloadView()
            
            self.jasidePanel = JASidePanelController()
            self.jasidePanel.leftFixedWidth = 257
            self.jasidePanel.leftPanel      = self.drawerCont
            self.jasidePanel.centerPanel    = self.centerNavController
            
            self.window.rootViewController = self.jasidePanel
            self.window.makeKeyAndVisible()
            
        } else {
            let initialNavigVC = HLStoryboard.loginNavigationVC()
            let child = HLStoryboard.loadEmailConfirmationVC()
            child.btnBack.isHidden = true
            initialNavigVC.setViewControllers([child], animated: false)
            
            self.window.rootViewController = initialNavigVC
            self.window.makeKeyAndVisible()
            
            if (self.emailVerified()) {
                child.callSignupAuthAPI()
            }
        }
    }
    */
    
}
