//
//  HLAuthenticationManager.swift
//  FamilyTime
//
//  Created by Sana-Ullah-IOS on 13/03/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//

import Foundation


import AuthenticationServices

@available(iOS 13.0, *)
class HLAuthenticationAppleUser: NSObject {
    
    static let shared = HLAuthenticationAppleUser()
    var appleLogInButton : UIButton!
    var dataRecievedSuccessfully: ((_ name: String, _ email: String?, _ userIdentifier: String?, _ token :String?) -> ())?
    
    func addActionToAppleButton(_ sender: UIButton) {
        sender.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
        //self.performExistingAccountSetupFlows()
    }
    
    @objc func handleLogInWithAppleID() {
        
        UserDefaults.standard.set(true, forKey: "ZendeskChatScreen")
        UserDefaults.standard.synchronize()
        
        //Firebase Log Event
        CommonUtility.shared.setFirebaseEvents(eventName: "Login", screenTitle: "Login Screen", itemName: "Login with Apple")
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

@available(iOS 13.0, *)
extension HLAuthenticationAppleUser: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            var email = KeychainItem.currentUserEmail
            if email.isEmpty {
                if let emailID = appleIDCredential.email, !emailID.isEmpty {
                    email = emailID
                    self.saveUserEmailInKeychain(emailID)
                }
            } else {
                print("Email is not available with apple ID!!")
            }
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            var userIdentifier = KeychainItem.currentUserIdentifier
            if userIdentifier.isEmpty {
                let userID = appleIDCredential.user
                if userID.isEmpty {
                    userIdentifier = userID
                    self.saveUserInKeychain(userIdentifier)
                }
            } else {
                print("userIdentifier is not available with apple ID!!")
            }
            
            var fullName = ""
            if let givenName = appleIDCredential.fullName?.givenName {
                fullName = givenName
            }
            
            var token = ""
            if let tokenHash = appleIDCredential.identityToken?.html2String {
                token = tokenHash
            }
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
            self.dataRecievedSuccessfully?(fullName, email, userIdentifier, token)

        default:
            break
        }
    }
    
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "io.familytime.dashboard", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func saveUserEmailInKeychain(_ email: String) {
        do {
            try KeychainItem(service: "io.familytime.dashboard", account: "userEmail").saveItem(email)
        } catch {
            print("Unable to save email to keychain.")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return appDeleg.window
    }
    
    
}
