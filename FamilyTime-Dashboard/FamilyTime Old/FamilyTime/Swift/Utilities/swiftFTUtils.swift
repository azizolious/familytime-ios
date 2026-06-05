//
//  swiftSwiftFTUtils.swift
//  FamilyTime
//
//  Created by YumyApps on 08/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD
import MBCircularProgressBar
import CCMPopup
import ChatSDK
import ChatProvidersSDK
import MessagingSDK

class SwiftFTUtils: NSObject {
    
    @objc class func image(withTint tintColor: UIColor?, image: UIImage?) -> UIImage? {
        
        let aRect = CGRect(x: 0.0, y: 0.0, width: image?.size.width ?? 0.0, height: image?.size.height ?? 0.0)
        
        var alphaMask: CGImage?
        do {
            UIGraphicsBeginImageContext(aRect.size)
            let c = UIGraphicsGetCurrentContext()

            c?.translateBy(x: 0, y: aRect.size.height)
            c?.scaleBy(x: 1.0, y: -1.0)
            image!.draw(in: aRect)
            alphaMask = c?.makeImage()
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContext(aRect.size)
        let c = UIGraphicsGetCurrentContext()
        image!.draw(in: aRect)

        c?.clip(to: aRect, mask: alphaMask!)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        c?.setFillColorSpace(colorSpace)
        
        c?.setFillColor(tintColor!.cgColor)
        UIRectFillUsingBlendMode(aRect, .normal)

        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img
        
    }
    
    class func widthOf(_ string: String?, with font: UIFont?) -> CGFloat {
        var attributes: [AnyHashable : Any]? = nil
        if let font = font {
            attributes = [
                NSAttributedString.Key.font : font
            ]
        }
        return NSAttributedString(string: string ?? "", attributes: attributes as? [NSAttributedString.Key : Any]).size().width
    }
    
    @objc class func isDeviceiPhoneFamily() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    @objc class func showHUDAdded(to view: UIView?, withText text: String?, animated: Bool) {
        
        let HUD = MBProgressHUD(view: view)
        view?.addSubview(HUD!)

        let tView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        tView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        
        let loader1 = GMDCircleLoader(frame: tView.bounds.insetBy(dx: 10, dy: 10))
        tView.addSubview(loader1)
        loader1.duration = 1.0
        loader1.lineTintColor = UIColorFromRGB(0x3498db)
        loader1.lineWidth = 1.5
        loader1.setup()
        loader1.start()
        
        let loader2 = GMDCircleLoader(frame: loader1.frame.insetBy(dx: 6, dy: 6))
        tView.addSubview(loader2)
        loader2.duration = 1.5
        loader2.lineTintColor = UIColorFromRGB(0xe74c3c)
        loader2.lineWidth = 1.5
        loader2.setup()
        loader2.start()
        
        let loader3 = GMDCircleLoader(frame: loader2.frame.insetBy(dx: 6, dy: 6))
        tView.addSubview(loader3)
        loader3.duration = 0.75
        loader3.lineTintColor = UIColorFromRGB(0xf9c922)
        loader3.lineWidth = 1.5
        loader3.setup()
        loader3.start()
        
        HUD!.color = UIColor.white
        HUD!.margin = 10.0
        HUD!.customView = tView
        HUD!.mode = .customView
        HUD!.show(true)
        
    }
    
    @objc class func hideHUDAdded(to view: UIView?, animated: Bool) {
        
        MBProgressHUD.hideAllHUDs(for: view, animated: animated)
        
    }
    
    @objc class func showSwiftPremiumPopup(on controller: UIViewController?) {
        //MARK: RIZWAN
        let stb = UIStoryboard(name: "Dashboard", bundle: nil)
        let popup = stb.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.PREMIUM_PACKAGE_VC_IDENTIFIER) as? PremiumPackageVC
        popup?.isCommingFromOtherScreens = true
        let transition = CATransition()
        transition.duration = 0.6
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        controller?.navigationController?.view.layer.add(transition, forKey: nil)
        if let popup = popup {
            controller?.navigationController?.pushViewController(popup, animated: true)
        }
    }
    
    @objc class func pushDeviceController(on controller: UIViewController?) {
        let stb = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "DeviceVC") as? DeviceVC
        if let vc = vc {
            controller?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc class func showSyncSettingsPopup(with controller: UIViewController?) {
        let popup = SwiftSyncSettingsPopupController()
        popup.alertTitle = "\("settings_card_5_1".localized)\n\n\n"
        popup.firstParagraph = "schedule_screen_time_sync_popup_content_1".localized
        popup.imagename = "ic_sync-setting"
        popup.color = "blue"
        print(UIScreen.main.bounds.size.height)
        var contentSize: CGSize
        if IS_IPHONE_4() {
            contentSize = CGSize(width: 270.0, height: 420.0)
        } else if IS_IPHONE_5() {
            contentSize = CGSize(width: 270.0, height: 420.0)
        } else if IS_IPHONE_6() {
            contentSize = CGSize(width: 317.0, height: 450.0)
        } else if IS_IPHONE_6_PLUS() {
            contentSize = CGSize(width: 350.0, height: 500.0)
        } else if IS_IPHONE_X() {
            contentSize = CGSize(width: 350.0, height: 500.0)
        } else if IS_IPHONE_8s() {
            contentSize = CGSize(width: 350.0, height: 500.0)
        } else {
            popup.imagename = "ipad_sync-setting"
            contentSize = CGSize(width: 525.0, height: 715.0)
        }
        
        let popup1 = CCMPopupTransitioning.sharedInstance()
        popup1?.destinationBounds = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        popup1?.presentedController = popup
        popup1?.presentingController = controller
        popup1?.backgroundBlurRadius = 0.0
        popup1?.backgroundViewColor = UIColor.black
        popup1?.backgroundViewAlpha = 0.5
        controller!.present(popup, animated: true)
    }
    
    @objc class func showSyncSettingsPopup(with controller: UIViewController?, andMessage message: String?) {
        let popup = SwiftSyncSettingsPopupController()
        popup.alertTitle = "\(String(describing: "settings_card_5_1".localized))\n\n\n"
        popup.firstParagraph = message ?? ""
        popup.imagename = "ic_sync-setting"
        popup.color = "blue"
        var contentSize: CGSize
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            if IS_IPHONE_4() || IS_IPHONE_5() {
                contentSize = CGSize(width: 270.0, height: 420.0)
            } else if IS_IPHONE_6() {
                contentSize = CGSize(width: 317.0, height: 450.0)
            } else {
                contentSize = CGSize(width: 350.0, height: 500.0)
            }
        } else {
            popup.imagename = "ipad_sync-setting"
            contentSize = CGSize(width: 525.0, height: 715.0)
        }
        let popup1 = CCMPopupTransitioning.sharedInstance()
        popup1?.destinationBounds = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        popup1?.presentedController = popup
        popup1?.presentingController = controller
        popup1?.backgroundBlurRadius = 0.0
        popup1?.backgroundViewColor = UIColor.black
        popup1?.backgroundViewAlpha = 0.5
        controller!.present(popup, animated: true)
    }
    
    class func showPopupForCheckedInOut(with controller: UIViewController?, checkedIn checkedin: Bool, image: UIImage?, name: String?, time: String?, accuracy: String?, lat: String?, lon: String?, placeName: String?, color: String?) {
        
        let popup = CheckInOutAlertControllerViewController()
        popup.image = image
        popup.name = name
        popup.time = time
        popup.checkedin = checkedin
        //popup.address = address;
        popup.accuracy = accuracy
        popup.latitude = lat
        popup.longitude = lon
        popup.placeName = placeName
        popup.color = color
        let contentSize: CGSize
        
        if IS_IPHONE_4() {
            contentSize = CGSize(width: 270.0, height: 420.0)
        } else if IS_IPHONE_5() {
            contentSize = CGSize(width: 270.0, height: 420.0)
        } else if IS_IPHONE_6() {
            contentSize = CGSize(width: 317.0, height: 450.0)
        } else if IS_IPHONE_6_PLUS() {
            contentSize = CGSize(width: 350.0, height: 500.0)
        } else if IS_IPHONE_X() {
            contentSize = CGSize(width: 350.0, height: 500.0)
        } else {
            contentSize = CGSize(width: 525.0, height: 715.0)
        }
        
        let popup1 = CCMPopupTransitioning.sharedInstance()
        popup1?.destinationBounds = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        popup1?.presentedController = popup
        popup1?.presentingController = controller
        popup1?.backgroundBlurRadius = 0.0
        popup1?.backgroundViewColor = UIColor.black
        popup1?.backgroundViewAlpha = 0.5
        controller!.present(popup, animated: true)
        
    }
    
    @objc class func showPopupPasscode(with controller: UIViewController?, color: String?) {
        let popup = SwiftPasscodeViewController()
        popup.color = color ?? ""
        var contentSize: CGSize
        if IS_IPHONE_4() {
            contentSize = CGSize(width: 270.0, height: 420.0)
        } else if IS_IPHONE_5() {
            contentSize = CGSize(width: 270.0, height: 420.0);
        } else if IS_IPHONE_6() {
            contentSize = CGSize(width: 317.0, height: 450.0)
        } else if IS_IPHONE_6_PLUS() {
            contentSize = CGSize(width: 350.0, height: 500.0)
        } else if IS_IPHONE_X() {
            contentSize = CGSize(width: 350.0, height: 500.0)
        } else {
            contentSize = CGSize(width: 525.0, height: 715.0)
        }
        
        let popup1 = CCMPopupTransitioning.sharedInstance()
        popup1?.destinationBounds = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        popup1?.presentedController = popup
        popup1?.backgroundBlurRadius = 0.0
        popup1?.backgroundViewColor = UIColor.black
        popup1?.backgroundViewAlpha = 0.5
        popup1?.presentingController = controller
        controller!.present(popup, animated: true)
        
    }
    
    class func showOverSpeedAlert(_ controller: UIViewController?, childID childId: Int, childName: String?, isSon: Bool, startLatitude: Double, startLongitude: Double, endLatitude: Double, endLongitude: Double, speedLimit speedlimit: Int, currentSpeed: Int, address: String?, accuracy: String?, isOverSpeed: Bool, alertTime: String?) {
        
        let popup = SwiftSpeedAlertsViewController()
        var contentSize: CGSize
        if IS_IPHONE_4() {
            contentSize = CGSize(width: 270.0, height: 430.0)
        } else if IS_IPHONE_5() {
            contentSize = CGSize(width: 270.0, height: 450.0)
        } else if IS_IPHONE_6() {
            contentSize = CGSize(width: 317.0, height: 500.0)
        } else if IS_IPHONE_6_PLUS() {
            contentSize = CGSize(width: 350.0, height: 550.0)
        } else if IS_IPHONE_X() {
            contentSize = CGSize(width: 350.0, height: 550.0)
        } else {
            contentSize = CGSize(width: 600.0, height: 815.0)
        }
        
        let popup1 = CCMPopupTransitioning.sharedInstance()
        popup1?.destinationBounds = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        popup1?.presentedController = popup
        popup1?.presentingController = controller
        popup1?.backgroundBlurRadius = 0.0
        popup1?.backgroundViewColor = UIColor.black
        popup1?.backgroundViewAlpha = 0.5
        controller!.present(popup, animated: true)
        
        popup.setupData(childId, childName: childName, isSon: isSon, startLatitude: startLatitude, startLongitude: startLongitude, endLatitude: endLatitude, endLongitude: endLongitude, speedLimit: speedlimit, currentSpeed: currentSpeed, address: address, accuracy: accuracy, isOverSpeed: isOverSpeed, alertTime: alertTime)
        
    }
    
    @objc class func showActivateForfamilyMap(_ controller: UIViewController?) {
        let popup = SwiftSyncSettingsPopupController1()
        popup.alertTitle = "\(String(describing: "FamilyTime Dashboard"))\n\n\n"
        popup.firstParagraph = "Please activate atleast one child to see locations on FamilyLocator. After activating please refresh dashboard and try again.".myModification()
        popup.imagename = "logooooo.png"
        popup.color = "blue"
        var contentSize: CGSize
        if IS_IPHONE_4() {
            contentSize = CGSize(width: 270.0, height: 420.0)
        } else if IS_IPHONE_5() {
            contentSize = CGSize(width: 270.0, height: 420.0)
        } else if IS_IPHONE_6() {
            contentSize = CGSize(width: 317.0, height: 450.0)
        } else if IS_IPHONE_6_PLUS() {
            contentSize = CGSize(width: 350.0, height: 500.0)
        } else if IS_IPHONE_X() {
            contentSize = CGSize(width: 350.0, height: 500.0)
        } else {
            popup.imagename = "logooooo.png"
            contentSize = CGSize(width: 525.0, height: 715.0)
        }
        
        let popup1 = CCMPopupTransitioning.sharedInstance()
        popup1?.destinationBounds = CGRect(x: 0, y: 0, width: contentSize.width * 0.97, height: contentSize.height)
        popup1?.presentedController = popup
        popup1?.presentingController = controller
        popup1?.backgroundBlurRadius = 0.0
        popup1?.backgroundViewColor = UIColor.black
        popup1?.backgroundViewAlpha = 0.5
        controller!.present(popup, animated: true)
        
    }
    
    class func selectTimeZone(with vc: UIViewController?, with index: Int, andTimeZones gmtTimeZones: [AnyHashable]?) {
        let popup = SwiftTimeZonesViewController()
        popup.selectedIndex = index //self.selectedTimeZoneIndex;
        popup.timezones = gmtTimeZones! //self.gmtTimezones;
        popup.isFromPopup = true
        popup.controllerDelegate = vc.self as? SwiftTimeZonesViewControllerDelegate //self;
        let navController = UINavigationController(rootViewController: popup)
        var contentSize: CGSize

        if SwiftFTUtils.isDeviceiPhoneFamily() {
            if IS_IPHONE_4() || IS_IPHONE_5() {
                contentSize = CGSize(width: 270.0, height: 420.0)
            } else if IS_IPHONE_6() {
                contentSize = CGSize(width: 317.0, height: 450.0)
            } else {
                contentSize = CGSize(width: 350.0, height: 500.0)
            }
        } else {
            contentSize = CGSize(width: 525.0, height: 715.0)
        }
        
        let popup1 = CCMPopupTransitioning.sharedInstance()
        popup1?.destinationBounds = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        popup1?.presentedController = navController
        popup1?.presentingController = vc
        popup1?.backgroundBlurRadius = 0.0
        popup1?.backgroundViewColor = UIColor.black
        popup1?.backgroundViewAlpha = 0.5
        vc!.present(navController, animated: true)
    }
    
    class func showActivate(forDeviceNotEnrolled controller: UIViewController?) {
        let popup = SwiftSyncSettingsPopupController1()
        popup.alertTitle = "\(String(describing: "FamilyTime Dashboard".localized))\n\n\n"
        popup.firstParagraph = "Device is not enrolled.".localized
        popup.imagename = "logooooo.png"
        popup.color = "blue"
        var contentSize: CGSize
        if IS_IPHONE_4() {
            contentSize = CGSize(width: 270.0, height: 420.0)
        } else if IS_IPHONE_5() {
            contentSize = CGSize(width: 270.0, height: 420.0)
        } else if IS_IPHONE_6() {
            contentSize = CGSize(width: 317.0, height: 450.0)
        } else if IS_IPHONE_6_PLUS() {
            contentSize = CGSize(width: 350.0, height: 500.0)
        } else if IS_IPHONE_X() {
            contentSize = CGSize(width: 350.0, height: 500.0)
        } else {
            popup.imagename = "logooooo.png"
            contentSize = CGSize(width: 525.0, height: 715.0)
        }
        
        let popup1 = CCMPopupTransitioning.sharedInstance()
        popup1?.destinationBounds = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        popup1?.presentedController = popup
        popup1?.presentingController = controller
        popup1?.backgroundBlurRadius = 0.0
        popup1?.backgroundViewColor = UIColor.black
        popup1?.backgroundViewAlpha = 0.5
        controller!.present(popup, animated: true)
        
    }

}

//MARK:- Global Functions

func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    UIColor(
        red: CGFloat((Float((rgbValue & 0xff0000) >> 16)) / 255.0),
        green: CGFloat((Float((rgbValue & 0x00ff00) >> 8)) / 255.0),
        blue: CGFloat((Float((rgbValue & 0x0000ff) >> 0)) / 255.0),
        alpha: 1.0)
}

func IS_IPHONE_4() -> Bool {
    
    return fabs(Double(UIScreen.main.bounds.size.height) - Double(480)) < Double.ulpOfOne
    
}
func IS_IPHONE_5() -> Bool {
    
    return fabs(Double(UIScreen.main.bounds.size.height) - Double(568)) < Double.ulpOfOne
    
}
func IS_IPHONE_6() -> Bool {
    
    return fabs(Double(UIScreen.main.bounds.size.height) - Double(667)) < Double.ulpOfOne
    
}
func IS_IPHONE_6_PLUS() -> Bool {
    
    return fabs(Double(UIScreen.main.bounds.size.height) - Double(737)) < Double.ulpOfOne
    
}
func IS_IPHONE_X() -> Bool {
    
    return fabs(Double(UIScreen.main.bounds.size.height) - Double(812)) < Double.ulpOfOne
    
}
func IS_IPHONE_8s() -> Bool {
    
    return fabs(Double(UIScreen.main.bounds.size.height) - Double(736.0)) < Double.ulpOfOne
    
}

func IS_IPHONE_XS_MAX() -> Bool {
    return fabs(Double(UIScreen.main.bounds.size.height) - Double(896.0)) < Double.ulpOfOne
}

func IS_IPHONE_12_PRO() -> Bool {
    return fabs(Double(UIScreen.main.bounds.size.height) - Double(844.0)) < Double.ulpOfOne
}

func IS_IPHONE_12_PRO_MAX() -> Bool {
    return fabs(Double(UIScreen.main.bounds.size.height) - Double(926.0)) < Double.ulpOfOne
}

@objcMembers
class ZendeskChatManager: NSObject {
    private static let defaultAccountKey = "3SFP4o0ZGIlzTBHUuO2gfu8Sy4YiwlPp"
    private static let defaultAppId = "754abc37f24b4e7447f58b3d3269f5c15a2c0c2dac8b4327"

    class func initializeChat() {
        Chat.initialize(accountKey: defaultAccountKey, appId: defaultAppId)
    }

    class func initializeChat(accountKey: String) {
        Chat.initialize(accountKey: accountKey, appId: defaultAppId)
    }

    class func trackEvent(_ title: String) {
        let path = VisitorPath(title: title)
        Chat.profileProvider?.trackVisitorPath(path)
    }

    class func updateVisitor(name: String?, email: String?, phoneNumber: String?, note: String?) {
        let visitorInfo = VisitorInfo(
            name: name ?? "",
            email: email ?? "",
            phoneNumber: phoneNumber ?? ""
        )
        let configuration = ChatAPIConfiguration()
        configuration.visitorInfo = visitorInfo
        Chat.instance?.configuration = configuration

        if let note = note, !note.isEmpty {
            Chat.profileProvider?.appendNote(note)
        }
    }

    class func startChat(on navigationController: UINavigationController?) {
        startChat(on: navigationController, event: "Live Chat", preChatFormEnabled: false)
    }

    class func startChat(on navigationController: UINavigationController?, event: String) {
        startChat(on: navigationController, event: event, preChatFormEnabled: false)
    }

    class func startChat(on navigationController: UINavigationController?, event: String, preChatFormEnabled: Bool) {
        initializeChat()
        applyStoredVisitor()
        trackEvent(event)

        let messagingConfiguration = MessagingConfiguration()
        messagingConfiguration.name = "Help Desk"

        let chatConfiguration = ChatConfiguration()
        chatConfiguration.isPreChatFormEnabled = preChatFormEnabled
        chatConfiguration.isChatTranscriptPromptEnabled = false
        chatConfiguration.preChatFormConfiguration = ChatFormConfiguration(
            name: .optional,
            email: .optional,
            phoneNumber: .optional,
            department: .optional
        )

        do {
            let chatEngine = try ChatEngine.engine()
            let viewController = try Messaging.instance.buildUI(
                engines: [chatEngine],
                configs: [messagingConfiguration, chatConfiguration]
            )
            navigationController?.pushViewController(viewController, animated: true)
        } catch {
            print("Unable to start Zendesk chat: \(error.localizedDescription)")
        }
    }

    private class func applyStoredVisitor() {
        let email = UserDefaults.standard.object(forKey: kUserEmail) as? String
        let userName = UserDefaults.standard.string(forKey: "userName")
        updateVisitor(name: userName, email: email, phoneNumber: "", note: nil)
    }
}
