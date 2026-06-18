//
//  ScreenTimeViewModel.swift
//  FamilyTime
//
//  Phase 2 — Screen Time. MVVM, @MainActor, async/await. No UIKit.
//

import Foundation

@MainActor
@Observable
final class ScreenTimeViewModel {

    // MARK: State

    private(set) var rules: [ScreenTimeRule] = []
    private(set) var dailyLimit: ScreenTimeDailyLimit?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: Dependencies

    private let repository: ScreenTimeRepositoryProtocol
    private let selectedChild: SelectedChildStore

    init(
        repository: ScreenTimeRepositoryProtocol = ScreenTimeRepository(),
        selectedChild: SelectedChildStore = .shared
    ) {
        self.repository = repository
        self.selectedChild = selectedChild
    }

    // MARK: Loading

    func load() async {
        guard let childId = selectedChild.selectedChildID else {
            errorMessage = "No child selected"
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            rules = try await repository.fetchRules(childId: childId)
            dailyLimit = try await repository.fetchDailyLimit(childId: childId)
            errorMessage = nil
        } catch {
            errorMessage = Self.message(for: error)
        }
    }

    // MARK: Mutations

    func saveRule(_ rule: ScreenTimeRule) async {
        guard let childId = selectedChild.selectedChildID else { return }
        do {
            if rule.id == nil {
                try await repository.createRule(childId: childId, rule: rule)
            } else {
                try await repository.updateRule(childId: childId, rule: rule)
            }
            await load()
        } catch {
            errorMessage = Self.message(for: error)
        }
    }

    func deleteRule(_ rule: ScreenTimeRule) async {
        guard let childId = selectedChild.selectedChildID, let ruleId = rule.id else { return }
        do {
            try await repository.deleteRule(childId: childId, ruleId: String(ruleId))
            await load()
        } catch {
            errorMessage = Self.message(for: error)
        }
    }

    func toggleActive(_ rule: ScreenTimeRule) async {
        var updated = rule
        updated.isActive.toggle()
        await saveRule(updated)
    }

    func updateDailyLimit(_ limit: ScreenTimeDailyLimit) async {
        guard let childId = selectedChild.selectedChildID else { return }
        do {
            try await repository.updateDailyLimit(childId: childId, limit: limit)
            dailyLimit = limit
        } catch {
            errorMessage = Self.message(for: error)
        }
    }

    // MARK: Helpers

    /// Prefers the localized description from `NetworkError`, falling back to
    /// the generic localized description for any other error type.
    private static func message(for error: Error) -> String {
        (error as? NetworkError)?.errorDescription ?? error.localizedDescription
    }
}
