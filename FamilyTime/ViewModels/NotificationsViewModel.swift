import Foundation

/// Drives the notifications screen: loads the feed and exposes loading/error state.
///
/// Reuses the existing `FeedDatum` model; the repository is protocol-injected so
/// the view model can be unit tested with a stubbed `NotificationRepositoryProtocol`.
@MainActor
@Observable
final class NotificationsViewModel {
    private(set) var feed: [FeedDatum] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let repository: NotificationRepositoryProtocol

    /// - Parameter repository: Feed data source, defaulting to the live repository.
    init(repository: NotificationRepositoryProtocol = NotificationRepository()) {
        self.repository = repository
    }

    /// Loads the notification feed, updating `feed`, `isLoading`, and `errorMessage`.
    func load() async {
        isLoading = true
        defer { isLoading = false }

        do {
            feed = try await repository.fetchFeed()
            errorMessage = nil
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
