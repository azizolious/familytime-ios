//
//  SettingsViewModel.swift
//  FamilyTime
//
//  Top-level Settings screen view model. Owns the logout flow, which performs
//  a best-effort server logout and then ALWAYS clears the local session.
//

import Foundation

@MainActor
@Observable
final class SettingsViewModel {

    // MARK: UI state
    private(set) var isLoggingOut = false
    private(set) var errorMessage: String?

    private let repository: SettingsRepositoryProtocol
    private let session: SessionManager

    init(
        repository: SettingsRepositoryProtocol = SettingsRepository(),
        session: SessionManager = .shared
    ) {
        self.repository = repository
        self.session = session
    }

    /// Logs the user out. The server call is best-effort: even if it fails we
    /// still tear down the local session so the user is not stranded signed-in.
    func logout() async {
        isLoggingOut = true
        errorMessage = nil
        defer { isLoggingOut = false }

        // Best-effort server-side logout; a server failure must not block the
        // local teardown below.
        do {
            try await repository.logout()
        } catch {
            // Intentionally ignored: clear the local session regardless.
        }

        // REQUIRED: purges Keychain tokens and posts sessionExpired so legacy
        // observers run their logout side effects.
        session.clearSession()
    }
}
