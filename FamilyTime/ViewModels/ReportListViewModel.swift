//
//  ReportListViewModel.swift
//  FamilyTime
//
//  View model for the list-style reports (Web History, Web Search, YouTube,
//  TikTok). Foundation only — no UIKit / SwiftUI. `@Observable` (iOS 17), not
//  `ObservableObject`. No force-unwraps. Async/await only.
//

import Foundation

// MARK: - ReportKind

/// The list-style report categories backed by `[ReportEntry]`.
enum ReportKind: String, CaseIterable, Identifiable {
    case webHistory
    case youtube
    case tiktok

    var id: String { rawValue }

    /// Human-readable title for the report category.
    var title: String {
        switch self {
        case .webHistory: return "Web History"
        case .youtube:    return "YouTube"
        case .tiktok:     return "TikTok"
        }
    }
}

// MARK: - ReportListViewModel

@MainActor
@Observable
final class ReportListViewModel {

    private(set) var entries: [ReportEntry] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    /// Bound by the view's date picker.
    var selectedDate = Date()

    let kind: ReportKind

    private let repository: ReportRepositoryProtocol
    private let selectedChild: SelectedChildStore

    init(
        kind: ReportKind,
        repository: ReportRepositoryProtocol = ReportRepository(),
        selectedChild: SelectedChildStore = .shared
    ) {
        self.kind = kind
        self.repository = repository
        self.selectedChild = selectedChild
    }

    /// Loads entries for the current `kind`, `selectedDate`, and selected child.
    func load() async {
        guard let cid = selectedChild.selectedChildID else {
            errorMessage = "No child selected"
            entries = []
            return
        }

        isLoading = true
        defer { isLoading = false }

        // TODO confirm date format with backend.
        let dateStr = Self.apiFormatter.string(from: selectedDate)

        do {
            switch kind {
            case .webHistory:
                entries = try await repository.fetchWebHistory(childId: cid, startDate: dateStr)
            case .youtube:
                entries = try await repository.fetchYouTube(childId: cid, startDate: dateStr)
            case .tiktok:
                entries = try await repository.fetchTikTok(childId: cid, startDate: dateStr)
            }
            errorMessage = nil
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private static let apiFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
}
