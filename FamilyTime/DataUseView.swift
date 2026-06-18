//
//  DataUseView.swift
//  FamilyTime
//
//  Created by Ahmad on 06/12/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct DataUseView: View {
    
    var subId: String?
    var isComingFromDrawer: Bool = false
    var onDismiss: ((Bool) -> Void)? // Custom dismiss handler
    var onshowingLoader: ((String) -> Void)? // Custom dismiss handler
    var onshowingAlert: (() -> Void)? // Custom dismiss handler
    
    var body: some View {
        
        loadView()
            .navigationBarBackButtonHidden()
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("isShowLoader"))) { notification in
                onshowingLoader?("0")
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("isShowAlert"))) { notification in
                onshowingAlert?()
            }
    }
}

@available(iOS 13.0, *)
extension DataUseView {
    
    private func loadView() -> some View {
        
        ScrollView {
            VStack(spacing: 15) {
                
                crossButton
                
                title
                    .padding(.horizontal, 5)
                
                subHeading
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    headingTile(headingNumber: "1.", heading: "Data Collection without MDM Enrollment")
                    
                    instructionTitle(text: "Contacts (FamilyTime Jr. syncs with contacts saved on the device, allowing you to see all the contacts saved on their mobile devices. This way, you receive firsthand information regarding the social circle of your kids.)")
                    
                    instructionTitle(text: "Location (for location tracking, geofencing, and speed alerts))")
                    
                    instructionTitle(text: "Device information (Signal Strength, Battery Status, Manufacturer, Device Name, Device Model, Device OS, Device Language, App Version, App Build))")
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    headingTile(headingNumber: "2.", heading: "Data Collection with MDM Enrollment")
                    
                    instructionTitle(text: "Installed Application List (We use this to obtain the list of third-party applications installed on child devices so that parents can get information on apps installed on their kids' devices.)")
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    headingTile(headingNumber: "3.", heading: "FamilyTime Subscription Terms")
                    
                    instructionTitle(text: "Subscriptions purchased through FamilyTime will be billed to your Apple App Store account and are governed by the Apple App Store refund policies.)")
                    
                    instructionTitle(text: "The subscription will renew automatically after the free trial ends for subsequent periods. You can cancel the subscription anytime during the trial or after it renews. To manage your subscription, please check your Subscriptions under Apple ID")
                }
                
                disclaimerSection
                
                termsAndConditionSection
                
                agreeButton
            }
            .padding()
        }
    }
    
}

@available(iOS 13.0, *)
extension DataUseView {
    
    var title: some View {
        Text("Data Collection and Terms of Use")
            .font(.SemiboldFont(size: 20))
    }
    
    var subHeading: some View {
        Text("A detailed overview of data collection and subscription conditions")
            .font(.RegularFont(size: 18))
            .foregroundColor(.black.opacity(0.5))
            .multilineTextAlignment(.leading)
    }
    
    var disclaimerSection: some View {
        
        HStack {
            
            Group {
                
                Text("Disclaimer: ")
                    .font(.SemiboldFont(size: 14))
                    .foregroundColor(.black)
                
                +
                
                Text("As required by Apple policy, we do not share any personally identifiable data collected by our service with any third parties for any reason.")
                    .font(.LightFont(size: 14))
                    .foregroundColor(.black.opacity(0.9))
            }
            
        }
        
    }
    
    var termsAndConditionSection: some View {
        
        HStack(spacing: 5) {
            
            Button(action: {
                openLink(url: "https://familytime.io/legal/terms-conditions.html")
            }) {
                Text("Terms of Use")
                    .font(.SemiboldFont(size: 14))
                    .foregroundColor(.black)
                    .underline() // Add underline
            }
            
            HStack {
                Rectangle()
                    .frame(width: 1, height: 15)
                    .foregroundColor(.black)
            }
            
            Button(action: {
                openLink(url: "https://familytime.io/legal/app-privacy-policy.html")
            }) {
                Text("Privacy Policy")
                    .font(.SemiboldFont(size: 14))
                    .foregroundColor(.black)
                    .underline() // Add underline
            }
        }
    }
    
    
    var agreeButton: some View {
        HStack {
            Button {
                
                if subId != nil {
                    if let subId = subId {
                        NotificationCenter.default.post(name: Notification.Name.init("startLoader"), object: nil)
                        onshowingLoader?("1")
                        Analytics.logEvent("app_store_subscription_renew", parameters: [
                            "upgrade_status": "in_app_upgrade_compeleted_internal",
                            "screen_name": "in_app_upgrade_screen"
                        ])
                        let hostingController = UIHostingController(rootView: self)
                        
                        IAPUtility.shared.autoRenewablePurchase(prodId: subId, vc: hostingController)
                    }
                } else {
                    print("Sub id is nil...")
                }
            } label: {
                Text("I Agree")
                    .font(.SemiboldFont(size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 50)
        .background(
            RoundedRectangle(cornerRadius: 10) // Use a rounded rectangle as the background
                .fill(Color.blue) // Set the color of the background
        )
        .padding(.horizontal, 50)
    }
    
    var crossButton: some View {
        HStack {
            Spacer() // Push the button to the right
            
            Button(action: {
                if isComingFromDrawer {
                    onDismiss?(true) // Call the dismiss handler
                } else {
                    onDismiss?(false) // Call the dismiss handler
                }
            }) {
                HStack {
                    Image(systemName: "xmark")
                        .foregroundColor(.black) // Customize the color of the icon
                        .padding(10)
                }
                .background(Color.blue.opacity(0.1))
                .cornerRadius(20)
            }
            
        }
    }
    
    /// Function to open the link
    private func openLink(url: String) {
        if let link = URL(string: url), UIApplication.shared.canOpenURL(link) {
            UIApplication.shared.open(link)
        } else {
            print("Invalid URL")
        }
    }
}

@available(iOS 13.0, *)
extension DataUseView {
    
    func headingTile(headingNumber: String, heading: String) -> some View {
        HStack(spacing: 5) {
            Text(headingNumber)
                .font(.SemiboldFont(size: 16))
                .foregroundColor(.blue)
            
            Text(heading)
                .font(.SemiboldFont(size: 16))
        }
    }
    
    func instructionTitle(text: String) -> some View {
        
        HStack(alignment: .firstTextBaseline, spacing: 5) {
            Text(".")
                .font(.BoldFont(size: 18))
                .foregroundColor(.black)
            
            Text(text)
                .font(.RegularFont(size: 14))
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    
}

@available(iOS 13.0, *)
#Preview {
    DataUseView()
}
