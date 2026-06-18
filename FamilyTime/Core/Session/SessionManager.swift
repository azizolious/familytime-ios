//
//  SessionManager.swift
//  FamilyTime
//
//  Phase 1 — single source of truth for authentication session state.
//
//  Tokens are persisted exclusively through the Phase-0 `KeychainService`
//  (Security-framework backed); this type holds no plaintext on disk itself.
//  On session teardown it posts `sessionExpiredNotification`, which bridges to
//  the existing eX00401 logout flow during Phase 2.
//
//  Token mapping:
//    token -> Keys.token ("ft.session.token")
//

import Foundation

@MainActor
@Observable
final class SessionManager {

    static let shared = SessionManager()

    private(set) var isAuthenticated: Bool = false
    private(set) var currentToken: String?

    private enum Keys {
        static let token = "ft.session.token"
    }

    static let sessionExpiredNotification = Notification.Name("ft.session.expired")

    private init() {}

    /// Rehydrate the in-memory session from the Keychain (e.g. on launch).
    func restoreSession() {
        currentToken = KeychainService.load(key: Keys.token)
        isAuthenticated = (currentToken != nil)
    }

    /// Persist a freshly issued session and mark the user as authenticated.
    func saveSession(token: String) {
        KeychainService.save(key: Keys.token, value: token)
        currentToken = token
        isAuthenticated = true
    }

    /// Tear down the session: purge the Keychain, reset state, and broadcast
    /// expiry so legacy observers can perform their logout side effects.
    func clearSession() {
        KeychainService.delete(key: Keys.token)
        currentToken = nil
        isAuthenticated = false
        NotificationCenter.default.post(name: Self.sessionExpiredNotification, object: nil)
    }

    /// Single replacement for the six duplicated eX00401 handlers.
    func handleAuthenticationFailure() {
        clearSession()
    }
}
