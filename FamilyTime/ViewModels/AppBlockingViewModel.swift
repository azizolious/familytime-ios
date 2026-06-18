//
//  AppBlockingViewModel.swift
//  FamilyTime
//
//  App-Blocking & Content-Filtering. MVVM, @MainActor, @Observable, async/await.
//  No UIKit, no force-unwraps.
//

import Foundation

@MainActor
@Observable
final class AppBlockingViewModel {

    // MARK: State

    private(set) var apps: [BlockableApp] = []
    private(set) var contentFilters: [ContentFilterSetting] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    /// The content-filter record id needed for updates. Captured on load.
    /// `nil` until the server reports one.
    private(set) var contentFilterRecordId: Int?

    // MARK: Dependencies

    private let repository: AppBlockingRepositoryProtocol
    private let selectedChild: SelectedChildStore

    init(
        repository: AppBlockingRepositoryProtocol = AppBlockingRepository(),
        selectedChild: SelectedChildStore = .shared
    ) {
        self.repository = repository
        self.selectedChild = selectedChild
    }

    // MARK: Derived state

    /// Apps grouped by `appCategory`, with a stable, sorted section ordering.
    /// Apps without a category fall under the generic "app" bucket.
    var groupedApps: [(category: String, apps: [BlockableApp])] {
        let groups = Dictionary(grouping: apps) { $0.appCategory ?? "app" }
        return groups
            .map { (category: $0.key, apps: $0.value.sorted { lhsName($0) < lhsName($1) }) }
            .sorted { sortRank(for: $0.category) < sortRank(for: $1.category) }
    }

    /// Display title for a category bucket (system / important / app), localized.
    func title(for category: String) -> String {
        switch category {
        case "system":
            return String(localized: "appblocking.category.system")
        case "important":
            return String(localized: "appblocking.category.important")
        default:
            return String(localized: "appblocking.category.app")
        }
    }

    // MARK: Loading

    func load() async {
        guard let childId = selectedChild.selectedChildID else {
            errorMessage = String(localized: "appblocking.error.no_child")
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            apps = try await repository.fetchApps(childId: childId)
            contentFilters = try await repository.fetchContentFilters(childId: childId)
            errorMessage = nil
        } catch {
            errorMessage = Self.message(for: error)
        }
    }

    // MARK: App blocking

    /// Toggles the blocked state of an app. Applies the change optimistically and
    /// rolls back on failure.
    func toggleBlock(_ app: BlockableApp) async {
        guard let childId = selectedChild.selectedChildID else {
            errorMessage = String(localized: "appblocking.error.no_child")
            return
        }
        let newValue = !app.isBlacklisted

        // Optimistic update.
        apply(app.setting(blocked: newValue))

        do {
            try await repository.setBlocked(childId: childId, appId: app.id, blocked: newValue)
            errorMessage = nil
        } catch {
            // Roll back to the prior value.
            apply(app)
            errorMessage = Self.message(for: error)
        }
    }

    // MARK: Content filters

    /// Toggles a content-filter category. Applies optimistically and rolls back
    /// on failure.
    func setFilter(_ setting: ContentFilterSetting, on: Bool) async {
        guard let childId = selectedChild.selectedChildID else {
            errorMessage = String(localized: "appblocking.error.no_child")
            return
        }
        guard let recordId = contentFilterRecordId ?? defaultRecordId() else {
            // Without a record id we cannot build a valid update body.
            errorMessage = String(localized: "appblocking.error.filter_unavailable")
            return
        }

        let previous = contentFilters
        applyFilter(id: setting.id, on: on)

        do {
            let payload = buildMDMPayload()
            try await repository.updateContentFilters(
                id: recordId,
                childId: childId,
                mdmPayload: payload
            )
            errorMessage = nil
        } catch {
            contentFilters = previous
            errorMessage = Self.message(for: error)
        }
    }

    // MARK: Mutation helpers

    private func apply(_ updated: BlockableApp) {
        if let index = apps.firstIndex(where: { $0.id == updated.id }) {
            apps[index] = updated
        }
    }

    private func applyFilter(id: String, on: Bool) {
        if let index = contentFilters.firstIndex(where: { $0.id == id }) {
            contentFilters[index].isOn = on
        }
    }

    /// Builds the MDM payload string from the current filter state.
    /// TODO confirm exact MDM payload encoding with backend.
    private func buildMDMPayload() -> String {
        let enabled = Dictionary(
            uniqueKeysWithValues: contentFilters.map { ($0.id, $0.isOn) }
        )
        guard
            let data = try? JSONSerialization.data(withJSONObject: enabled),
            let string = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }
        return string
    }

    /// Fallback record id when the server has not yet provided one.
    /// TODO confirm whether a default/create id is required by backend.
    private func defaultRecordId() -> Int? {
        contentFilterRecordId
    }

    // MARK: Sorting helpers

    private func lhsName(_ app: BlockableApp) -> String {
        (app.appName ?? app.appPackageName ?? app.id).lowercased()
    }

    private func sortRank(for category: String) -> Int {
        switch category {
        case "important": return 0
        case "app": return 1
        case "system": return 2
        default: return 3
        }
    }

    // MARK: Error mapping

    private static func message(for error: Error) -> String {
        (error as? NetworkError)?.errorDescription ?? error.localizedDescription
    }
}
