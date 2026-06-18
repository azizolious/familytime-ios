////
////  SwiftHelpViewController.swift
////  FamilyTime
////
////  Created by YumyApps on 22/10/2021.
////  Copyright © 2021 YumyApps. All rights reserved.
////
//
//import UIKit
//import IQKeyboardManager
////import ZendeskProviderSDK
////import ZendeskSDK
//import ChatSDK
//import ChatProvidersSDK
//import MessagingAPI
//import MessagingSDK
//import ZendeskCoreSDK
//import SupportProvidersSDK
//import SupportSDK
//import SDKConfigurations
//import SwiftUI
//
//class SwiftHelpViewController: UIViewController, UIAlertViewDelegate {
//        
//    @IBOutlet weak var btnGiveFeedback: ImageCenterButton!
//    @IBOutlet weak var btnHelpCentre: ImageCenterButton!
//    @IBOutlet weak var btnLiveChat: ImageCenterButton!
//    @IBOutlet weak var btnMyTickets: ImageCenterButton!
//    @IBOutlet weak var lblHowCanWehelp: UILabel!
//    
//    
//    var createTicket = UIButton()
//    var myTickets = UIButton()
//    var helpCenter = UIButton()
//    var imageView = UIImageView()
//    var descLabel = UILabel()
//    
//    let CHAT_VC_BTN_BACKGROUND = UIColor(white: 0.95, alpha: 1.0)
//    let CHAT_BTN_TITLE_NORMAL = UIColor(white: 0.2627, alpha: 1.0)
//    let CHAT_BTN_TITLE_HIGHLIGHT = UIColor(white: 0.2627, alpha: 0.3)
//    let CHAT_BTN_BORDER = UIColor(white: 0.8470, alpha: 1.0)
//    
//    let CHAT_BUTTON_CORNER_RADIUS: CGFloat = 4.0
//    let CHAT_BUTTON_BORDER_WIDTH: CGFloat = 1.0
//    
//    var delegate = UIApplication.shared.delegate as? AppDelegate
//    
//    // MARK: Chat Properties
//    private let service = LiveChatService.shared
//    
//    private var messages: [ChatMessage] = []
//    
//    private var conversation: Conversation?
//    
//    private var messageText: String = ""
//    
//    private var hostingController:
//    UIHostingController<LiveChatView>?
//    
//    private var typingTask:
//    Task<Void, Never>?
//
//    private var isTyping = false
//    
//    private var currentPage = 1
//
//    private var hasMoreMessages = true
//
//    private var isLoadingMore = false
//    
//    private var paginationAnchorMessageId: Int?
//
//    private var liveChatMessageListenerId: UUID?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        Zendesk.initialize(appId: "754abc37f24b4e7447f58b3d3269f5c15a2c0c2dac8b4327", clientId: "mobile_sdk_client_6bd39d87391a41bd5860", zendeskUrl: "https://familytime.zendesk.com")
//        Support.initialize(withZendesk: Zendesk.instance)
//        
////        ZDKConfig.instance().initialize(withAppId: "754abc37f24b4e7447f58b3d3269f5c15a2c0c2dac8b4327", zendeskUrl: "https://familytime.zendesk.com", clientId: "mobile_sdk_client_6bd39d87391a41bd5860")
//        Chat.initialize(accountKey: "3SFP4o0ZGIlzTBHUuO2gfu8Sy4YiwlPp", appId: "754abc37f24b4e7447f58b3d3269f5c15a2c0c2dac8b4327")
//
//        let strUserEmail = UserDefaults.standard.object(forKey: kUserEmail) as? String
//        let userName = UserDefaults.standard.string(forKey: "userName")
//
//        let anonymous = Identity.createAnonymous(name: userName,
//                        email: strUserEmail)
//        
//        Zendesk.instance?.setIdentity(anonymous)
//
////
////        let identity = ZDKAnonymousIdentity()
////        identity.name = userName ?? ""
////        identity.email = strUserEmail
////        ZDKConfig.instance().userIdentity = identity
////
//        ZendeskChatManager.initializeChat()
//        
//        ZendeskChatManager.updateVisitor(name: nil, email: nil, phoneNumber: nil, note: nil)
//        
////        
//        
//        
//        self.title = "help_desk_title".localized
//        
//        Task {
//            
//            observeRealtimeMessages()
//        }
//
//    }
//    
//    deinit {
//        LiveChatSocketManager.shared.removeMessageListener(
//            liveChatMessageListenerId
//        )
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        ZendeskChatManager.trackEvent("Help Screen")
//        
//        IQKeyboardManager.shared().isEnabled = false
//        
//        btnHelpCentre.titleLabel?.numberOfLines = 2
//        btnMyTickets.titleLabel?.numberOfLines = 2
//        btnLiveChat.titleLabel?.numberOfLines = 2
//        btnGiveFeedback.titleLabel?.numberOfLines = 2
//        
//        btnHelpCentre.setTitle("help_desk_button_3".localized, for: .normal)
//        btnMyTickets.setTitle("help_desk_button_2".localized, for: .normal)
//        btnLiveChat.setTitle("help_desk_button_4".localized, for: .normal)
//        btnGiveFeedback.setTitle("help_desk_button_feedback".localized, for: .normal)
//        btnGiveFeedback.imageView?.contentMode = .scaleAspectFit
//        lblHowCanWehelp.text = "help_content_1".localized
//        btnGiveFeedback.setImage(UIImage(named: "give_feedback"), for: .normal)
//        
//    }
//    
//    override func viewWillDisappear(
//        _ animated: Bool
//    ) {
//        super.viewWillDisappear(animated)
//        
//        if self.isMovingFromParent {
//            
//            if let dashboard =
//                navigationController?
//                .viewControllers
//                .first(where: {
//                    $0 is DashboardVC
//                }) as? DashboardVC {
//                
//                dashboard.hideFloatingChatButton()
//            }
//        }
//    }
//    
//    func presetData() {
//        // track the event
//
//        ZendeskChatManager.trackEvent("Chat button pressed: (pre-set data)")
//        // before starting the chat set the visitor data
//
//        let strUserEmail = UserDefaults.standard.object(forKey: kUserEmail) as? String
//        
//        ZendeskChatManager.updateVisitor(name: nil, email: nil, phoneNumber: nil, note: nil)
//        
//        ZendeskChatManager.startChat(on: navigationController, event: "Help Chat Started")
//        
//    }
//    
//    func setupUI() {
//        
//        var font: UIFont?
//        var imageSize: CGFloat
//        var leftMargin: CGFloat
//        var buttonsMargin: CGFloat
//        
//        if UIScreen.isIphone4() {
//            
//            font = UIFont(name: "OpenSans-Light", size: 13)
//            imageSize = 72
//            leftMargin = 50.0
//            buttonsMargin = 15.0
//            
//        } else if UIScreen.isIphone5() {
//            
//            font = UIFont(name: "OpenSans-Light", size: 14)
//            imageSize = 72
//            leftMargin = 50.0
//            buttonsMargin = 20.0
//            
//        } else if UIScreen.isIphone6() {
//            
//            font = UIFont(name: "OpenSans-Light", size: 16)
//            imageSize = 72
//            leftMargin = 50.0
//            buttonsMargin = 20.0
//            
//        } else if UIScreen.isIphone6Plus() {
//            
//            font = UIFont(name: "OpenSans-Light", size: 17)
//            imageSize = 72
//            leftMargin = 50.0
//            buttonsMargin = 20.0
//            
//        } else if UIScreen.isIphoneX() {
//            
//            font = UIFont(name: "OpenSans-Light", size: 17)
//            imageSize = 72
//            leftMargin = 50.0
//            buttonsMargin = 20.0
//            
//        } else {
//            
//            font = UIFont(name: "OpenSans-Light", size: 23)
//            imageSize = 166
//            leftMargin = 150.0
//            buttonsMargin = 25.0
//            
//        }
//        
//        createTicket = UIButton(type: .custom)
//        createTicket.frame = CGRect(x: leftMargin, y: view.bounds.midY - 20, width: view.bounds.width - (leftMargin * 2.0), height: 50.0)
//        createTicket.setTitle("help_desk_button_1".localized, for: .normal)
//        createTicket.backgroundColor = RGBCOLOR(20, 148, 200, 1)
//        createTicket.titleLabel?.font = font
//        view.addSubview(createTicket)
//        
//        self.myTickets = UIButton(type: .custom)
//        myTickets.frame = CGRect(x: leftMargin, y: createTicket.frame.maxY + buttonsMargin, width: view.bounds.width - (leftMargin * 2.0), height: 50.0)
//        myTickets.setTitle("help_desk_button_2".localized, for: .normal)
//        myTickets.backgroundColor = RGBCOLOR(20, 148, 200, 1)
//        myTickets.titleLabel?.font = font
//        view.addSubview(myTickets)
//        
//        helpCenter = UIButton(type: .custom)
//        helpCenter.frame = CGRect(x: leftMargin, y: myTickets.frame.maxY + buttonsMargin, width: view.bounds.width - (leftMargin * 2.0), height: 50.0)
//        helpCenter.setTitle("help_desk_button_3".localized, for: .normal)
//
//        helpCenter.backgroundColor = RGBCOLOR(20, 148, 200, 1)
//        helpCenter.titleLabel?.font = font
//        view.addSubview(helpCenter)
//        
//        createTicket.addTarget(self, action: #selector(handleCreateTicket), for: .touchUpInside)
//        myTickets.addTarget(self, action: #selector(handleMyTickets), for: .touchUpInside)
//        helpCenter.addTarget(self, action: #selector(handleHelpCenter), for: .touchUpInside)
//        
//        createTicket.layer.borderColor = RGBCOLOR(18, 123, 167, 1).cgColor
//        createTicket.layer.borderWidth = 1.0
//        createTicket.layer.cornerRadius = 3.0
//
//        myTickets.layer.borderColor = RGBCOLOR(18, 123, 167, 1).cgColor
//        myTickets.layer.borderWidth = 1.0
//        myTickets.layer.cornerRadius = 3.0
//        
//        helpCenter.layer.borderColor = RGBCOLOR(18, 123, 167, 1).cgColor
//        helpCenter.layer.borderWidth = 1.0
//        helpCenter.layer.cornerRadius = 3.0
//
//        imageView = UIImageView(image: UIImage(named: "help_center_logo"))
//        imageView.frame = CGRect(x: view.bounds.midX - imageSize / 2.0, y: 64 + imageSize / 2.0, width: imageSize, height: imageSize)
//        self.view.addSubview(imageView)
//        
//        descLabel = UILabel(frame: CGRect(x: leftMargin, y: imageView.frame.maxY , width: view.bounds.width - leftMargin * 2.0, height: createTicket.frame.minY - (imageView.frame.maxY )))
//        descLabel.backgroundColor = UIColor.clear
//        descLabel.font = createTicket.titleLabel?.font
//        descLabel.text = "help_desk_content".localized
//        descLabel.numberOfLines = 0
//        descLabel.textAlignment = .center
//        self.view.addSubview(self.descLabel)
//    
//    }
//    
//    @IBAction func giveFeedBack(_ sender: UIButton) {
//        self.handleCreateTicket()
//    }
//
//    @IBAction func myTickets(_ sender: UIButton) {
//        self.handleMyTickets()
//    }
//    
//    @IBAction func helpCentreBtn(_ sender: UIButton) {
//        self.handleHelpCenter()
//    }
//
//    @IBAction func liveChatBtn(_ sender: UIButton) {
//        
//        navigationController?.navigationBar.isHidden = true
//        
//        createChatScreen()
//        
//        LiveVisitorManager.shared.updateScreen(
//            "chat"
//        )
//        
//        navigationController?.pushViewController(
//            hostingController!,
//            animated: true
//        )
//        
//        setupChat()
//        //        self.noPreChatForm()
//    }
//    
//    @objc func handleCreateTicket() {
//
//        let requestController = RequestUi.buildRequestUi(with: [])
//        
//        // Adjusts for safe area insets
//        requestController.modalPresentationStyle = .formSheet
//        
//        self.present(requestController, animated: true)
//
////        self.navigationController?.pushViewController(requestController, animated: true)
//        
////        ZDKRequests.presentRequestCreation(with: self)
//        
//    }
//    
//    @objc func handleMyTickets() {
//        
//        let requestListController = RequestUi.buildRequestList()
//        self.navigationController?.pushViewController(requestListController, animated: true)
//
//    }
//    
//    @objc func handleHelpCenter() {
//        
//        let helpCenter = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [])
//        self.navigationController?.pushViewController(helpCenter, animated: true)
//    }
//    
//    func allPreChatFieldsOptional() {
//        
////        IQKeyboardManager.shared().isEnabled = true
//        // track the event
//        ZendeskChatManager.trackEvent("Chat button pressed: (all fields optional)")
//        
//        // start a chat in a new modal
//        ZendeskChatManager.startChat(on: navigationController, event: "Help Chat Started")
//        
//    }
//    
//    func allPreChatFieldsRequired() {
//        // track the event
//        ZendeskChatManager.trackEvent("Chat button pressed: (all fields required)")
//        
//        // Start a chat pushed on to the current navigation controller
//        // with session config making all pre-chat fields required
//        
//        ZendeskChatManager.startChat(on: navigationController, event: "Help Chat Started")
//        
//    }
//    
//    func noPreChatForm() throws{
//
////        IQKeyboardManager.shared().isEnabled = true
//        let strUserEmail = UserDefaults.standard.object(forKey: kUserEmail) as? String
//        let userName = UserDefaults.standard.string(forKey: "userName") ?? ""
//        let visitorInfo = VisitorInfo(name: userName, email: strUserEmail ?? "", phoneNumber: "")
//        let chatAPIConfiguration = ChatAPIConfiguration()
//        chatAPIConfiguration.visitorInfo = visitorInfo
//        
//        Chat.instance?.configuration = chatAPIConfiguration
//        
//        let messagingConfiguration = MessagingConfiguration()
//        messagingConfiguration.name = "Help Desk"
//        
//        let chatConfiguration = ChatConfiguration()
//        chatConfiguration.isPreChatFormEnabled = true
//        
//        let chatEngine = try ChatEngine.engine()
//        let viewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [messagingConfiguration, chatConfiguration])
//        
//        self.navigationController?.pushViewController(viewController, animated: true)
//        // track the event
//        ZendeskChatManager.trackEvent("Help Chat Started")
////        
////        // start a chat pushed on to the current navigation controller
////        // with session config setting all pre-chat fields as not required
////        
////        })
//        
//    }
//    
//    func openModalViewController() {
//        // track the event
//        ZendeskChatManager.trackEvent("Modal View Controller opened")
//        
//        // simple app navigation simulation
//        let vc = SwiftViewController(nibName: nil, bundle: nil)
//        vc.modal = true
//        let navController = UINavigationController(rootViewController: vc)
//        navController.modalPresentationStyle = .formSheet
//        
//        let rightButton = UIBarButtonItem(
//            title: "back_button".localized,
//            style: UIBarButtonItem.Style.plain,
//            target: self,
//            action: #selector(dismissVC))
//        vc.navigationItem.rightBarButtonItem = rightButton
//        self.present(navController, animated: true)
//        
//    }
//    
//    func pushViewController() {
//        // track the event
//        ZendeskChatManager.trackEvent("View Controller pushed")
//
//        // simple app navigation simulation
//        let vc = SwiftViewController(nibName: nil, bundle: nil)
//        vc.nested = true
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    @objc func dismissVC() {
//        self.dismiss(animated: true)
//        
//    }
//    
//    func buildButton(withFrame frame: CGRect, andTitle title: String?) -> UIButton? {
//        // button helper
//        let button = UIButton(frame: frame)
//        button.backgroundColor = UIColor.white
//        button.layer.borderColor = CHAT_BTN_BORDER.cgColor
//        button.layer.borderWidth = CHAT_BUTTON_BORDER_WIDTH
//        button.layer.cornerRadius = CHAT_BUTTON_CORNER_RADIUS
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        button.setTitleColor(CHAT_BTN_TITLE_NORMAL, for: .normal)
//        button.setTitleColor(CHAT_BTN_TITLE_HIGHLIGHT, for: .highlighted)
//        
//        button.setTitleColor(CHAT_BTN_TITLE_HIGHLIGHT, for: .disabled)
//        button.setTitle(title, for: .normal)
//        button.setTitle(title, for: .highlighted)
//        button.titleLabel?.textAlignment = .center
//        button.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
//        return button
//        
//    }
//    
////MARK: - Account key
//    
//    func updateAccountKey() {
//
//        let alert = UIAlertView(title: "Update account key", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Update")
//        alert.alertViewStyle = .plainTextInput
//        let textField = alert.textField(at: 0)
//        textField?.placeholder = "Account key"
//        textField?.accessibilityIdentifier = "SampleViewController.accounttDialog.textField"
//        alert.show()
//    }
//    
//    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
//        
//        switch buttonIndex {
//        case 0:
//            // cancelled
//            break
//        default:
//            let textField = alertView.textField(at: 0)
//
//            if (textField?.text?.count ?? 0) > 0 {
//
////                ZendeskChatManager.initializeChat(accountKey: textField?.text)
//                Chat.initialize(accountKey: textField!.text!)
//            }
//            break
//            
//        }
//    }
//    
//}
//
//// MARK: - Chat Setup
//extension SwiftHelpViewController {
//    
//    private func setupChat() {
//        
//        Task {
//            
//            do {
//                
//                // Existing conversation
//                
//                if let existingConversationId =
//                    LiveVisitorManager.shared.visitor?.conversationId {
//                    
//                    self.conversation = Conversation(
//                        id: existingConversationId,
//                        status: nil,
//                        createdAt: nil
//                    )
//                    
//                } else {
//                    
//                    // Create new conversation
//                    
//                    let newConversation =
//                    try await service.createConversation()
//                    
//                    self.conversation = newConversation
//                }
//                
//                await loadMessages()
//                
//            } catch {
//                
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
//
//// MARK: - Load Messages
//extension SwiftHelpViewController {
//
//    private func loadMessages() async {
//
//        guard let conversationId = conversation?.id else {
//            return
//        }
//
//        do {
//
//            let fetchedMessages =
//            try await service.fetchMessages(
//                conversationId: conversationId
//            )
//
//            DispatchQueue.main.async {
//
//                self.messages = fetchedMessages
//
//                self.hasMoreMessages =
//                fetchedMessages.count >=
//                LiveChatConstants.initialMessageLimit
//
//                print("MESSAGES:", self.messages.count)
//
//                self.updateChatView()
//                
//                self.markConversationRead()
//            }
//
//        } catch {
//
//            print(error.localizedDescription)
//        }
//    }
//}
//
//// MARK: - Send Message
//extension SwiftHelpViewController {
//
//    private func sendMessage() {
//
//        guard let conversationId = conversation?.id else {
//            return
//        }
//
//        guard !messageText
//            .trimmingCharacters(
//                in: .whitespacesAndNewlines
//            )
//            .isEmpty else {
//            return
//        }
//
//        let text = messageText
//
//        messageText = ""
//        
//        stopTyping()
//        
//        var tempMessage = ChatMessage(
//            id: nil,
//            conversationId: conversationId,
//            senderType: "visitor",
//            senderName: "You",
//            message: text,
//            isRead: true,
//            createdAt: ""
//        )
//        
//        tempMessage.status = .sending
//        
//        // INSTANT UI APPEND
//        messages.append(tempMessage)
//
//        updateChatView()
//
//        Task {
//
//            do {
//
//                var message =
//                try await service.sendMessage(
//                    conversationId: conversationId,
//                    message: text
//                )
//                
//                // KEEP same local identity
//                
//                message.localId =
//                tempMessage.localId
//                
//                message.status = .sent
//
//                DispatchQueue.main.async {
//                    
//                    if let index =
//                        self.messages.firstIndex(
//                            where: {
//                                $0.localId ==
//                                tempMessage.localId
//                            }
//                        ) {
//                        
//                        self.messages[index] =
//                        message
//                    }
//                    
//                    self.updateChatView()
//                }
//
//            } catch {
//                
//                DispatchQueue.main.async {
//                    
//                    if let index =
//                        self.messages.firstIndex(
//                            where: {
//                                $0.localId ==
//                                tempMessage.localId
//                            }
//                        ) {
//                        
//                        self.messages[index]
//                            .status = .failed
//                    }
//                    
//                    self.updateChatView()
//                }
//                
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
//
//// MARK: - Create Chat Screen
//extension SwiftHelpViewController {
//
//    private func createChatScreen() {
//
////        let chatView = LiveChatView(
////            
////            messages: messages,
////            
////            messageText: messageText,
////            
////            isLoadingMore: isLoadingMore,
////            
////            hasMoreMessages: hasMoreMessages,
////                        
////            onTextChange: { text in
////                
////                self.messageText = text
////                
////                self.handleTyping(text)
////            },
////            
////            onSend: {
////                
////                self.sendMessage()
////            },
////            
////            onBack: {
////                                
////                self.navigationController?
////                    .popViewController(
////                        animated: true
////                    )
////                
////                self.navigationController?
////                    .navigationBar.isHidden = false
////            },
////            
////            onLoadMore: {
////                
////                self.loadMoreMessages()
////            }
////        )
////
////        hostingController =
////        UIHostingController(
////            rootView: chatView
////        )
//    }
//}
//
//// MARK: - Update Chat View
//extension SwiftHelpViewController {
//
//    private func updateChatView() {
//
////        let chatView = LiveChatView(
////            
////            messages: messages,
////            
////            messageText: messageText,
////            
////            isLoadingMore: isLoadingMore,
////            
////            hasMoreMessages: hasMoreMessages,
////                        
////            onTextChange: { text in
////                
////                self.messageText = text
////                
////                self.handleTyping(text)
////            },
////            
////            onSend: {
////                
////                self.sendMessage()
////            },
////            
////            onBack: {
////                
////                self.navigationController?
////                    .popViewController(
////                        animated: true
////                    )
////                
////                self.navigationController?
////                    .navigationBar.isHidden = false
////            },
////            
////            onLoadMore: {
////                
////                self.loadMoreMessages()
////            }
////        )
//
////        hostingController?.rootView = chatView
//    }
//}
//
//extension SwiftHelpViewController {
//    
//    private func observeRealtimeMessages() {
//
//        guard liveChatMessageListenerId == nil else {
//            return
//        }
//
//        liveChatMessageListenerId =
//        LiveChatSocketManager.shared.addMessageListener {
//            [weak self] message in
//            
//            guard let self else {
//                return
//            }
//            
//            DispatchQueue.main.async {
//                
//                print("""
//                
//                =========================
//                REALTIME MESSAGE RECEIVED
//                =========================
//                ID:
//                \(message.id ?? 0)
//                
//                MESSAGE:
//                \(message.message ?? "")
//                =========================
//                
//                """)
//                
//                // Prevent duplicates
//                
//                let exists = self.messages.contains {
//                    $0.id == message.id
//                }
//                
//                if exists {
//                    
//                    print("MESSAGE ALREADY EXISTS")
//                    
//                    return
//                }
//                
//                // Optional:
//                // only append if belongs to current conversation
//                
//                if message.conversationId != self.conversation?.id {
//                    
//                    print("MESSAGE FOR OTHER CONVERSATION")
//                    
//                    return
//                }
//                
//                self.messages.append(message)
//                
//                print("TOTAL MESSAGES:", self.messages.count)
//                
//                self.updateChatView()
//                
//                self.markConversationRead()
//            }
//        }
//    }
//}
//
//extension SwiftHelpViewController {
//    
//    private func markConversationRead() {
//        
//        guard let conversationId =
//                conversation?.id else {
//            return
//        }
//        
//        Task {
//            
//            do {
//                
//                try await service.markConversationRead(
//                    conversationId: conversationId
//                )
//                
//                DispatchQueue.main.async {
//                    
//                    LiveVisitorManager
//                        .shared
//                        .unreadCount = 0
//                }
//                
//                print("""
//                
//                =========================
//                CONVERSATION MARKED READ
//                =========================
//                ID:
//                \(conversationId)
//                =========================
//                
//                """)
//                
//            } catch {
//                
//                print("""
//                
//                =========================
//                MARK READ FAILED
//                =========================
//                ERROR:
//                \(error.localizedDescription)
//                =========================
//                
//                """)
//            }
//        }
//    }
//}
//
//extension SwiftHelpViewController {
//    
//    private func handleTyping(
//        _ text: String
//    ) {
//        
//        guard let conversationId =
//                conversation?.id else {
//            return
//        }
//        
//        // Ignore empty text
//        
//        let trimmed =
//        text.trimmingCharacters(
//            in: .whitespacesAndNewlines
//        )
//        
//        if trimmed.isEmpty {
//            
//            stopTyping()
//            
//            return
//        }
//        
//        // Already typing
//        
//        if !isTyping {
//            
//            isTyping = true
//            
//            Task {
//                
//                do {
//                    
//                    try await service.sendTyping(
//                        conversationId: conversationId,
//                        isTyping: true
//                    )
//                    
//                } catch {
//                    
//                    print(error.localizedDescription)
//                }
//            }
//        }
//        
//        // Reset debounce timer
//        
//        typingTask?.cancel()
//        
//        typingTask = Task {
//            
//            try? await Task.sleep(
//                for: .seconds(2)
//            )
//            
//            await MainActor.run {
//                
//                self.stopTyping()
//            }
//        }
//    }
//    
//    private func stopTyping() {
//        
//        guard let conversationId =
//                conversation?.id else {
//            return
//        }
//        
//        guard isTyping else {
//            return
//        }
//        
//        isTyping = false
//        
//        Task {
//            
//            do {
//                
//                try await service.sendTyping(
//                    conversationId: conversationId,
//                    isTyping: false
//                )
//                
//            } catch {
//                
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    private func loadMoreMessages() {
//        
//        guard !isLoadingMore else {
//            return
//        }
//        
//        guard hasMoreMessages else {
//            return
//        }
//        
//        guard let firstMessageId =
//                messages.first?.id else {
//            return
//        }
//        
//        isLoadingMore = true
//        
//        updateChatView()
//        
//        Task {
//            
//            do {
//                
//                let older =
//                try await service.fetchMessages(
//                    conversationId: conversation?.id ?? 0,
//                    before: firstMessageId
//                )
//                
//                paginationAnchorMessageId =
//                messages.first?.id
//                
//                DispatchQueue.main.async {
//                    
//                    if older.isEmpty {
//                        
//                        self.hasMoreMessages = false
//                        
//                    } else {
//                        
//                        self.messages.insert(
//                            contentsOf: older,
//                            at: 0
//                        )
//
//                        self.hasMoreMessages =
//                        older.count >=
//                        LiveChatConstants.paginationMessageLimit
//                    }
//                    
//                    self.isLoadingMore = false
//                    
//                    self.updateChatView()
//                }
//                
//            } catch {
//                
//                DispatchQueue.main.async {
//                    
//                    self.isLoadingMore = false
//                    
//                    self.updateChatView()
//                }
//                
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
