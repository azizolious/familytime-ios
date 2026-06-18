//
//  LoginViewModel.swift
//  FamilyTime
//
//  Phase 2 — Swift-native, testable replacement for the authentication logic
//  embedded in the legacy `LoginViewController` (`loginWithNewApiCore2`).
//
//  Dependencies are injected behind protocols (`APIClientProtocol`,
//  `SessionManaging`) so the view model can be exercised with mocks.
//

import Foundation
import UIKit
import AuthenticationServices

/// Decoded shape of the `/login` response.
///
/// `token` is the bearer for core.familytime.io and is what we persist via
/// `SessionManager.saveSession(token:)`. `passportToken` is the mesh2 passport
/// token carried alongside it.
struct LoginResponse: Decodable {
    /// Bearer token for core.familytime.io. JSON key: `token`.
    let token: String
    /// Mesh2 passport token. JSON key: `passport_token`.
    let passportToken: String

    private enum CodingKeys: String, CodingKey {
        case token
        case passportToken = "passport_token" // TODO confirm server JSON
    }
}

/// Throwaway response for fire-and-forget calls (forgot-password) where only
/// success vs. failure matters and the body is ignored.
private struct EmptyResponse: Decodable {}

@MainActor
@Observable
final class LoginViewModel {

    // MARK: - State
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?
    var successMessage: String?
    var isAuthenticated = false

    // MARK: - Dependencies
    private let apiClient: APIClientProtocol
    private let sessionManager: SessionManaging

    init(apiClient: APIClientProtocol = APIClient.shared,
         sessionManager: SessionManaging = SessionManager.shared) {
        self.apiClient = apiClient
        self.sessionManager = sessionManager
    }

    // MARK: - Derived state

    /// Drives the login button's enabled state.
    var isLoginEnabled: Bool {
        email.isValidEmail && !password.isEmpty && !isLoading
    }

    // MARK: - Actions

    /// Email/password sign-in against `FamilyTimeEndpoint.login`.
    func login() async {
        guard email.isValidEmail, !password.isEmpty else {
            errorMessage = "Please enter a valid email and password."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response: LoginResponse = try await apiClient.request(
                FamilyTimeEndpoint.login(email: email,
                                         password: password,
                                         pushToken: Self.currentPushToken(),
                                         deviceId: Self.currentDeviceId())
            )
            persist(response)
            errorMessage = nil
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Sends a reset-password email for the current `email`.
    func forgotPassword() async {
        guard email.isValidEmail else {
            errorMessage = "Please enter a valid email address."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let _: EmptyResponse = try await apiClient.request(
                FamilyTimeEndpoint.forgotPassword(email: email)
            )
            errorMessage = nil
            successMessage = "Password reset instructions have been sent to your email."
        } catch let error as NetworkError {
            successMessage = nil
            errorMessage = error.errorDescription
        } catch {
            successMessage = nil
            errorMessage = error.localizedDescription
        }
    }

    /// Sign in with Apple. Extracts the identity token from the credential and
    /// exchanges it for a FamilyTime session.
    ///
    /// TODO: a dedicated Apple sign-in endpoint is needed. The legacy flow
    /// (`loginWithNewApiCore2` with `signInType: "apple"`) posted to the same
    /// `/dashboard/signin` route with `access_token` + `provider` fields, which
    /// `FamilyTimeEndpoint.login` does not yet carry. For now we reuse
    /// `.login`, sending the identity token as the password placeholder; replace
    /// with `FamilyTimeEndpoint.appleSignIn(identityToken:)` once added.
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) async {
        guard let tokenData = credential.identityToken,
              let identityToken = String(data: tokenData, encoding: .utf8) else {
            errorMessage = "Could not read your Apple credential. Please try again."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            // TODO replace with a dedicated Apple endpoint (see method docs).
            let response: LoginResponse = try await apiClient.request(
                FamilyTimeEndpoint.login(email: "",
                                         password: identityToken,
                                         pushToken: Self.currentPushToken(),
                                         deviceId: Self.currentDeviceId())
            )
            persist(response)
            errorMessage = nil
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Private

    /// Routes a successful login response into the session store.
    ///
    /// This is the canonical place the deferred Keychain flip completes for a
    /// NEW login: `saveSession` persists the bearer token through
    /// `KeychainService` (no plaintext UserDefaults). Note that the ~18 legacy
    /// UserDefaults token sites (`LoginApiToken`, `LoginAuthToken`, …) are
    /// still being migrated per-screen across Phase 2.
    private func persist(_ response: LoginResponse) {
        // `token` is the bearer for core.familytime.io -> ft.session.token
        sessionManager.saveSession(token: response.token)
        isAuthenticated = true
    }

    /// The current APNs push token, mirroring the legacy app which stores the
    /// hex device token in UserDefaults under the `"deviceToken"` key (see
    /// `SwiftAppDelegate.didRegisterForRemoteNotificationsWithDeviceToken`,
    /// `kDeviceToken`). Falls back to an empty string before registration.
    private static func currentPushToken() -> String {
        UserDefaults.standard.string(forKey: "deviceToken") ?? ""
    }

    /// A stable per-install device identifier.
    private static func currentDeviceId() -> String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
}
