//
//  AboutView.swift
//  FamilyTime
//
//  Static "About" screen: app name, version/build, copyright, and links to
//  Terms of Service and Privacy Policy. No view model and no networking.
//

import SwiftUI

struct AboutView: View {
    /// App version pulled from the bundle. No force-unwraps — falls back to a
    /// placeholder if the key is missing.
    private var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    /// Build number from the bundle, with the same safe fallback.
    private var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
    }

    private let termsURL = URL(string: "https://familytime.io/terms")
    private let privacyURL = URL(string: "https://familytime.io/privacy")

    var body: some View {
        Form {
            Section {
                VStack(spacing: 8) {
                    Text("FamilyTime")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Version \(version) (\(build))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
            }

            Section("Legal") {
                if let termsURL {
                    Link("Terms of Service", destination: termsURL)
                }
                if let privacyURL {
                    Link("Privacy Policy", destination: privacyURL)
                }
            }

            Section {
                Text("© 2026 FamilyTime. All rights reserved.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("About")
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
