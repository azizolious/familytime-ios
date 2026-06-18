//
//  LiveVisitorManager.swift
//  FamilyTime
//
//  Created by Ahmad on 20/05/2026.
//  Copyright © 2026 YumyApps. All rights reserved.
//

import Foundation

@objcMembers
@MainActor
final class LiveVisitorManager: NSObject, ObservableObject {
    
    @objc
    static let shared = LiveVisitorManager()
    
    private override init() {}
    
    @Published var visitor: Visitor?
    
    @Published var unreadCount: Int = 0
    
    @Published var isConversationResolved = false
    
    private let service = LiveChatService.shared
    
    private var heartbeatTask: Task<Void, Never>?
    
    private var currentHeartbeatInterval: Int = 15
    
    private var currentScreen: String?
    
    private var reconnectAttempt: Int = 0

    private var isStarting = false

    private var retryStartTask: Task<Void, Never>?
    
    @Published var currentConversation: Conversation?
    
    func start() async {

        guard !isStarting else {
            return
        }

        if visitor != nil,
           heartbeatTask != nil {

            startSocket()

            return
        }

        isStarting = true

        defer {
            isStarting = false
        }
        
        do {
            
            print("""
            
            =========================
            VISITOR START
            =========================
            
            """)
            
            let visitor = try await service.joinVisitor()
            
            self.visitor = visitor
            
            reconnectAttempt = 0

            retryStartTask?.cancel()

            retryStartTask = nil
            
            print("""
            
            =========================
            VISITOR JOINED
            =========================
            VISITOR ID:
            \(visitor.id)
            
            CONVERSATION ID:
            \(visitor.conversationId ?? -1)
            =========================
            
            """)
            
            startSocket()
            
            startHeartbeat()
            
        } catch {
            
            print("""
            
            =========================
            VISITOR START FAILED
            =========================
            ERROR:
            \(error.localizedDescription)
            =========================
            
            """)
            
            retryStart()
        }
    }
    
    private func startSocket() {
        
        guard let visitorId = visitor?.id else {
            return
        }
        
        LiveChatSocketManager.shared.connect(
            visitorId: visitorId
        )
    }
    
    private func startHeartbeat() {
        
        heartbeatTask?.cancel()
        
        heartbeatTask = Task {
            
            while !Task.isCancelled {
                
                do {
                    
                    print("""
                    
                    =========================
                    HEARTBEAT REQUEST
                    =========================
                    SCREEN:
                    \(currentScreen ?? "none")
                    =========================
                    
                    """)
                    
                    let response = try await service.heartbeat(
                        screen: currentScreen
                    )
                    
                    reconnectAttempt = 0
                    
                    // The guide requires honoring the server interval and
                    // never tightening retries below the default heartbeat.
                    currentHeartbeatInterval =
                    max(
                        LiveChatConstants.minimumHeartbeatInterval,
                        response.nextHeartbeat ??
                        LiveChatConstants.minimumHeartbeatInterval
                    )
                    
                    unreadCount =
                    response.unreadCount ?? 0
                    
                    print("""
                    
                    =========================
                    HEARTBEAT SUCCESS
                    =========================
                    STATE:
                    \(response.state)
                    
                    NEXT:
                    \(response.nextHeartbeat)
                    
                    UNREAD:
                    \(response.unreadCount)
                    =========================
                    
                    """)
                    
                    let previousConversationId =
                    visitor?.conversationId

                    let latestConversationId =
                    response.conversationId
                    
                    if latestConversationId == nil {
                        
                        print("""
                        
                        =========================
                        CONVERSATION RESOLVED
                        =========================
                        OLD:
                        \(previousConversationId ?? -1)
                        
                        =========================
                        
                        """)
                        
                        isConversationResolved = true
                        
                        await createNewConversation()
                        
                    } else {
                        
//                        isConversationResolved = false
                    }
                    
                    try await Task.sleep(
                        for: .seconds(
                            currentHeartbeatInterval
                        )
                    )
                    
                } catch {
                    
                    print("""
                    
                    =========================
                    HEARTBEAT FAILED
                    =========================
                    ERROR:
                    \(error.localizedDescription)
                    =========================
                    
                    """)
                    
                    let delay =
                    heartbeatRetryDelay()
                    
                    print("RETRY IN:", delay)
                    
                    try? await Task.sleep(
                        for: .seconds(delay)
                    )
                }
            }
        }
    }
    
    private func heartbeatRetryDelay() -> Int {
        
        reconnectAttempt += 1
        
        switch reconnectAttempt {
            
        case 1:
            return 5
            
        case 2:
            return 15
            
        default:
            return 30
        }
    }
    
    private func retryStart() {

        retryStartTask?.cancel()
        
        retryStartTask = Task {
            
            try? await Task.sleep(
                for: .seconds(5)
            )
            
            await start()
        }
    }
    
    func joinApiCall() async throws {
        do {
            print("""
        
        =========================
        VISITOR START
        =========================
        
        """)
            
            let visitor = try await service.joinVisitor()
            
            self.visitor = visitor
            
            reconnectAttempt = 0
            
            retryStartTask?.cancel()
            
            retryStartTask = nil
            
            print("""
        
        =========================
        VISITOR JOINED
        =========================
        VISITOR ID:
        \(visitor.id)
        
        CONVERSATION ID:
        \(visitor.conversationId ?? -1)
        =========================
        
        """)
        } catch {
            print("Join Api error: ", error.localizedDescription)
        }
    }
    
    private func createNewConversation() async {
        
        do {
            
            let _ =
            try await service
                .createConversation()
            
//            self.isConversationResolved = false
            
            try await self.joinApiCall()
            
        } catch {
            
            print(
                "CREATE CONVERSATION ERROR:",
                error.localizedDescription
            )
        }
    }
    
    func disconnect() async {
        
        heartbeatTask?.cancel()
        
        heartbeatTask = nil

        retryStartTask?.cancel()

        retryStartTask = nil
        
        LiveChatSocketManager.shared.disconnect()
        
        do {
            
            try await service.disconnect()
            
            print("""
            
            =========================
            VISITOR DISCONNECTED
            =========================
            
            """)
            
        } catch {
            
            print("""
            
            =========================
            DISCONNECT FAILED
            =========================
            ERROR:
            \(error.localizedDescription)
            =========================
            
            """)
        }
    }
    
    func updateScreen(
        _ screen: String
    ) {
        
        currentScreen = screen
        
        Task {
            
            do {
                
                try await service.updateScreen(
                    screen
                )
                
                print("""
                
                =========================
                SCREEN UPDATED
                =========================
                SCREEN:
                \(screen)
                =========================
                
                """)
                
            } catch {
                
                print(error.localizedDescription)
            }
        }
    }
}

extension LiveVisitorManager {
    
    @objc
    func startVisitorSession() {
        
        Task {
            
            await start()
        }
    }
    
    @objc
    func disconnectVisitorSession() {
        
        Task {
            
            await disconnect()
        }
    }
    
}
