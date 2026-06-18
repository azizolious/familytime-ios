//
//  CoParentViewModel.swift
//  FamilyTime
//
//  Drives the co-parent management screen: lists co-parents, invites new
//  ones by email, and removes existing ones. Network-only.
//

import Foundation

@MainActor
@Observable
final class CoParentViewModel {

    // MARK: Loaded state
    private(set) var coParents: [FTCoParent] = []

    // MARK: Invite fields (bound to UI)
    var inviteEmail = ""
    var inviteName = ""

    // MARK: UI state
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var didInvite = false

    private let repository: SettingsRepositoryProtocol

    init(repository: SettingsRepositoryProtocol = SettingsRepository()) {
        self.repository = repository
    }

    /// Fetches the current list of co-parents.
    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            coParents = try await repository.fetchCoParents()
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Invites a co-parent, then refreshes the list.
    func invite() async {
        guard isValidEmail(inviteEmail) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        errorMessage = nil
        didInvite = false
        do {
            try await repository.inviteCoParent(email: inviteEmail, name: inviteName)
            didInvite = true
            await load()
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Removes a co-parent, then refreshes the list.
    func remove(_ coParent: FTCoParent) async {
        errorMessage = nil
        do {
            try await repository.removeCoParent(id: coParent.id)
            await load()
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Helpers

    private func isValidEmail(_ email: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        // Minimal structural check: a local part, an "@", and a dotted domain.
        let pattern = "^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"
        return trimmed.range(of: pattern, options: .regularExpression) != nil
    }
}
