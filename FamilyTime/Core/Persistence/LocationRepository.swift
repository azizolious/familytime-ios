//
//  LocationRepository.swift
//  FamilyTime
//
//  Phase 2 — Location & Maps data layer.
//
//  TODO: Backed by APIClient now. Core Data caching of location history is a
//        Phase-2 follow-up — network-only for now. When added, this repository
//        becomes the single read/write seam and callers should not change.
//

import Foundation

// MARK: - Protocol

/// Abstraction over location/places persistence so view models can be tested
/// with mocks. Implementations talk to the network (and, later, a local cache).
protocol LocationRepositoryProtocol {
    func fetchFamilyMap() async throws -> [FTChildLocation]
    func fetchPlaces(childId: String) async throws -> [Geofence]
    func createPlace(childId: String, geofence: Geofence) async throws
    func updatePlace(childId: String, geofence: Geofence) async throws
    func deletePlace(childId: String, placeId: String) async throws
    func fetchLocationHistory(childId: String, startDate: String) async throws -> [LocationRecord]
}

// MARK: - Implementation

final class LocationRepository: LocationRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    // MARK: Family map

    func fetchFamilyMap() async throws -> [FTChildLocation] {
        // The endpoint may return a bare array or nest it under `data`.
        // Decode the envelope and fall back to an empty list.
        // TODO confirm server JSON envelope with backend.
        let response: LocationResponse<[FTChildLocation]> =
            try await apiClient.request(FamilyTimeEndpoint.familyMap)
        return response.data ?? []
    }

    // MARK: Places (geofences)

    func fetchPlaces(childId: String) async throws -> [Geofence] {
        // TODO confirm server JSON envelope with backend.
        let response: LocationResponse<[Geofence]> =
            try await apiClient.request(FamilyTimeEndpoint.places(childId: childId))
        return response.data ?? []
    }

    func createPlace(childId: String, geofence: Geofence) async throws {
        // Response shape for writes is unknown; decode into a throwaway and discard.
        // TODO confirm server JSON envelope with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.createPlace(body: geofence.toBody(childId: childId))
        )
    }

    func updatePlace(childId: String, geofence: Geofence) async throws {
        // TODO confirm server JSON envelope with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.updatePlace(
                body: geofence.toUpdateBody(childId: childId, placeId: geofence.placeId)
            )
        )
    }

    func deletePlace(childId: String, placeId: String) async throws {
        // TODO confirm server JSON envelope with backend.
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.deletePlace(childId: childId, placeId: placeId)
        )
    }

    // MARK: Location history

    // NOTE: `fetchLocationDates` was removed — the `locationDates` endpoint no
    // longer exists after the endpoint refactor. (Pre-release, was dormant.)

    func fetchLocationHistory(childId: String, startDate: String) async throws -> [LocationRecord] {
        // TODO confirm server JSON envelope with backend.
        let response: LocationResponse<[LocationRecord]> =
            try await apiClient.request(
                FamilyTimeEndpoint.locationHistory(childId: childId, startDate: startDate)
            )
        return response.data ?? []
    }
}

// MARK: - Response wrapper

// `LocationResponse<Payload>` envelope is defined in Models/LocationModels.swift (single definition).
