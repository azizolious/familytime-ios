//
//  SwiftViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 03/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

//

import UIKit

class SwiftViewController: UIViewController, UIAlertViewDelegate {
    
    let CHAT_BUTTON_MARGIN: CGFloat = 30.0
    let CHAT_BUTTON_HEIGHT: CGFloat = 44.0
    let CHAT_BUTTON_SPACING: CGFloat = 54.0
    let CHAT_BUTTON_CORNER_RADIUS: CGFloat = 4.0
    let CHAT_BUTTON_BORDER_WIDTH: CGFloat = 1.0
    let CHAT_CONTENT_HEIGHT: CGFloat = 410.0
    
    let CHAT_VC_BTN_BACKGROUND = UIColor(white: 0.95, alpha: 1.0)
    let CHAT_BTN_TITLE_NORMAL = UIColor(white: 0.2627, alpha: 1.0)
    let CHAT_BTN_TITLE_HIGHLIGHT = UIColor(white: 0.2627, alpha: 0.3)
    let CHAT_BTN_BORDER = UIColor(white: 0.8470, alpha: 1.0)
    
    var scrollView = UIScrollView()
    var modal = false
    var nested = false

    override func viewDidLoad() {
        super.viewDidLoad()
//        ZendeskChatManager.initializeChat()
        title = "Chat SDK Sample"
        view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        
        scrollView = UIScrollView(frame: view.frame)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
        
        var buttonFrame = CGRect(
            x: CHAT_BUTTON_MARGIN,
            y: CHAT_BUTTON_MARGIN,
            width: CGFloat(floor(view.frame.size.width - 2 * CHAT_BUTTON_MARGIN)),
            height: CHAT_BUTTON_HEIGHT)
        
        var button = buildButton(withFrame: buttonFrame, andTitle: "Chat (all fields optional)")
        button?.accessibilityIdentifier = "ModalChatAllFieldsOptional"
//        button?.addTarget(self, action: #selector(allPreChatFieldsOptional), for: .touchUpInside)
        if let button = button {
            scrollView.addSubview(button)
        }
        buttonFrame = CGRect(
            x: CHAT_BUTTON_MARGIN,
            y: CGFloat(floor(buttonFrame.origin.y + CHAT_BUTTON_SPACING)),
            width: CGFloat(floor(view.frame.size.width - 2 * CHAT_BUTTON_MARGIN)),
            height: CHAT_BUTTON_HEIGHT)
        button = buildButton(withFrame: buttonFrame, andTitle: "Chat (all fields required)")
        button?.accessibilityIdentifier = "PushedChatAllFieldsRequired"
//        button?.addTarget(self, action: #selector(allPreChatFieldsRequired), for: .touchUpInside)
        scrollView.addSubview(button!)
        
        buttonFrame = CGRect(
            x: CHAT_BUTTON_MARGIN,
            y: CGFloat(floor(buttonFrame.origin.y + CHAT_BUTTON_SPACING)),
            width: CGFloat(floor(view.frame.size.width - 2 * CHAT_BUTTON_MARGIN)),
            height: CHAT_BUTTON_HEIGHT)
        button = buildButton(withFrame: buttonFrame, andTitle: "Chat (no pre-chat form)")
        button?.accessibilityIdentifier = "PushedChatNoPreChatForm"
//        button?.addTarget(self, action: #selector(noPreChatForm), for: .touchUpInside)
        scrollView.addSubview(button!)
        
        buttonFrame = CGRect(
            x: CHAT_BUTTON_MARGIN,
            y: CGFloat(floor(buttonFrame.origin.y + CHAT_BUTTON_SPACING)),
            width: CGFloat(floor(view.frame.size.width - 2 * CHAT_BUTTON_MARGIN)),
            height: CHAT_BUTTON_HEIGHT)
        button = buildButton(withFrame: buttonFrame, andTitle: "Chat (pre-set data)")
        button?.accessibilityIdentifier = "PushedChatPreSetData"
//        button?.addTarget(self, action: #selector(presetData), for: .touchUpInside)
        scrollView.addSubview(button!)
        
        buttonFrame = CGRect(
            x: CHAT_BUTTON_MARGIN,
            y: CGFloat(floor(buttonFrame.origin.y + CHAT_BUTTON_SPACING)),
            width: CGFloat(floor(view.frame.size.width - 2 * CHAT_BUTTON_MARGIN)),
            height: CHAT_BUTTON_HEIGHT)
        button = buildButton(withFrame: buttonFrame, andTitle: "Open modal view controller")
        button?.accessibilityIdentifier = "PushModalViewController"
        button?.backgroundColor = CHAT_VC_BTN_BACKGROUND
        button?.addTarget(self, action: #selector(openModalViewController), for: .touchUpInside)
        scrollView.addSubview(button!)
        
        buttonFrame = CGRect(
            x: CHAT_BUTTON_MARGIN,             y: CGFloat(floor(buttonFrame.origin.y + CHAT_BUTTON_SPACING)),
            width: CGFloat(floor(view.frame.size.width - 2 * CHAT_BUTTON_MARGIN)),
            height: CHAT_BUTTON_HEIGHT)
        button = buildButton(withFrame: buttonFrame, andTitle: "Push view controller")
        button?.accessibilityIdentifier = "PushViewController"
        button?.backgroundColor = CHAT_VC_BTN_BACKGROUND
        button?.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
        scrollView.addSubview(button!)
        
        buttonFrame = CGRect(
            x: CHAT_BUTTON_MARGIN,
            y: CGFloat(floor(buttonFrame.origin.y + CHAT_BUTTON_SPACING)),
            width: CGFloat(floor(view.frame.size.width - 2 * CHAT_BUTTON_MARGIN)),
            height: CHAT_BUTTON_HEIGHT)
        button = buildButton(withFrame: buttonFrame, andTitle: "Override account key")
        button?.accessibilityIdentifier = "UpdateAccountKey"
        button?.backgroundColor = CHAT_VC_BTN_BACKGROUND
        button?.addTarget(self, action: #selector(updateAccountKey), for: .touchUpInside)
        scrollView.addSubview(button!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: CHAT_CONTENT_HEIGHT)
        scrollView.contentInset = .zero
    }
    
    func buildButton(withFrame frame: CGRect, andTitle title: String?) -> UIButton? {
        // button helper
        let button = UIButton(frame: frame)
        button.backgroundColor = UIColor.white
        button.layer.borderColor = CHAT_BTN_BORDER.cgColor
        button.layer.borderWidth = CHAT_BUTTON_BORDER_WIDTH
        button.layer.cornerRadius = CHAT_BUTTON_CORNER_RADIUS
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(CHAT_BTN_TITLE_NORMAL, for: .normal)
        button.setTitleColor(CHAT_BTN_TITLE_HIGHLIGHT, for: .highlighted)
        button.setTitleColor(CHAT_BTN_TITLE_HIGHLIGHT, for: .disabled)
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .highlighted)
        button.titleLabel?.textAlignment = .center
        button.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        return button
    }
    
//    @objc func allPreChatFieldsOptional() {
//
//        ZendeskChatManager.trackEvent("Chat button pressed: (all fields optional)")
//        ZendeskChatManager.startChat(on: navigationController, event: "Help Chat Started", preChatFormEnabled: true)
//        // start a chat in a new modal
//        ZendeskChatManager.startChat(on: navigationController, event: "Help Chat Started")
//    }
    
//    @objc func allPreChatFieldsRequired() {
//        // track the event
//        ZendeskChatManager.trackEvent("Chat button pressed: (all fields required)")
//        // Start a chat pushed on to the current navigation controller
//        ZendeskChatManager.startChat(on: navigationController, event: "Help Chat Started")
//    }
    
//    @objc func noPreChatForm() {
//        // track the event
//        ZendeskChatManager.trackEvent("Chat button pressed: (no pre-chat form)")
//        // start a chat pushed on to the current navigation controller
//        // with session config setting all pre-chat fields as not required
//        ZendeskChatManager.startChat(on: navigationController, event: "Help Chat Started")
//    }
    
//    @objc func presetData() {
//        // track the event
//        ZendeskChatManager.trackEvent("Chat button pressed: (pre-set data)")
//        // before starting the chat set the visitor data
//        ZendeskChatManager.updateVisitor(name: nil, email: nil, phoneNumber: nil, note: nil)
//        // start a chat pushed on to the current navigation controller
//        // with a session config requiring all pre-chat fields and setting tags and department
//        ZendeskChatManager.startChat(on: navigationController, event: "Help Chat Started")
//    }
    
    @objc func openModalViewController() {
        // track the event
//        ZendeskChatManager.trackEvent("Modal View Controller opened")
        // simple app navigation simulation
        let vc = SwiftViewController(nibName: nil, bundle: nil)
        vc.modal = true
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .formSheet
        
        let bbi = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(dismissVC))
        vc.navigationItem.rightBarButtonItem = bbi
        present(navController, animated: true)
    }
    
    @objc func pushViewController() {
        // track the event
//        ZendeskChatManager.trackEvent("View Controller pushed")
        // simple app navigation simulation
        let vc = SwiftViewController(nibName: nil, bundle: nil)
        vc.nested = true
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
//MARK: - Account Key
    @objc func updateAccountKey() {
        let alert = UIAlertView(title: "Update account key", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Update")
        
        alert.alertViewStyle = .plainTextInput
        let textField = alert.textField(at: 0)
        textField?.placeholder = "Account key"
        textField?.accessibilityIdentifier = "SampleViewController.accounttDialog.textField"
        alert.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        switch buttonIndex {
        case 0:
            // cancelled
            break
        default:
            let textField = alertView.textField(at: 0)

            if (textField?.text?.count ?? 0) > 0 {
//                ZendeskChatManager.initializeChat(accountKey: textField?.text ?? "")
            }
        }
    }
}
