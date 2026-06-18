//
//  LiveChatView.swift
//  FamilyTime
//
//  Created by Ahmad on 19/05/2026.
//  Copyright © 2026 YumyApps. All rights reserved.
//

import SwiftUI

enum ChatRow: Identifiable {
    
    case date(String)
    
    case message(
        ChatMessage,
        showSender: Bool
    )
    
    var id: String {
        
        switch self {
            
        case .date(let value):
            return "date_\(value)"
            
        case .message(let message, _):
            return message.stableId
        }
    }
}

struct LiveChatView: View {
    
    let messages: [ChatMessage]
    
    @State var messageText: String
    
    @State private var hasInitiallyScrolled = false

    @State private var previousMessageCount = 0
    
    let isLoadingMore: Bool

    let hasMoreMessages: Bool
    
    @State private var previousLastMessageId: Int?

    @State private var previousFirstMessageId: Int?
    
    let isConversationResolved: Bool
    
    let onTextChange: (String) -> Void
    
    let onSend: () -> Void
    
    let onBack: () -> Void
    
    let onLoadMore: () -> Void
    
    let retryMessage: (ChatMessage) -> Void
    
    let startConversation: () -> Void
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // HEADER
            
            VStack(spacing: 12) {
                
                headerView
                
                Divider()
            }
            
            // MESSAGES
            ZStack(alignment: .bottom) {
                
                messagesView
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                
                if isConversationResolved {
                    conversationEndedView
                        .background(Color(hex: "#F8F8F8"))
                        .padding(.horizontal, 16)
                }
            }
            
            // INPUT
            VStack(spacing: 12) {
                
                Divider()
                
                ChatInputView(
                    
                    text: Binding(
                        
                        get: {
                            
                            messageText
                        },
                        
                        set: { value in
                            
                            onTextChange(value)
                        }
                    )
                    
                ) {
                    
                    onSend()
                }
                .disabled(isConversationResolved)
            }
            .background(.white)
        }
        .background(Color(hex: "#F8F8F8"))
        .navigationBarBackButtonHidden()
    }
}

extension LiveChatView {
    
    var headerView: some View {
        
        HStack {
            
            Button {
                
                onBack()
                
            } label: {
                
                Image(systemName: "arrow.left")
                    .font(.RegularFont(size: 16))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Live Chat")
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "")
                .font(.RegularFont(size: 16))
                .foregroundColor(.black)
            
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
}

extension LiveChatView {
    
    var messagesView: some View {
        
        ScrollViewReader { proxy in
            
            ScrollView {
                
                LazyVStack(spacing: 16) {
                    
                    // PAGINATION TRIGGER
                    
                    if hasMoreMessages {
                        
                        ZStack {
                            
                            if isLoadingMore {
                                
                                ProgressView()
                                    .padding(.vertical, 12)
                            } else {
                                
                                Color.clear
                                    .frame(height: 1)
                            }
                        }
                    }
                    
                    // MESSAGES
                    ForEach(chatRows) { row in
                        
                        switch row {
                            
                        case .date(let title):
                            
                            DateSeparatorView(
                                title: title
                            )
                            
                        case .message(
                            let message,
                            let showSender
                        ):
                            
                            MessageBubbleView(
                                message: message,
                                showSender: showSender,
                                onRetry: {
                                    retryMessage(message)
                                }
                            )
                            .id(message.stableId)
                        }
                    }
                    
                    // BOTTOM ANCHOR
                    
                    Color.clear
                        .frame(height: 1)
                        .id("BOTTOM")
                }
                .padding(.vertical)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .background(
                Color(hex: "#F8F8F8")
            )
            .onChange(of: messages.count) { newCount in
                
                guard !hasInitiallyScrolled else {
                    return
                }
                
                guard newCount > 0 else {
                    return
                }
                
                // WAIT UNTIL VIEW FULLY RENDERS
                
                DispatchQueue.main.async {
                    
                    guard !hasInitiallyScrolled else {
                        return
                    }
                    
                    var transaction =
                    Transaction()
                    
                    transaction.disablesAnimations = true
                    
                    withTransaction(transaction) {
                        
                        proxy.scrollTo(
                            "BOTTOM",
                            anchor: .bottom
                        )
                    }
                    
                    // DOUBLE SAFETY SCROLL
                    
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 0.1
                    ) {
                        
                        withTransaction(transaction) {
                            
                            proxy.scrollTo(
                                "BOTTOM",
                                anchor: .bottom
                            )
                        }
                        
                        hasInitiallyScrolled = true
                        
                        previousLastMessageId =
                        messages.last?.id
                        
                        previousFirstMessageId =
                        messages.first?.id
                    }
                }
            }
            .onChange(of: messages.last?.id) { newLastId in

                guard hasInitiallyScrolled else {
                    return
                }

                guard let newLastId else {
                    return
                }

                let lastMessageChanged =
                previousLastMessageId != newLastId

                let firstMessageChanged =
                previousFirstMessageId != messages.first?.id

                previousLastMessageId = newLastId

                previousFirstMessageId = messages.first?.id

                // PAGINATION prepend

                guard !firstMessageChanged else {
                    return
                }

                // New realtime/sent message

                guard lastMessageChanged else {
                    return
                }

                DispatchQueue.main.async {

                    withAnimation {

                        proxy.scrollTo(
                            "BOTTOM",
                            anchor: .bottom
                        )
                    }
                }
            }
        }
        .onTapGesture {
            
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
}

extension LiveChatView {
    
    var paginationView: some View {
        
        Group {
            
            if isLoadingMore {
                
                ProgressView()
                    .padding(.vertical, 12)
                
            } else {
                
                Color.clear
                    .frame(height: 1)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

extension LiveChatView {
    
    private var chatRows: [ChatRow] {
        
        var rows: [ChatRow] = []
        
        var previousMessage: ChatMessage?
        
        var previousDateKey: String?
        
        for message in messages {
            
            let dateString =
            messageDateHeader(
                message.createdAt
            )
            
            // Date separator
            
            let currentDateKey =
            dateKey(message.createdAt)
            
            if previousDateKey != currentDateKey {
                
                rows.append(
                    .date(
                        messageDateHeader(
                            message.createdAt
                        )
                    )
                )
                
                previousDateKey = currentDateKey
            }
            
            // Sender grouping
            
            let showSender =
            previousMessage?.senderName !=
            message.senderName
            
            rows.append(
                .message(
                    message,
                    showSender: showSender
                )
            )
            
            previousMessage = message
        }
        
        return rows
    }
    
    private func messageDateHeader(
        _ value: String?
    ) -> String {
        
        guard let value else {
            return ""
        }
        
        let formatter =
        ISO8601DateFormatter()
        
        guard let date =
        formatter.date(
            from: value
        ) else {
            return ""
        }
        
        let calendar =
        Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        }
        
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }
        
        let displayFormatter =
        DateFormatter()
        
        displayFormatter.dateFormat =
        "dd MMM yyyy"
        
        return displayFormatter.string(
            from: date
        )
    }
    
    private func dateKey(
        _ value: String?
    ) -> String {
        
        guard let value else {
            return ""
        }
        
        let formatter = ISO8601DateFormatter()
        
        guard let date = formatter.date(from: value) else {
            return ""
        }
        
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        return "\(year)-\(month)-\(day)"
    }
}

extension LiveChatView {
    
    var conversationEndedView: some View {
        
        VStack(spacing: 22) {

            VStack(spacing: 16) {
                
                Image("greenTickIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                VStack(spacing: 4) {
                    
                    Text("This chat has ended")
                        .font(.SemiboldFont(size: 18))
                    
                    Text("Thank you for contacting FamilyTime")
                        .font(.RegularFont(size: 14))
                        .foregroundStyle(.black.opacity(0.8))
                    
                }
            }
            
            
            Button {
                
                startConversation()
                
            } label: {
                
                Text("Start a new conversation")
                    .font(.SemiboldFont(size: 14))
                    .foregroundStyle(.green)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.1))
        .cornerRadius(16)
    }
    
}

struct DateSeparatorView: View {
    
    let title: String
    
    var body: some View {
        
        HStack {
            
//            Rectangle()
//                .fill(.gray.opacity(0.3))
//                .frame(height: 1)
            
            Text(title)
                .font(.RegularFont(size: 12))
                .foregroundColor(.accentColor)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(.white)
                .cornerRadius(12)
            
//            Rectangle()
//                .fill(.gray.opacity(0.3))
//                .frame(height: 1)
        }
        .padding(.horizontal)
    }
}
