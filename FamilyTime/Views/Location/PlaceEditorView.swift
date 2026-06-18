//
//  PlaceEditorView.swift
//  FamilyTime
//
//  Phase 2 — Location & Maps. Creates or edits a single geofence ("place").
//
//  `Geofence` has only `let` stored properties, so this editor cannot mutate it
//  in place. Instead it holds the editable values in separate `@State` fields and
//  constructs a NEW `Geofence` (via the model's memberwise init) on save,
//  preserving the original `placeId`, `address`, and `predefined`.
//
//  iOS 16 only.
//

import SwiftUI
import MapKit

/// Form for editing a geofence's name, coordinate, radius, and alert toggle.
struct PlaceEditorView: View {

    /// Radius options in meters, paired with their imperial display labels.
    private static let radiusOptions: [(meters: Double, label: String)] = [
        (30.48, "100 ft"),
        (60.96, "200 ft"),
        (152.4, "500 ft"),
        (804.67, "0.5 mi"),
        (1609.34, "1 mi"),
        (3218.69, "2 mi")
    ]

    // The original geofence is retained so we can preserve fields the form does
    // not edit (placeId, address, predefined) when rebuilding on save.
    @State private var geofence: Geofence

    // Editable fields, kept separate because `Geofence`'s properties are `let`.
    @State private var name: String
    @State private var latitudeText: String
    @State private var longitudeText: String
    @State private var radius: Double
    @State private var checkinAlert: Bool

    private let onSave: (Geofence) -> Void

    @Environment(\.dismiss) private var dismiss

    init(geofence: Geofence, onSave: @escaping (Geofence) -> Void) {
        _geofence = State(initialValue: geofence)
        _name = State(initialValue: geofence.location)
        _latitudeText = State(initialValue: String(geofence.latitude))
        _longitudeText = State(initialValue: String(geofence.longitude))
        _radius = State(initialValue: geofence.radius)
        _checkinAlert = State(initialValue: geofence.checkinAlert)
        self.onSave = onSave
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            Form {
                Section("Place") {
                    TextField("Name", text: $name)
                }

                // Manual coordinate entry. Map-tap-to-set is a planned follow-up.
                Section("Location") {
                    TextField("Latitude", text: $latitudeText)
                    TextField("Longitude", text: $longitudeText)
                }

                Section("Radius") {
                    Picker("Radius", selection: $radius) {
                        ForEach(Self.radiusOptions, id: \.meters) { option in
                            Text(option.label).tag(option.meters)
                        }
                    }
                }

                Section {
                    Toggle("Check-in/out alerts", isOn: $checkinAlert)
                }
            }
            .navigationTitle(geofence.placeId.isEmpty ? "New Place" : "Edit Place")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
        }
    }

    // MARK: Save

    /// Builds a new `Geofence` from the form fields and hands it to `onSave`.
    /// Unparsable coordinates fall back to the existing values (no force-unwrap).
    private func save() {
        let updated = Geofence(
            placeId: geofence.placeId,
            location: name,
            latitude: Double(latitudeText) ?? geofence.latitude,
            longitude: Double(longitudeText) ?? geofence.longitude,
            radius: radius,
            checkinAlert: checkinAlert,
            address: geofence.address,
            predefined: geofence.predefined
        )
        onSave(updated)
        dismiss()
    }
}
