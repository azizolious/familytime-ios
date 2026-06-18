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

    /// Returns `true` once the child's device has completed pairing.
    func checkPairingStatus(childId: String) async throws -> Bool
}

// MARK: - Response models
//
// The shared APIClient uses a plain JSONDecoder (no keyDecodingStrategy), so
// each model declares explicit snake_case CodingKeys.
// TODO confirm server JSON envelopes with backend (audit-derived).

/// Response for the core2 `/generate-qr-code` endpoint: `{ "qr_code": "..." }`.
struct QRCodeResponse: Decodable {
    let qrCode: String

    enum CodingKeys: String, CodingKey {
        case qrCode = "qr_code"
    }
}

/// A single paired device as returned by `/devices`. We only need the child id
/// to decide whether a given child has completed pairing; the id may arrive as a
/// String or an Int depending on the writer, so decoding is tolerant.
/// TODO confirm devices JSON shape with backend.
struct PairedDevice: Decodable {
    let childId: String?

    enum CodingKeys: String, CodingKey {
        case childId = "child_id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let intID = try? container.decode(Int.self, forKey: .childId) {
            childId = String(intID)
        } else {
            childId = try container.decodeIfPresent(String.self, forKey: .childId)
        }
    }
}

/// Response for `/devices`. The device list may arrive at the top level (a bare
/// array) or nested under a `data` envelope, so both are tolerated.
/// TODO confirm devices JSON envelope with backend.
struct DevicesResponse: Decodable {
    let devices: [PairedDevice]

    private enum CodingKeys: String, CodingKey {
        case data
    }

    init(from decoder: Decoder) throws {
        if let array = try? decoder.singleValueContainer().decode([PairedDevice].self) {
            devices = array
        } else if let container = try? decoder.container(keyedBy: CodingKeys.self),
                  let nested = try? container.decodeIfPresent([PairedDevice].self, forKey: .data) {
            devices = nested
        } else {
            devices = []
        }
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
        // POST /generate-qr-code (no child id); returns { "qr_code": ... }. The
        // generated code is account-scoped — a child appears under /devices once
        // its device scans the code and pairs.
        // TODO confirm server JSON shape with backend.
        _ = childId
        let response: QRCodeResponse =
            try await apiClient.request(FamilyTimeEndpoint.generateQRCode)
        return response.qrCode
    }

    func checkPairingStatus(childId: String) async throws -> Bool {
        // Pairing is now derived from /devices: a child is "paired" once its
        // device shows up in the account's device list.
        // TODO confirm devices→pairing mapping with backend.
        let response: DevicesResponse =
            try await apiClient.request(FamilyTimeEndpoint.devices)
        return response.devices.contains { $0.childId == childId }
    }
}
