//
//  MessageBubbleView.swift
//  FamilyTime
//
//  Created by Ahmad on 19/05/2026.
//  Copyright © 2026 YumyApps. All rights reserved.
//

import SwiftUI

struct MessageBubbleView: View {
    
    let message: ChatMessage
    let showSender: Bool
    var onRetry: (() -> Void)?
    
    var body: some View {
        
        HStack(alignment: .bottom) {
            
            if message.isCurrentUser {
                
                Spacer(minLength: 60)
                
                VStack(
                    alignment: .trailing,
                    spacing: 4
                ) {
                    
                    // MESSAGE BUBBLE
                    
                    Text(
                        formattedMessage
                    )
                    .font(.RegularFont(size: 15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        Color(hex: "#156CF7")
                    )
                    .cornerRadius(12, corners: [.topLeft, .topRight, .bottomLeft])
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
                    
                    // STATUS
                    
                    messageStatusView
                }
                
            } else {

                avatarView(
                    isCurrentUser: false
                )
                
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    
                    if showSender {
                        
                        Text(
                            message.senderName ?? ""
                        )
                        .font(.RegularFont(size: 12))
                        .foregroundColor(Color.black.opacity(0.6))
                    }
                    
                    Text(
                        formattedMessage
                    )
                    .font(.RegularFont(size: 15))
                    .foregroundColor(
                        Color(hex: "#333333")
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        Color.white
                    )
                    .cornerRadius(12, corners: [.topLeft, .topRight, .bottomRight])
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
                }
                
                Spacer(minLength: 60)
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: message.isCurrentUser
            ? .trailing
            : .leading
        )
        .padding(.horizontal)
    }
}

// MARK: - Static Avatars
extension MessageBubbleView {

    private func avatarView(
        isCurrentUser: Bool
    ) -> some View {

        ZStack {

            Image(showSender ? "agentAvatar" : "")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
        }
    }
}

// MARK: - Message Status View
extension MessageBubbleView {
    
    @ViewBuilder
    private var messageStatusView: some View {
        
        switch message.status {
            
        case .sending:
            
            HStack(spacing: 4) {
                
                ProgressView()
                    .scaleEffect(0.7)
                
                Text("Sending...")
                    .font(.RegularFont(size: 11))
                    .foregroundColor(.gray)
            }
            
        case .sent:
            
            Image("doubleTickIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundColor(determineTickColor(for: message))
            
        case .failed:
            
            Button {
                
                onRetry?()
                
            } label: {
                
                Text("Failed · Try again")
                    .font(.RegularFont(size: 11))
                    .foregroundColor(.red)
            }
        }
    }
}

// MARK: - Message Formatting
extension MessageBubbleView {
    
    private var formattedMessage: String {
        
        (message.message ?? "")
            .replacingOccurrences(
                of: "<br>",
                with: "\n"
            )
            .replacingOccurrences(
                of: "<br/>",
                with: "\n"
            )
            .replacingOccurrences(
                of: "<br />",
                with: "\n"
            )
    }
}

extension MessageBubbleView {
    
    private func determineTickColor(for msg: ChatMessage) -> Color {
        // This print will trigger in your console every time a bubble is rendered
        print("💬 Message ID: \(msg.id ?? 0), isRead Raw Value: \(String(describing: msg.isRead))")
        
        if let readStatus = msg.isRead {
            return readStatus ? .accentColor : .gray
        } else {
            return .gray // Handles nil fallback
        }
    }
}
