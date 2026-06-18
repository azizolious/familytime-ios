//
//  ReportRepository.swift
//  FamilyTime
//
//  Network-only data source for Reports & History.
//
//  Foundation only — no UIKit / SwiftUI. No force-unwraps. Async/await only
//  (no completion handlers). Each fetch hits a `FamilyTimeEndpoint`, decodes the
//  legacy `ReportResponse<Payload>` envelope, and returns the unwrapped payload
//  (empty array when `data` is nil).
//
//  TODO: Core Data / SwiftData caching is deferred for this milestone — this
//  repository is intentionally network-only. A cache-backed implementation can
//  later conform to `ReportRepositoryProtocol` without touching call sites.
//

import Foundation

// MARK: - Protocol

/// Read access to the reporting endpoints. Protocol-based so view models can be
/// driven by mocks in tests.
protocol ReportRepositoryProtocol {
    func fetchWebHistory(childId: String, startDate: String) async throws -> [ReportEntry]
    func fetchYouTube(childId: String, startDate: String) async throws -> [ReportEntry]
    func fetchTikTok(childId: String, startDate: String) async throws -> [ReportEntry]
    func fetchSocial(childId: String, startDate: String, appPackage: String) async throws -> [SocialMessage]
}

// MARK: - Implementation

/// Default network-backed implementation of `ReportRepositoryProtocol`.
final class ReportRepository: ReportRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchWebHistory(childId: String, startDate: String) async throws -> [ReportEntry] {
        let resp: ReportResponse<[ReportEntry]> = try await apiClient.request(
            FamilyTimeEndpoint.webHistory(childId: childId, startDate: startDate)
        )
        return resp.data ?? []
    }

    func fetchYouTube(childId: String, startDate: String) async throws -> [ReportEntry] {
        let resp: ReportResponse<[ReportEntry]> = try await apiClient.request(
            FamilyTimeEndpoint.youtubeHistory(childId: childId, startDate: startDate)
        )
        return resp.data ?? []
    }

    func fetchTikTok(childId: String, startDate: String) async throws -> [ReportEntry] {
        let resp: ReportResponse<[ReportEntry]> = try await apiClient.request(
            FamilyTimeEndpoint.tikTokHistory(childId: childId, startDate: startDate)
        )
        return resp.data ?? []
    }

    func fetchSocial(childId: String, startDate: String, appPackage: String) async throws -> [SocialMessage] {
        let resp: ReportResponse<[SocialMessage]> = try await apiClient.request(
            FamilyTimeEndpoint.socialMonitoring(childId: childId, startDate: startDate)
        )
        // `app_package` is no longer a server-side filter; apply it client-side.
        return (resp.data ?? []).filter { $0.appPackage == appPackage }
    }
}
