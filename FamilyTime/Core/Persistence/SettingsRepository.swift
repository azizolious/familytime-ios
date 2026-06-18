//
//  SettingsRepository.swift
//  FamilyTime
//
//  Network-only persistence seam for the Settings & Account feature.
//  Mirrors the established repository pattern (see ScreenTimeRepository /
//  LocationRepository): an injectable `APIClientProtocol`, decoding into
//  `EmptyDecodableResponse` for void-ish writes, and tolerant envelope
//  decoding for reads.
//
//  SwiftData caching is intentionally deferred; this type is the single
//  read/write seam so callers will not change when caching is added.
//

import Foundation

// MARK: - Protocol

/// Abstraction over Settings & Account persistence so view models can be
/// exercised with mocks.
protocol SettingsRepositoryProtocol {
    func fetchAccount() async throws -> Profile
    func updateProfile(params: [String: String]) async throws
    func changePassword(current: String, new: String) async throws
    func fetchCoParents() async throws -> [FTCoParent]
    func inviteCoParent(email: String, name: String) async throws
    func removeCoParent(id: String) async throws
    func deleteChild(childId: String) async throws
    func logout() async throws
}

// MARK: - Implementation

final class SettingsRepository: SettingsRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    // MARK: Account

    func fetchAccount() async throws -> Profile {
        // The account endpoint returns the `AccountModel` envelope
        // ({ "profile": { ... }, "billing": { ... } }); we only need
        // the profile here.
        // TODO confirm account JSON envelope with backend.
        let response: AccountModel =
            try await apiClient.request(FamilyTimeEndpoint.accountInfo)
        guard let profile = response.profile else {
            throw NetworkError.noData
        }
        return profile
    }

    func updateProfile(params: [String: String]) async throws {
        // Write; response shape is irrelevant, decode into a throwaway and discard.
        // TODO confirm server JSON shape with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.updateProfile(params: params)
        )
    }

    func changePassword(current: String, new: String) async throws {
        // TODO confirm server JSON shape with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.changePassword(currentPassword: current, newPassword: new)
        )
    }

    // MARK: Co-parents

    func fetchCoParents() async throws -> [FTCoParent] {
        // Decode the envelope and fall back to an empty list.
        // TODO confirm server JSON shape with backend.
        let response: CoParentResponse =
            try await apiClient.request(FamilyTimeEndpoint.coParentList)
        return response.data ?? []
    }

    func inviteCoParent(email: String, name: String) async throws {
        // TODO confirm server JSON shape with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.coParentInvite(email: email, name: name)
        )
    }

    func removeCoParent(id: String) async throws {
        // TODO confirm server JSON shape with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.removeCoParent(coParentId: id)
        )
    }

    // MARK: Child

    func deleteChild(childId: String) async throws {
        // TODO confirm server JSON shape with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.deleteChild(childId: childId)
        )
    }

    // MARK: Session

    func logout() async throws {
        // Best-effort server-side logout. Local session teardown is the
        // caller's responsibility (see SettingsViewModel.logout()).
        // TODO confirm server JSON shape with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.logout
        )
    }
}
