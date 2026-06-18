//
//  ChangePasswordViewModel.swift
//  FamilyTime
//
//  Drives the change-password screen.
//
//  SECURITY: passwords are NEVER persisted. They live only in the
//  @State-bound fields below for the lifetime of the screen and are passed
//  straight to the network layer. No UserDefaults / Keychain / disk writes.
//

import Foundation

@MainActor
@Observable
final class ChangePasswordViewModel {

    // MARK: Editable fields (bound to UI; never persisted)
    var currentPassword = ""
    var newPassword = ""
    var confirmPassword = ""

    // MARK: UI state
    private(set) var isSubmitting = false
    private(set) var errorMessage: String?
    private(set) var didChange = false

    private let repository: SettingsRepositoryProtocol

    init(repository: SettingsRepositoryProtocol = SettingsRepository()) {
        self.repository = repository
    }

    /// Whether the form is in a submittable state.
    var canSubmit: Bool {
        !currentPassword.isEmpty
            && newPassword.count >= 6
            && newPassword == confirmPassword
    }

    /// Submits the password change. Validates locally first.
    func submit() async {
        guard canSubmit else {
            errorMessage = "Passwords must match (min 6 chars)"
            return
        }
        isSubmitting = true
        errorMessage = nil
        didChange = false
        defer { isSubmitting = false }
        do {
            try await repository.changePassword(current: currentPassword, new: newPassword)
            didChange = true
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
