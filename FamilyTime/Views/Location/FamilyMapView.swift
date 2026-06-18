//
//  FamilyMapView.swift
//  FamilyTime
//
//  Phase 2 — Location & Maps. Shows every child's current location plus the
//  selected child's geofences ("places") on a single SwiftUI Map.
//
//  iOS 16 only. SwiftUI `Map` here supports annotations but NOT circle overlays
//  (`MapCircle` is iOS 17+), so geofences are rendered as PINS, not circles.
//

import SwiftUI
import MapKit

/// The family map screen. All networking lives in `FamilyMapViewModel`; this
/// view only renders state and forwards user intent.
struct FamilyMapView: View {

    @State private var viewModel = FamilyMapViewModel()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.33, longitude: -122.03),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )

    // MARK: Annotation model

    /// A single map marker. SwiftUI `Map(annotationItems:)` requires ONE element
    /// type, so child locations and geofence centers are merged into this type.
    private struct MapPin: Identifiable {
        let id: String
        let coordinate: CLLocationCoordinate2D
        let title: String
        let isChild: Bool
    }

    /// Children (blue `person.circle.fill`) merged with geofence centers
    /// (red `mappin.circle.fill`).
    // TODO(iOS17): render geofence radius as MapCircle, or via an MKMapView representable.
    private var pins: [MapPin] {
        let childPins = viewModel.childLocations.map { child in
            MapPin(
                id: "child-\(child.id)",
                coordinate: CLLocationCoordinate2D(
                    latitude: child.latitude,
                    longitude: child.longitude
                ),
                title: child.name ?? "Child",
                isChild: true
            )
        }

        let placePins = viewModel.geofences.map { geofence in
            MapPin(
                id: "place-\(geofence.id)",
                coordinate: CLLocationCoordinate2D(
                    latitude: geofence.latitude,
                    longitude: geofence.longitude
                ),
                title: geofence.location,
                isChild: false
            )
        }

        return childPins + placePins
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            Map(coordinateRegion: $region, annotationItems: pins) { pin in
                MapAnnotation(coordinate: pin.coordinate) {
                    VStack(spacing: 2) {
                        Image(systemName: pin.isChild ? "person.circle.fill" : "mappin.circle.fill")
                            .foregroundColor(pin.isChild ? .blue : .red)
                        Text(pin.title)
                            .font(.caption2)
                    }
                }
            }
            .navigationTitle("Family Map")
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .task {
                await viewModel.load()
                recenterOnFirstChild()
            }
            .refreshable {
                await viewModel.load()
            }
            .alert(
                "Couldn't load the map",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { _ in }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    // MARK: Helpers

    /// Centers the map on the first child once locations have loaded.
    private func recenterOnFirstChild() {
        if let first = viewModel.childLocations.first {
            region.center = CLLocationCoordinate2D(
                latitude: first.latitude,
                longitude: first.longitude
            )
        }
    }
}
