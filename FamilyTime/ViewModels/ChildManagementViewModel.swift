//
//  ChildManagementViewModel.swift
//  FamilyTime
//
//  Drives the destructive "remove child" action for the currently selected
//  child. Add / edit of children is deferred; this view model handles only
//  the DELETE. The UI MUST present a confirmation before calling
//  `deleteSelectedChild()`.
//

import Foundation

@MainActor
@Observable
final class ChildManagementViewModel {

    // MARK: UI state
    private(set) var isDeleting = false
    private(set) var errorMessage: String?
    private(set) var didDelete = false

    private let repository: SettingsRepositoryProtocol
    private let selectedChild: SelectedChildStore

    init(
        repository: SettingsRepositoryProtocol = SettingsRepository(),
        selectedChild: SelectedChildStore = .shared
    ) {
        self.repository = repository
        self.selectedChild = selectedChild
    }

    /// Human-readable name of the child slated for deletion, for confirmation copy.
    var selectedChildName: String {
        // `ChildData` exposes its display name via `childInfo?.name`.
        selectedChild.selectedChild?.childInfo?.name ?? "this child"
    }

    /// Deletes the currently selected child. Caller must confirm first.
    func deleteSelectedChild() async {
        guard let childId = selectedChild.selectedChildID else {
            errorMessage = "No child selected"
            return
        }
        isDeleting = true
        errorMessage = nil
        didDelete = false
        defer { isDeleting = false }
        do {
            try await repository.deleteChild(childId: childId)
            didDelete = true
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
