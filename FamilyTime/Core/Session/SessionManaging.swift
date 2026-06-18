//
//  SessionManaging.swift
//  FamilyTime
//
//  Phase 2 — abstraction over `SessionManager` so authentication view models
//  (e.g. `LoginViewModel`) can be unit-tested against a mock session store
//  without touching the Keychain or the live singleton.
//
//  `SessionManager` is `final`; it gains conformance via the extension below.
//

import Foundation

/// The session surface a view model needs to authenticate and tear down.
///
/// Mirrors the public API of `SessionManager`. Marked `@MainActor` because
/// session state is published UI state and is mutated from the main actor.
@MainActor
protocol SessionManaging: AnyObject {
    var isAuthenticated: Bool { get }
    var currentToken: String? { get }
    func restoreSession()
    func saveSession(token: String)
    func clearSession()
    func handleAuthenticationFailure()
}

extension SessionManager: SessionManaging {}
