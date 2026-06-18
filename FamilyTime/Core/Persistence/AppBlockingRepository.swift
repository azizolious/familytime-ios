//
//  AppBlockingRepository.swift
//  FamilyTime
//
//  Persistence seam for App-Blocking & Content-Filtering. Backed by APIClient.
//  View models depend on the protocol so they can be tested with mocks.
//
//  TODO confirm server JSON shape with backend (derived from a code audit).
//

import Foundation

// MARK: - Protocol

/// Abstraction over app-blocking & content-filter persistence.
protocol AppBlockingRepositoryProtocol {
    func fetchApps(childId: String) async throws -> [BlockableApp]
    func setBlocked(childId: String, appId: String, blocked: Bool) async throws
    func fetchContentFilters(childId: String) async throws -> [ContentFilterSetting]
    func updateContentFilters(id: Int, childId: String, mdmPayload: String) async throws
}

// MARK: - Implementation

final class AppBlockingRepository: AppBlockingRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    // MARK: Installed apps

    func fetchApps(childId: String) async throws -> [BlockableApp] {
        // The endpoint may return a bare array or nest it under `data`.
        // TODO confirm server JSON shape with backend.
        let response: AppBlockingResponse<[BlockableApp]> =
            try await apiClient.request(FamilyTimeEndpoint.installedApps(childId: childId))
        return response.data ?? []
    }

    func setBlocked(childId: String, appId: String, blocked: Bool) async throws {
        // Block = toggle `is_blacklisted` (1 = blocked, 0 = unblocked).
        // TODO confirm server JSON shape with backend.
        let body = AppBlockBody(isBlacklisted: blocked ? 1 : 0)
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.setAppBlocked(childId: childId, appId: appId, body: body)
        )
    }

    // MARK: Content filters

    func fetchContentFilters(childId: String) async throws -> [ContentFilterSetting] {
        // TODO confirm server JSON shape with backend.
        let response: AppBlockingResponse<ContentFilterPayload> =
            try await apiClient.request(FamilyTimeEndpoint.contentFilters(childId: childId))
        let enabled = response.data?.categories ?? [:]

        // Project the fixed category list onto whatever the server reported,
        // defaulting any unknown/missing category to off.
        return ContentFilterCategory.allCases.map { category in
            ContentFilterSetting(
                id: category.rawValue,
                title: category.localizedTitle,
                isOn: enabled[category.rawValue] ?? false
            )
        }
    }

    func updateContentFilters(id: Int, childId: String, mdmPayload: String) async throws {
        // TODO confirm server JSON shape with backend.
        let body = ContentFilterBody(id: id, childId: childId, mdmPayload: mdmPayload)
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.updateContentFilters(body: body)
        )
    }
}
