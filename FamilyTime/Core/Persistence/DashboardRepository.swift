//
//  DashboardRepository.swift
//  FamilyTime
//
//  Scope: First Dashboard increment — read-only home + account fetch.
//  TODO(Phase 2): Core Data persistence, config/notifications endpoints, token refresh.
//

import Foundation

/// Read-only data access for the Dashboard feature.
protocol DashboardRepositoryProtocol {
    func fetchHome(childId: String) async throws -> HomeResponse
    func fetchAccount() async throws -> AccountModel
}

/// Default implementation backed by `APIClient`.
final class DashboardRepository: DashboardRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchHome(childId: String) async throws -> HomeResponse {
        // `/v1/home` returns the full children list regardless of child id, so the
        // `childId` parameter is retained only for call-site parity (the caller may
        // still use it to pick a default selection from the response).
        _ = childId
        return try await apiClient.request(FamilyTimeEndpoint.home)
    }

    func fetchAccount() async throws -> AccountModel {
        try await apiClient.request(FamilyTimeEndpoint.accountInfo)
    }
}
