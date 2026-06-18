//
//  LiveChatService.swift
//  FamilyTime
//
//  Created by Ahmad on 19/05/2026.
//  Copyright © 2026 YumyApps. All rights reserved.
//

import Foundation

final class LiveChatService {
    
    static let shared = LiveChatService()
    
    private init() {}
    
    private var token: String {
        SessionManager.persistedToken ?? ""
    }
    
    private func makeRequest(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil
    ) -> URLRequest {
        
        let url = URL(string: "\(LiveChatConstants.baseURL)\(endpoint)")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        
        defaultHeaders.forEach {
            
            request.setValue(
                $0.value,
                forHTTPHeaderField: $0.key
            )
        }
        
        request.httpBody = body
        
        return request
    }
    
    func joinVisitor() async throws -> Visitor {
        
        let request = makeRequest(
            endpoint: "/visitors/join",
            method: "POST"
        )
        
        // MARK: - Request Debug
        
        print("""
        
        ===============================
        JOIN VISITOR REQUEST
        ===============================
        URL:
        \(request.url?.absoluteString ?? "")
        
        METHOD:
        \(request.httpMethod ?? "")
        
        HEADERS:
        \(request.allHTTPHeaderFields ?? [:])
        ===============================
        
        """)
        
        do {
            
            let (data, response) = try await URLSession.shared.data(
                for: request
            )
            
            guard let httpResponse = response as? HTTPURLResponse else {
                
                print("""
                
                ===============================
                JOIN VISITOR FAILED
                ===============================
                Invalid HTTP Response
                ===============================
                
                """)
                
                throw URLError(.badServerResponse)
            }
            
            // MARK: - Raw Response String
            
            let responseString = String(
                data: data,
                encoding: .utf8
            ) ?? "Unable to parse response string"
            
            // MARK: - Response Debug
            
            print("""
            
            ===============================
            JOIN VISITOR RESPONSE
            ===============================
            STATUS CODE:
            \(httpResponse.statusCode)
            
            URL:
            \(request.url?.absoluteString ?? "")
            
            RESPONSE:
            \(responseString)
            
            HEADERS:
            \(httpResponse.allHeaderFields)
            ===============================
            
            """)
            
            // MARK: - Handle Status Codes
            
            switch httpResponse.statusCode {
                
            case 200...299:
                
                do {
                    
                    let result = try JSONDecoder().decode(
                        APIEnvelope<Visitor>.self,
                        from: data
                    )
                    
                    print("""
                    
                    ===============================
                    JOIN VISITOR SUCCESS
                    ===============================
                    VISITOR ID:
                    \(result.data.id)
                    
                    CONVERSATION ID:
                    \(result.data.conversationId ?? -1)
                    ===============================
                    
                    """)
                    
                    return result.data
                    
                } catch {
                    
                    print("""
                    
                    ===============================
                    DECODING ERROR
                    ===============================
                    ERROR:
                    \(error.localizedDescription)
                    ===============================
                    
                    """)
                    
                    throw error
                }
                
            case 401:
                
                print("""
                
                ===============================
                UNAUTHORIZED
                ===============================
                Invalid or expired token
                ===============================
                
                """)
                
                throw URLError(.userAuthenticationRequired)
                
            case 403:
                
                print("""
                
                ===============================
                FORBIDDEN
                ===============================
                User does not have permission
                ===============================
                
                """)
                
                throw URLError(.noPermissionsToReadFile)
                
            case 404:
                
                print("""
                
                ===============================
                NOT FOUND
                ===============================
                Visitor does not exist
                ===============================
                
                """)
                
                throw URLError(.fileDoesNotExist)
                
            case 422:
                
                print("""
                
                ===============================
                VALIDATION ERROR
                ===============================
                RESPONSE:
                \(responseString)
                ===============================
                
                """)
                
                throw URLError(.cannotParseResponse)
                
            case 500...599:
                
                print("""
                
                ===============================
                SERVER ERROR
                ===============================
                STATUS:
                \(httpResponse.statusCode)
                ===============================
                
                """)
                
                throw URLError(.badServerResponse)
                
            default:
                
                print("""
                
                ===============================
                UNKNOWN ERROR
                ===============================
                STATUS:
                \(httpResponse.statusCode)
                
                RESPONSE:
                \(responseString)
                ===============================
                
                """)
                
                throw URLError(.unknown)
            }
            
        } catch {
            
            print("""
            
            ===============================
            NETWORK ERROR
            ===============================
            ERROR:
            \(error.localizedDescription)
            
            URL:
            \(request.url?.absoluteString ?? "")
            ===============================
            
            """)
            
            throw error
        }
    }
    
    func createConversation() async throws -> Conversation {
        
        let request = makeRequest(
            endpoint: "/conversations",
            method: "POST"
        )
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let result = try JSONDecoder().decode(
            APIEnvelope<Conversation>.self,
            from: data
        )
        
        return result.data
    }
    
    
    func fetchMessages(
        conversationId: Int,
        before: Int? = nil
    ) async throws -> [ChatMessage] {
        
        // MARK: - Endpoint
        
        var endpoint =
        "/conversations/\(conversationId)/messages"

        let limit =
        before == nil
        ? LiveChatConstants.initialMessageLimit
        : LiveChatConstants.paginationMessageLimit
        
        // MARK: - Pagination
        
        if let before {
            
            endpoint += "?before=\(before)&limit=\(limit)"

        } else {

            endpoint += "?limit=\(limit)"
        }
        
        // MARK: - Request
        
        let request = makeRequest(
            endpoint: endpoint
        )
        
        print("""
        
        ===============================
        FETCH MESSAGES REQUEST
        ===============================
        URL:
        \(request.url?.absoluteString ?? "")
        
        BEFORE:
        \(before ?? -1)
        ===============================
        
        """)
        
        // MARK: - API Call
        
        let (data, response) =
        try await URLSession.shared.data(
            for: request
        )
        
        guard let httpResponse =
                response as? HTTPURLResponse else {
            
            throw URLError(.badServerResponse)
        }
        
        // MARK: - Response Debug
        
        let responseString = String(
            data: data,
            encoding: .utf8
        ) ?? ""
        
        print("""
        
        ===============================
        FETCH MESSAGES RESPONSE
        ===============================
        STATUS:
        \(httpResponse.statusCode)
        
        RESPONSE:
        \(responseString)
        ===============================
        
        """)
        
        // MARK: - Status Check
        
        guard 200...299 ~= httpResponse.statusCode else {
            
            throw URLError(.badServerResponse)
        }
        
        // MARK: - Decode
        
        let result = try JSONDecoder().decode(
            APIEnvelope<[ChatMessage]>.self,
            from: data
        )
        
        print("""
        
        ===============================
        FETCHED MESSAGE COUNT
        ===============================
        COUNT:
        \(result.data.count)
        ===============================
        
        """)
        
        return result.data
    }
    
    func sendMessage(
        conversationId: Int,
        message: String
    ) async throws -> ChatMessage {
        
        let payload: [String: Any] = [
            "conversation_id": conversationId,
            "message": message
        ]
        
        let body = try JSONSerialization.data(
            withJSONObject: payload
        )
        
        let request = makeRequest(
            endpoint: "/messages",
            method: "POST",
            body: body
        )
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let result = try JSONDecoder().decode(
            APIEnvelope<ChatMessage>.self,
            from: data
        )
        
        return result.data
    }
    
    func heartbeat(
        screen: String? = nil
    ) async throws -> HeartbeatResponse {
        
        var payload: [String: Any] = [:]
        
        if let screen {
            
            payload["screen"] = screen
        }
        
        let body = try JSONSerialization.data(
            withJSONObject: payload
        )
        
        let request = makeRequest(
            endpoint: "/visitors/heartbeat",
            method: "POST",
            body: body
        )
        
        print("""
        
        ===============================
        HEARTBEAT REQUEST
        ===============================
        URL:
        \(request.url?.absoluteString ?? "")
        
        BODY:
        \(String(data: body, encoding: .utf8) ?? "")
        ===============================
        
        """)
        
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
        
        ===============================
        HEARTBEAT RESPONSE
        ===============================
        STATUS:
        \(httpResponse.statusCode)
        
        RESPONSE:
        \(responseString)
        ===============================
        
        """)
        
        guard 200...299 ~= httpResponse.statusCode else {
            
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(
            APIEnvelope<HeartbeatResponse>.self,
            from: data
        )
        
        return result.data
    }
    
    func disconnect() async throws {
        
        let request = makeRequest(
            endpoint: "/visitors/disconnect",
            method: "POST"
        )
        
        print("""
        
        ===============================
        DISCONNECT REQUEST
        ===============================
        URL:
        \(request.url?.absoluteString ?? "")
        ===============================
        
        """)
        
        let (_, response) =
        try await URLSession.shared.data(
            for: request
        )
        
        guard let httpResponse =
                response as? HTTPURLResponse else {
            
            throw URLError(.badServerResponse)
        }
        
        print("""
        
        ===============================
        DISCONNECT RESPONSE
        ===============================
        STATUS:
        \(httpResponse.statusCode)
        ===============================
        
        """)
        
        guard 200...299 ~= httpResponse.statusCode else {
            
            throw URLError(.badServerResponse)
        }
    }
    
    func updateScreen(
        _ screen: String
    ) async throws {
        
        let payload: [String: Any] = [
            "screen": screen
        ]
        
        let body = try JSONSerialization.data(
            withJSONObject: payload
        )
        
        let request = makeRequest(
            endpoint: "/visitors/screen",
            method: "POST",
            body: body
        )
        
        print("""
        
        ===============================
        SCREEN UPDATE REQUEST
        ===============================
        SCREEN:
        \(screen)
        ===============================
        
        """)
        
        let (_, response) =
        try await URLSession.shared.data(
            for: request
        )
        
        guard let httpResponse =
                response as? HTTPURLResponse else {
            
            throw URLError(.badServerResponse)
        }
        
        print("""
        
        ===============================
        SCREEN UPDATE RESPONSE
        ===============================
        STATUS:
        \(httpResponse.statusCode)
        ===============================
        
        """)
        
        guard 200...299 ~= httpResponse.statusCode else {
            
            throw URLError(.badServerResponse)
        }
    }
    
    func markConversationRead(
        conversationId: Int
    ) async throws {

        let request = makeRequest(
            endpoint: "/conversations/\(conversationId)/read",
            method: "POST"
        )

        print("""

        ===============================
        MARK READ REQUEST
        ===============================
        URL:
        \(request.url?.absoluteString ?? "")
        ===============================

        """)

        let (_, response) =
        try await URLSession.shared.data(
            for: request
        )

        guard let httpResponse =
                response as? HTTPURLResponse else {

            throw URLError(.badServerResponse)
        }

        print("""

        ===============================
        MARK READ RESPONSE
        ===============================
        STATUS:
        \(httpResponse.statusCode)
        ===============================

        """)

        guard 200...299 ~= httpResponse.statusCode else {

            throw URLError(.badServerResponse)
        }
    }
    
    func sendTyping(
        conversationId: Int,
        isTyping: Bool
    ) async throws {

        let payload: [String: Any] = [
            "conversation_id": conversationId,
            "is_typing": isTyping
        ]

        let body = try JSONSerialization.data(
            withJSONObject: payload
        )

        let request = makeRequest(
            endpoint: "/visitors/typing",
            method: "POST",
            body: body
        )

        print("""

        ===============================
        TYPING REQUEST
        ===============================
        CONVERSATION:
        \(conversationId)

        TYPING:
        \(isTyping)
        ===============================

        """)

        let (_, response) =
        try await URLSession.shared.data(
            for: request
        )

        guard let httpResponse =
                response as? HTTPURLResponse else {

            throw URLError(.badServerResponse)
        }

        print("""

        ===============================
        TYPING RESPONSE
        ===============================
        STATUS:
        \(httpResponse.statusCode)
        ===============================

        """)

        guard 200...299 ~= httpResponse.statusCode else {

            throw URLError(.badServerResponse)
        }
    }
}

extension LiveChatService {
    
    private var defaultHeaders: [String: String] {
        
        [
            "Authorization":
                "Bearer \(token)",
            
            "Content-Type":
                "application/json",
            
            "Accept":
                "application/json",
            
            "os":
                "ios",
            
            "app-version":
                Bundle.main.object(
                    forInfoDictionaryKey:
                        "CFBundleShortVersionString"
                ) as? String ?? "",
            
            "app-build":
                Bundle.main.object(
                    forInfoDictionaryKey:
                        "CFBundleVersion"
                ) as? String ?? "",
            
            "user-agent":
                userAgent,
            
            "os-version":
                UIDevice.current.systemVersion,
            
            "language":
                Locale.current.language
                .languageCode?
                .identifier ?? "en",
            
            "country":
                Locale.current.region?
                .identifier ?? ""
        ]
    }
    
    private var userAgent: String {
        
        let appVersion =
        Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String ?? "0.0.0"
        
        let buildNumber =
        Bundle.main.object(
            forInfoDictionaryKey: "CFBundleVersion"
        ) as? String ?? "0"
        
        let iosVersion =
        UIDevice.current.systemVersion
        
        return """
        FamilyTime/\(appVersion) (iOS; Build:\(buildNumber); IOS:\(iosVersion);)
        """
    }
}

struct QueuedLiveChatMessage: Codable, Identifiable {

    let id: UUID

    let conversationId: Int

    let message: String

    let queuedAt: Date
}

final class LiveChatOfflineMessageQueue {

    static let shared =
    LiveChatOfflineMessageQueue()

    private let storageKey =
    "familytime.livechat.offline.queue"

    private init() {}

    func enqueue(
        localId: UUID,
        conversationId: Int,
        message: String
    ) {

        var queue = queuedMessages()

        guard !queue.contains(
            where: { $0.id == localId }
        ) else {
            return
        }

        queue.append(
            QueuedLiveChatMessage(
                id: localId,
                conversationId: conversationId,
                message: message,
                queuedAt: Date()
            )
        )

        save(queue)
    }

    func queuedMessages(
        for conversationId: Int
    ) -> [QueuedLiveChatMessage] {

        queuedMessages()
            .filter {
                $0.conversationId == conversationId
            }
            .sorted {
                $0.queuedAt < $1.queuedAt
            }
    }

    func remove(
        localId: UUID
    ) {

        var queue = queuedMessages()

        queue.removeAll {
            $0.id == localId
        }

        save(queue)
    }

    private func queuedMessages()
    -> [QueuedLiveChatMessage] {

        guard let data =
                UserDefaults.standard.data(
                    forKey: storageKey
                ) else {
            return []
        }

        return (
            try? JSONDecoder().decode(
                [QueuedLiveChatMessage].self,
                from: data
            )
        ) ?? []
    }

    private func save(
        _ queue: [QueuedLiveChatMessage]
    ) {

        let data = try? JSONEncoder()
            .encode(queue)

        UserDefaults.standard.set(
            data,
            forKey: storageKey
        )
    }
}
