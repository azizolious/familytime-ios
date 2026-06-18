//
//  ScreenTimeRepository.swift
//  FamilyTime
//
//  TODO: Backed by APIClient now. Core Data caching of rules is a Phase-2
//        follow-up — when added, this repository becomes the single read/write
//        seam and callers should not change.
//

import Foundation

// MARK: - Protocol

/// Abstraction over screen-time persistence so view models can be tested with mocks.
protocol ScreenTimeRepositoryProtocol {
    func fetchRules(childId: String) async throws -> [ScreenTimeRule]
    func createRule(childId: String, rule: ScreenTimeRule) async throws
    func updateRule(childId: String, rule: ScreenTimeRule) async throws
    func deleteRule(childId: String, ruleId: String) async throws
    func fetchDailyLimit(childId: String) async throws -> ScreenTimeDailyLimit
    func updateDailyLimit(childId: String, limit: ScreenTimeDailyLimit) async throws
}

// MARK: - Implementation

final class ScreenTimeRepository: ScreenTimeRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    // MARK: Rules

    func fetchRules(childId: String) async throws -> [ScreenTimeRule] {
        // The endpoint may return a bare array or nest it under `data`.
        // Decode the envelope and fall back to an empty list.
        // TODO confirm server JSON shape with backend.
        let response: ScreenTimeResponse<[ScreenTimeRule]> =
            try await apiClient.request(FamilyTimeEndpoint.screenTimeRules(childId: childId))
        return response.data ?? []
    }

    func createRule(childId: String, rule: ScreenTimeRule) async throws {
        // Response shape for writes is unknown; decode into a throwaway and discard.
        // TODO confirm server JSON shape with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.createScreenTimeRule(childId: childId, body: rule.ruleBody)
        )
    }

    func updateRule(childId: String, rule: ScreenTimeRule) async throws {
        guard let id = rule.id else {
            // Cannot update a rule that has not been created yet.
            throw NetworkError.invalidURL // TODO confirm a more specific error case
        }
        // TODO confirm server JSON shape with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.updateScreenTimeRule(
                childId: childId,
                ruleId: String(id),
                body: rule.ruleBody
            )
        )
    }

    func deleteRule(childId: String, ruleId: String) async throws {
        // TODO confirm server JSON shape with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.deleteScreenTimeRule(childId: childId, ruleId: ruleId)
        )
    }

    // MARK: Daily limit

    func fetchDailyLimit(childId: String) async throws -> ScreenTimeDailyLimit {
        // TODO confirm server JSON shape with backend.
        let response: ScreenTimeResponse<ScreenTimeDailyLimit> =
            try await apiClient.request(FamilyTimeEndpoint.dailyLimit(childId: childId))
        guard let limit = response.data else {
            throw NetworkError.noData
        }
        return limit
    }

    func updateDailyLimit(childId: String, limit: ScreenTimeDailyLimit) async throws {
        // TODO confirm server JSON shape with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.updateDailyLimit(childId: childId, body: limit.updateBody)
        )
    }
}
