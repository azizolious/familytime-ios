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
        try await apiClient.request(FamilyTimeEndpoint.dashboardCore2(childId: childId))
    }

    func fetchAccount() async throws -> AccountModel {
        try await apiClient.request(FamilyTimeEndpoint.accountInfo)
    }
}
