//
//  PlacesView.swift
//  FamilyTime
//
//  Phase 2 — Location & Maps. Lists the selected child's geofences ("places")
//  and routes to the editor for create / update. All networking lives in
//  `PlacesViewModel`; this view only renders state and forwards user intent.
//
//  iOS 16 only.
//

import SwiftUI
import MapKit

/// The places list screen. Each row shows the place name, its radius in meters,
/// and a bell when check-in/out alerts are enabled.
struct PlacesView: View {

    @State private var viewModel = PlacesViewModel()

    @State private var editingGeofence: Geofence?
    @State private var showingEditor = false

    // MARK: Body

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.geofences) { geofence in
                    Button {
                        editingGeofence = geofence
                        showingEditor = true
                    } label: {
                        row(for: geofence)
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Places")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        editingGeofence = newGeofence()
                        showingEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .task {
                await viewModel.load()
            }
            .refreshable {
                await viewModel.load()
            }
            .sheet(isPresented: $showingEditor) {
                if let editingGeofence {
                    PlaceEditorView(geofence: editingGeofence) { saved in
                        Task { await viewModel.save(saved) }
                    }
                }
            }
            .alert(
                "Something went wrong",
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

    // MARK: Rows

    private func row(for geofence: Geofence) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(geofence.location.isEmpty ? "Untitled place" : geofence.location)
                    .font(.body)
                Text("\(Int(geofence.radius)) m")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if geofence.checkinAlert {
                Image(systemName: "bell.fill")
                    .foregroundColor(.accentColor)
            }
        }
        .contentShape(Rectangle())
    }

    // MARK: Actions

    private func delete(at offsets: IndexSet) {
        let toDelete = offsets.map { viewModel.geofences[$0] }
        for geofence in toDelete {
            Task { await viewModel.delete(geofence) }
        }
    }

    /// Builds a blank geofence (empty `placeId`) so the view model treats a save
    /// as a creation.
    private func newGeofence() -> Geofence {
        Geofence(
            placeId: "",
            location: "",
            latitude: 0,
            longitude: 0,
            radius: 152.4,
            checkinAlert: false
        )
    }
}
