//
//  OnboardingRepository.swift
//  FamilyTime
//
//  Network-only persistence seam for the Onboarding / Device-Pairing feature.
//  Mirrors the established repository pattern (see SettingsRepository /
//  ScreenTimeRepository): an injectable `APIClientProtocol`, tolerant envelope
//  decoding for reads, and `EmptyDecodableResponse` discards for void-ish writes.
//
//  Scope: parity sprint — QR generation, child creation, and pairing-status
//  polling for the SwiftUI onboarding flow. Endpoints are owned by the
//  networking layer (FamilyTimeEndpoints.swift); this type only composes them.
//

import Foundation

// MARK: - Protocol

/// Abstraction over Onboarding & Pairing persistence so view models can be
/// exercised with mocks.
protocol OnboardingRepositoryProtocol {
    /// Fetches the QR payload string used to pair the child's device.
    func fetchQRCode(childId: String) async throws -> String

    /// Creates a child profile and returns the new child's id.
    func addChild(
        name: String,
        platform: String,
        relationship: String?,
        gender: String?,
        age: String?
    ) async throws -> String

    /// Returns `true` once the child's device has completed pairing.
    func checkPairingStatus(childId: String) async throws -> Bool
}

// MARK: - Response models
//
// The shared APIClient uses a plain JSONDecoder (no keyDecodingStrategy), so
// each model declares explicit snake_case CodingKeys.
// TODO confirm server JSON envelopes with backend (audit-derived).

/// Response for the legacy core2 `/generate-qr-code` endpoint: `{ "qr_code": "..." }`.
struct QRCodeResponse: Decodable {
    let qrCode: String

    enum CodingKeys: String, CodingKey {
        case qrCode = "qr_code"
    }
}

/// Response for `/child/add`. The new child id may arrive at the top level or
/// nested under a `data` envelope, so both are tolerated.
/// TODO confirm child-create JSON envelope with backend.
struct AddChildResponse: Decodable {
    let childId: String

    private struct DataEnvelope: Decodable {
        let childId: String

        enum CodingKeys: String, CodingKey {
            case childId = "child_id"
        }
    }

    enum CodingKeys: String, CodingKey {
        case childId = "child_id"
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let topLevel = try container.decodeIfPresent(String.self, forKey: .childId) {
            childId = topLevel
        } else if let envelope = try container.decodeIfPresent(DataEnvelope.self, forKey: .data) {
            childId = envelope.childId
        } else {
            throw NetworkError.noData
        }
    }
}

/// Response for `/child/{id}/status`: `{ "paired": true }`.
/// TODO confirm pairing-status JSON envelope with backend.
struct PairingStatusResponse: Decodable {
    let paired: Bool

    enum CodingKeys: String, CodingKey {
        case paired
    }
}

// MARK: - Implementation

/// Default implementation backed by `APIClient`.
final class OnboardingRepository: OnboardingRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchQRCode(childId: String) async throws -> String {
        // POST /generate-qr-code with { "child_id": ... }; returns { "qr_code": ... }.
        // TODO confirm server JSON shape with backend.
        let response: QRCodeResponse =
            try await apiClient.request(FamilyTimeEndpoint.pairingQRCode(childId: childId))
        return response.qrCode
    }

    func addChild(
        name: String,
        platform: String,
        relationship: String?,
        gender: String?,
        age: String?
    ) async throws -> String {
        // TODO confirm server JSON shape with backend.
        let body = ChildCreateBody(
            name: name,
            platform: platform,
            relationship: relationship,
            gender: gender,
            age: age
        )
        let response: AddChildResponse =
            try await apiClient.request(FamilyTimeEndpoint.addChild(body: body))
        return response.childId
    }

    func checkPairingStatus(childId: String) async throws -> Bool {
        // TODO confirm server JSON shape with backend.
        let response: PairingStatusResponse =
            try await apiClient.request(FamilyTimeEndpoint.pairingStatus(childId: childId))
        return response.paired
    }
}
