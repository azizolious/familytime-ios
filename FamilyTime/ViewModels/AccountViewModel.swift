//
//  AccountViewModel.swift
//  FamilyTime
//
//  Drives the Account profile screen: loads the signed-in user's profile and
//  persists edits. Network-only; no local mutation of the `Profile` is cached.
//

import Foundation

@MainActor
@Observable
final class AccountViewModel {

    // MARK: Loaded state
    private(set) var profile: Profile?

    // MARK: Editable fields (bound to UI)
    var name = ""
    var phone = ""
    var relationship = ""
    var language = ""

    // MARK: UI state
    private(set) var isLoading = false
    private(set) var isSaving = false
    private(set) var errorMessage: String?
    private(set) var didSave = false

    private let repository: SettingsRepositoryProtocol

    init(repository: SettingsRepositoryProtocol = SettingsRepository()) {
        self.repository = repository
    }

    /// Fetches the account profile and seeds the editable fields.
    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let profile = try await repository.fetchAccount()
            self.profile = profile
            name = profile.name ?? ""
            phone = profile.phone ?? ""
            // `relationship` is surfaced via the backend `type` field on Profile.
            relationship = profile.type ?? ""
            language = profile.language ?? ""
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Persists the editable fields back to the server.
    func save() async {
        isSaving = true
        errorMessage = nil
        didSave = false
        defer { isSaving = false }
        do {
            try await repository.updateProfile(params: [
                "name": name,
                "phone": phone,
                "relationship": relationship,
                "language": language
            ])
            didSave = true
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
