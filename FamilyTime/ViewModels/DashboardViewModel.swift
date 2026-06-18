//
//  DashboardViewModel.swift
//  FamilyTime
//
//  Phase 2 Dashboard.
//
//  Scope (first increment): load the children list, the parent account
//  profile, and surface the current entitlement (premium) state. Loading and
//  error state are exposed for the view to render.
//
//  TODO(Phase 2): lock/limit actions, notifications feed, config flags,
//  cross-screen selection propagation, Core Data persistence.
//

import Foundation

@MainActor
@Observable
final class DashboardViewModel {

    // MARK: - State

    private(set) var children: [ChildData] = []
    /// Parent profile from the account endpoint (`AccountModel.profile`).
    private(set) var account: Profile?
    /// `ChildInfo.childID` is `Int?` in the model, so the selected id is held as
    /// a `String` to match `DashboardRepositoryProtocol.fetchHome(childId:)`.
    var selectedChildID: String?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let repository: DashboardRepositoryProtocol
    private let entitlement: EntitlementService

    init(
        repository: DashboardRepositoryProtocol = DashboardRepository(),
        entitlement: EntitlementService = .shared
    ) {
        self.repository = repository
        self.entitlement = entitlement
    }

    // MARK: - Derived State

    var isPremium: Bool { entitlement.isPremium }

    // MARK: - Loading

    func load() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // The home endpoint returns the full children list regardless of the
            // child id passed; pass the current selection (or empty) for parity.
            let home = try await repository.fetchHome(childId: selectedChildID ?? "")
            children = home.data?.children ?? []

            if selectedChildID == nil, let firstID = children.first?.childInfo?.childID {
                selectedChildID = String(firstID)
            }

            let acct = try await repository.fetchAccount()
            account = acct.profile

            errorMessage = nil
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Selection

    func select(_ child: ChildData) {
        guard let id = child.childInfo?.childID else { return }
        selectedChildID = String(id)
    }
}
