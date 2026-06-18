//
//  LiveChatSocketManager.swift
//  FamilyTime
//
//  Created by Ahmad on 20/05/2026.
//  Copyright © 2026 YumyApps. All rights reserved.
//

import Foundation
import Starscream

final class LiveChatSocketManager: NSObject {
    
    // MARK: - Singleton
    
    static let shared = LiveChatSocketManager()
    
    private override init() {}
    
    // MARK: - Properties
    
    private var socket: WebSocket?
    
    private var isConnected = false
    
    private var socketId: String?
    
    private var visitorId: Int?
    
    private var reconnectAttempt = 0

    private var isConnecting = false

    private var currentVisitorId: Int?

    private var reconnectTask: Task<Void, Never>?

    private var subscribedChannelName: String?

    private var shouldReconnect = false

    private let listenerQueue =
    DispatchQueue(
        label: "com.familytime.livechat.socket.listeners"
    )

    private var messageListeners:
    [UUID: (ChatMessage) -> Void] = [:]
    
    // MARK: - Callbacks
    
    var onConnected: (() -> Void)?
    
    var onDisconnected: (() -> Void)?

    @discardableResult
    func addMessageListener(
        _ listener: @escaping (ChatMessage) -> Void
    ) -> UUID {

        let id = UUID()

        listenerQueue.sync {
            messageListeners[id] = listener
        }

        return id
    }

    func removeMessageListener(
        _ id: UUID?
    ) {

        guard let id else {
            return
        }

        listenerQueue.sync {
            messageListeners.removeValue(
                forKey: id
            )
        }
    }
    
    // MARK: - Connect
    
    func connect(
        visitorId: Int
    ) {

        self.visitorId = visitorId

        self.currentVisitorId = visitorId

        shouldReconnect = true

        guard !isConnecting else {

            print("""

            =========================
            SOCKET ALREADY CONNECTING
            =========================

            """)

            return
        }

        guard !isConnected else {

            print("""

            =========================
            SOCKET ALREADY CONNECTED
            =========================

            """)

            return
        }

        isConnecting = true

        print("""

        =========================
        SOCKET CONNECT START
        =========================
        VISITOR:
        \(visitorId)
        =========================

        """)

        guard let url = URL(
            string: "wss://response.azizolious.com/app/m2b09rlm54g9uca81cbj"
        ) else {
            return
        }

        var request = URLRequest(url: url)

        request.timeoutInterval = 5

        socket = WebSocket(request: request)

        socket?.delegate = self

        socket?.connect()
    }
    
    // MARK: - Disconnect
    
    func disconnect() {
        
        reconnectTask?.cancel()
        
        reconnectTask = nil

        shouldReconnect = false
        
        reconnectAttempt = 0
        
        isConnected = false
        
        isConnecting = false
        
        socketId = nil
        
        subscribedChannelName = nil
        
        print("""
        
        =========================
        SOCKET MANUAL DISCONNECT
        =========================
        
        """)
        
        socket?.delegate = nil

        socket?.disconnect()

        socket = nil
    }
}

extension LiveChatSocketManager: WebSocketDelegate {
    
    func didReceive(
        event: WebSocketEvent,
        client: WebSocketClient
    ) {
        
        switch event {
            
        case .connected(let headers):
            
            print("""
                
                =========================
                SOCKET CONNECTED
                =========================
                HEADERS:
                \(headers)
                =========================
                
                """)
            
            isConnected = true
            
            isConnecting = false

            shouldReconnect = true
            
            reconnectAttempt = 0
            
            onConnected?()
            
        case .disconnected(let reason, let code):
            
            print("""
                
                =========================
                SOCKET DISCONNECTED
                =========================
                REASON:
                \(reason)
                
                CODE:
                \(code)
                =========================
                
                """)
            
            isConnected = false
            
            isConnecting = false

            socketId = nil

            subscribedChannelName = nil
            
            onDisconnected?()
            
            if shouldReconnect {

                reconnect()
            }
            
        case .text(let text):
            
            print("""
                
                =========================
                RAW SOCKET TEXT
                =========================
                
                \(text)
                
                =========================
                
                """)
            
            handleSocketMessage(text)
            
        case .error(let error):
            
            print("""
                
                =========================
                SOCKET ERROR
                =========================
                ERROR:
                \(error?.localizedDescription ?? "")
                =========================
                
                """)
            
            isConnected = false
            
            isConnecting = false

            socketId = nil

            subscribedChannelName = nil
            
            if shouldReconnect {

                reconnect()
            }
            
        case .cancelled:
            
            print("""
                
                =========================
                SOCKET CANCELLED
                =========================
                
                """)
            
            isConnected = false
            
            isConnecting = false

            socketId = nil

            subscribedChannelName = nil
            
            if shouldReconnect {

                reconnect()
            }
            
        case .ping(_):
            
            print("Socket Ping")
            
        case .pong(_):
            
            print("Socket Pong")
            
        case .viabilityChanged(_):
            break
            
        case .reconnectSuggested(_):
            break
            
        case .peerClosed:
            break
            
        case .binary(_):
            break
        }
    }
}

extension LiveChatSocketManager {
    
    private func handleSocketMessage(
        _ text: String
    ) {
        
        guard let data = text.data(
            using: .utf8
        ) else {
            return
        }
        
        do {
            
            guard let json = try JSONSerialization
                .jsonObject(with: data) as? [String: Any] else {
                return
            }
            
            let event = json["event"] as? String ?? ""
            
            // MARK: - Connection Established
            
            if event == "pusher:connection_established" {
                
                handleConnectionEstablished(json)
                
                return
            }
            
            
            if event == "pusher:ping" {
                
                print("🏓 Ping received")
                
                sendPong()
                
                return
            }
            
            // MARK: - Agent Message
            
            print("socket event name : ", event)
            
            if event == "App\\Events\\AgentMessage" {
                
                handleAgentMessage(json)
                
                return
            }
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
    
    private func sendPong() {
        
        let payload: [String: Any] = [
            "event": "pusher:pong",
            "data": [:]
        ]
        
        do {
            
            let data = try JSONSerialization.data(
                withJSONObject: payload
            )
            
            if let jsonString = String(
                data: data,
                encoding: .utf8
            ) {
                
                print("🏓 Sending pong")
                print(jsonString)
                
                socket?.write(string: jsonString)
            }
            
        } catch {
            
            print("❌ Failed to send pong")
            print(error.localizedDescription)
        }
    }
}

extension LiveChatSocketManager {
    
    private func handleConnectionEstablished(
        _ json: [String: Any]
    ) {
        
        guard let dataString = json["data"] as? String,
              let data = dataString.data(using: .utf8),
              let innerJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return
        }
        
        socketId = innerJson["socket_id"] as? String
        
        print("Socket ID:", socketId ?? "")
        
        subscribeToVisitorChannel()
    }
}

extension LiveChatSocketManager {
    
    private func subscribeToVisitorChannel() {

        guard let socketId = socketId else {
            return
        }

        guard let visitorId = visitorId else {
            return
        }

        let channelName =
        "private-agent-message.\(visitorId)"

        guard subscribedChannelName != channelName else {

            print("""

            =========================
            CHANNEL ALREADY SUBSCRIBED
            =========================
            CHANNEL:
            \(channelName)
            =========================

            """)

            return
        }

        subscribedChannelName = channelName

        Task {

            do {

                print("""

                =========================
                CHANNEL AUTH START
                =========================
                CHANNEL:
                \(channelName)
                =========================

                """)

                let auth = try await authorizeChannel(
                    socketId: socketId,
                    channelName: channelName
                )

                let payload: [String: Any] = [
                    "event": "pusher:subscribe",
                    "data": [
                        "auth": auth,
                        "channel": channelName
                    ]
                ]

                let data = try JSONSerialization.data(
                    withJSONObject: payload
                )

                if let jsonString = String(
                    data: data,
                    encoding: .utf8
                ) {

                    socket?.write(
                        string: jsonString
                    )

                    print("""

                    =========================
                    CHANNEL SUBSCRIBED
                    =========================
                    CHANNEL:
                    \(channelName)
                    =========================

                    """)
                }

            } catch {

                print("""

                =========================
                CHANNEL SUBSCRIBE FAILED
                =========================
                ERROR:
                \(error.localizedDescription)
                =========================

                """)
            }
        }
    }
}

extension LiveChatSocketManager {

    private func authorizeChannel(
        socketId: String,
        channelName: String
    ) async throws -> String {
        
        let url = URL(
            string: "https://response.azizolious.com/api/broadcasting/auth"
        )!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let token =
        UserDefaultsManager.bearerTokenCore2 ?? ""
        
        print("TOKEN:", token)
        
        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )
        
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )
        
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        
        let payload: [String: Any] = [
            "socket_id": socketId,
            "channel_name": channelName
        ]
        
        let body = try JSONSerialization.data(
            withJSONObject: payload
        )
        
        request.httpBody = body
        
        // DEBUG
        
        if let jsonString = String(
            data: body,
            encoding: .utf8
        ) {
            
            print("""
            
            =========================
            AUTH REQUEST
            =========================
            URL:
            \(url.absoluteString)
            
            BODY:
            \(jsonString)
            =========================
            
            """)
        }
        
        let (data, response) =
        try await URLSession.shared.data(
            for: request
        )
        
        guard let httpResponse =
                response as? HTTPURLResponse else {
            
            throw URLError(.badServerResponse)
        }
        
        let responseString = String(
            data: data,
            encoding: .utf8
        ) ?? ""
        
        print("""
        
        =========================
        AUTH RESPONSE
        =========================
        STATUS:
        \(httpResponse.statusCode)
        
        RESPONSE:
        \(responseString)
        =========================
        
        """)
        
        guard 200...299 ~= httpResponse.statusCode else {
            
            throw URLError(.badServerResponse)
        }
        
        guard let json =
                try JSONSerialization.jsonObject(
                    with: data
                ) as? [String: Any] else {
            
            throw URLError(.badServerResponse)
        }
        
        guard let auth =
                json["auth"] as? String else {
            
            throw URLError(.badServerResponse)
        }
        
        return auth
    }
}

extension LiveChatSocketManager {

    private func handleAgentMessage(
        _ json: [String: Any]
    ) {

        guard let dataString = json["data"] as? String,
              let data = dataString.data(using: .utf8) else {
            return
        }

        do {
            
            let dto = try JSONDecoder().decode(
                AgentMessageSocketDTO.self,
                from: data
            )
            
            let formatter =
            ISO8601DateFormatter()
            
            let chatMessage =
            ChatMessage(
                id: dto.id,
                conversationId: dto.conversationId,
                senderType: dto.senderType,
                senderName: "Support",
                message: dto.message,
                isRead: false,
                createdAt: formatter.string(
                    from: Date()
                )
            )
            
            DispatchQueue.main.async {
                
                print("""
                        
                        =========================
                        REALTIME MESSAGE
                        =========================
                        ID:
                        \(chatMessage.id ?? 0)
                        
                        MESSAGE:
                        \(chatMessage.message ?? "")
                        =========================
                        
                        """)
                
                self.notifyMessageListeners(
                    chatMessage
                )
            }
            
        } catch {

            print(error.localizedDescription)
        }
    }
}

extension LiveChatSocketManager {

    private func reconnect() {

        guard let visitorId = visitorId else {
            return
        }

        guard shouldReconnect else {
            return
        }

        reconnectTask?.cancel()

        reconnectTask = Task {

            reconnectAttempt += 1

            let delay = reconnectDelay()

            print("""

            =========================
            SOCKET RECONNECT
            =========================
            ATTEMPT:
            \(reconnectAttempt)

            DELAY:
            \(delay)
            =========================

            """)

            try? await Task.sleep(
                for: .seconds(delay)
            )

            guard !Task.isCancelled else {
                return
            }

            self.connect(
                visitorId: visitorId
            )
        }
    }
    
    private func reconnectDelay() -> Int {
        
        switch reconnectAttempt {
            
        case 1:
            return 2
            
        case 2:
            return 5
            
        case 3:
            return 10
            
        default:
            return 15
        }
    }
}

extension LiveChatSocketManager {

    private func notifyMessageListeners(
        _ message: ChatMessage
    ) {

        let listeners = listenerQueue.sync {
            Array(messageListeners.values)
        }

        listeners.forEach { listener in
            listener(message)
        }
    }
}
