import Foundation

/// Provides access to the notification feed, abstracting the data source so
/// callers (e.g. `NotificationsViewModel`) can be exercised with mocks.
protocol NotificationRepositoryProtocol {
    /// Fetches the latest notification feed entries.
    /// - Returns: The decoded `FeedDatum` items from the feed response.
    /// - Throws: `NetworkError` (or another error) if the request fails.
    func fetchFeed() async throws -> [FeedDatum]
}

/// Default implementation backed by the networking layer.
///
/// Reuses the existing `NotificationFeedModel` / `FeedDatum` Codable models
/// (defined in `Swift/Models/NotificationFeedModel.swift`) rather than
/// redefining any response types here.
final class NotificationRepository: NotificationRepositoryProtocol {
    private let apiClient: APIClientProtocol

    /// - Parameter apiClient: Networking abstraction, defaulting to the shared client.
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchFeed() async throws -> [FeedDatum] {
        let response: NotificationFeedModel = try await apiClient.request(FamilyTimeEndpoint.notificationFeed)
        return response.feedData
    }

    // TODO: CoreData caching of the feed is a Phase-2 follow-up. Cache the
    // decoded feed locally and serve it as a fast first paint before the
    // network response resolves.
}
