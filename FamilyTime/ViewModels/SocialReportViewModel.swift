//
//  SocialReportViewModel.swift
//  FamilyTime
//
//  View model for the social-monitoring report, backed by `[SocialMessage]`.
//  Foundation only — no UIKit / SwiftUI. `@Observable` (iOS 17), not
//  `ObservableObject`. No force-unwraps. Async/await only.
//

import Foundation

@MainActor
@Observable
final class SocialReportViewModel {

    private(set) var messages: [SocialMessage] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    /// Bound by the view's date picker.
    var selectedDate = Date()

    /// The social app package to query. // TODO confirm package values with backend.
    var appPackage: String = "com.whatsapp"

    private let repository: ReportRepositoryProtocol
    private let selectedChild: SelectedChildStore

    init(
        repository: ReportRepositoryProtocol = ReportRepository(),
        selectedChild: SelectedChildStore = .shared
    ) {
        self.repository = repository
        self.selectedChild = selectedChild
    }

    /// Messages grouped by contact, preserving first-seen order. Messages with a
    /// nil `contactName` are grouped under "Unknown".
    var groupedByContact: [(contact: String, messages: [SocialMessage])] {
        var order: [String] = []
        var buckets: [String: [SocialMessage]] = [:]

        for message in messages {
            let contact = message.contactName ?? "Unknown"
            if buckets[contact] == nil {
                buckets[contact] = []
                order.append(contact)
            }
            buckets[contact, default: []].append(message)
        }

        return order.map { contact in
            (contact: contact, messages: buckets[contact] ?? [])
        }
    }

    /// Loads social messages for the current `appPackage`, `selectedDate`, and
    /// selected child.
    func load() async {
        guard let cid = selectedChild.selectedChildID else {
            errorMessage = "No child selected"
            messages = []
            return
        }

        isLoading = true
        defer { isLoading = false }

        // TODO confirm date format with backend.
        let dateStr = Self.apiFormatter.string(from: selectedDate)

        do {
            messages = try await repository.fetchSocial(
                childId: cid,
                date: dateStr,
                appPackage: appPackage,
                page: 1
            )
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
