//
//  FamilyMapViewModel.swift
//  FamilyTime
//
//  Phase 2 — Location & Maps. Drives the family map screen: the live location
//  of each child plus the geofences ("places") for the currently selected child.
//

import Foundation

@MainActor
@Observable
final class FamilyMapViewModel {

    // MARK: State

    private(set) var childLocations: [FTChildLocation] = []
    private(set) var geofences: [Geofence] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: Dependencies

    private let repository: LocationRepositoryProtocol
    private let selectedChild: SelectedChildStore

    init(
        repository: LocationRepositoryProtocol = LocationRepository(),
        selectedChild: SelectedChildStore = .shared
    ) {
        self.repository = repository
        self.selectedChild = selectedChild
    }

    // MARK: Loading

    /// Loads every child's location for the map, then the selected child's
    /// geofences (if a child is selected). Surfaces errors via `errorMessage`.
    func load() async {
        isLoading = true
        defer { isLoading = false }

        do {
            childLocations = try await repository.fetchFamilyMap()

            if let childId = selectedChild.selectedChildID {
                geofences = try await repository.fetchPlaces(childId: childId)
            } else {
                geofences = []
            }

            errorMessage = nil
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
