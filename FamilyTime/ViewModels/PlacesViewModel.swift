//
//  PlacesViewModel.swift
//  FamilyTime
//
//  Phase 2 — Location & Maps. Manages the list of geofences ("places") for the
//  currently selected child, including create / update / delete.
//

import Foundation

@MainActor
@Observable
final class PlacesViewModel {

    // MARK: State

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

    /// Loads the selected child's geofences. Requires a selected child.
    func load() async {
        guard let childId = selectedChild.selectedChildID else {
            errorMessage = "No child selected"
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            geofences = try await repository.fetchPlaces(childId: childId)
            errorMessage = nil
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: Mutations

    /// Creates the geofence when it has no `placeId`, otherwise updates it, then
    /// reloads the list so the UI reflects the server's canonical state.
    func save(_ geofence: Geofence) async {
        guard let childId = selectedChild.selectedChildID else {
            errorMessage = "No child selected"
            return
        }

        do {
            if geofence.placeId.isEmpty {
                try await repository.createPlace(childId: childId, geofence: geofence)
            } else {
                try await repository.updatePlace(childId: childId, geofence: geofence)
            }
            await load()
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Deletes the given geofence, then reloads the list.
    func delete(_ geofence: Geofence) async {
        guard let childId = selectedChild.selectedChildID else {
            errorMessage = "No child selected"
            return
        }

        do {
            try await repository.deletePlace(childId: childId, placeId: geofence.placeId)
            await load()
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
