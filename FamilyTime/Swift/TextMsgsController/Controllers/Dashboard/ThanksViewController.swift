////
////  ThanksViewController.swift
////  FamilyTime
////
////  Created by Usama-Apps on 07/06/2022.
////  Copyright © 2022 YumyApps. All rights reserved.
////
//
//import UIKit
////import ZendeskProviderSDK
////import ChatSDK
////import ZendeskSDK
////import MessagingSDK
////import ChatProvidersSDK
//
//class ThanksViewController: UIViewController {
//
//    //MARK: - IBOutlets
//    @IBOutlet weak var thankyouLable: UILabel!
//    @IBOutlet weak var featuresLabel: UILabel! {
//        didSet {
//            let requiredText = "Some Features are still missing. To Get More Exciting features please contact our customer support agent."
//            let changedAttributedText = requiredText.attributedString(["Some Features are still missing."], color: UIColor.init(hexString: "#20A0E9"), font: UIFont.appFont(type: UIFont.FontType.SemiBold, size: 14.0))
//            self.featuresLabel.attributedText = changedAttributedText
//        }
//    }
//    
//    @IBOutlet weak var liveChatButtonOutlet: UIButton! {
//        didSet {
//            liveChatButtonOutlet.layer.cornerRadius = 9.0
//            liveChatButtonOutlet.layer.masksToBounds = true
//        }
//    }
//    
//    
//    //MARK: - Varibales
//    var delegate = UIApplication.shared.delegate as? AppDelegate
//    
//    
//    //MARK: - ViewLifeCycles
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
////        ZDKConfig.instance().initialize(withAppId: "754abc37f24b4e7447f58b3d3269f5c15a2c0c2dac8b4327", zendeskUrl: "https://familytime.zendesk.com", clientId: "mobile_sdk_client_6bd39d87391a41bd5860")
//        Chat.initialize(accountKey: "3SFP4o0ZGIlzTBHUuO2gfu8Sy4YiwlPp", appId: "754abc37f24b4e7447f58b3d3269f5c15a2c0c2dac8b4327")
//    }
//    
//    
//    //MARK: - IBActions
//    @IBAction func cancelButtonPressed(_ sender: Any) {
//        self.dismiss(animated: true)
//    }
//    
//    
//    @IBAction func liveChatButtonPressed(_ sender: Any) {
////        self.openZendeskChat()
//        
//        do {
//                   try self.startChat()
//               } catch {
//                   print("Failed to start chat: \(error)")
//               }
//        
//    }
//    
//    //MARK: - Helper Functions
////    private func openZendeskChat() {
////        
////        let strUserEmail = UserDefaults.standard.object(forKey: kUserEmail) as? String
////               let visitorInfo = VisitorInfo(name: delegate?.parent.name ?? "", email: strUserEmail ?? "", phoneNumber: "")
////               
////               let chatConfiguration = ChatAPIConfiguration()
////               chatConfiguration.visitorInfo = visitorInfo
////               
////               do {
////                   let chatEngine = try ChatEngine.engine()
////                   let messagingConfiguration = MessagingConfiguration()
////                   messagingConfiguration.name = "Chat Bot"
////                   
////                   let viewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [messagingConfiguration, chatConfiguration])
////                   
////                   self.navigationController?.pushViewController(viewController, animated: true)
////               } catch {
////                   print("Error initializing chat: \(error)")
////               }
//        
//        
//        
////        let strUserEmail = UserDefaults.standard.object(forKey: kUserEmail) as? String
////        let identity = ZDKAnonymousIdentity()
////        identity.name = delegate?.parent.name ?? ""
////        identity.email = strUserEmail
////        ZDKConfig.instance().userIdentity = identity
////        ZendeskChatManager.initializeChat()
////            user?.phone = ""
////            user?.name = self.delegate?.parent.name ?? ""
////            user?.email = strUserEmail
////        })
////    }
//    private func startChat() throws {
//        let userName = UserDefaults.standard.string(forKey: "userName") ?? ""
//          let strUserEmail = UserDefaults.standard.object(forKey: kUserEmail) as? String
//          let visitorInfo = VisitorInfo(name: userName, email: strUserEmail ?? "", phoneNumber: "")
//          let chatAPIConfiguration = ChatAPIConfiguration()
//          chatAPIConfiguration.visitorInfo = visitorInfo
//          
//          Chat.instance?.configuration = chatAPIConfiguration
//          
//          let messagingConfiguration = MessagingConfiguration()
//          messagingConfiguration.name = "Chat Bot"
//          
//          let chatConfiguration = ChatConfiguration()
//          chatConfiguration.isPreChatFormEnabled = true
//          
//          let chatEngine = try ChatEngine.engine()
//          let viewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [messagingConfiguration, chatConfiguration])
//          
//          self.navigationController?.pushViewController(viewController, animated: true)
//      }
//}
