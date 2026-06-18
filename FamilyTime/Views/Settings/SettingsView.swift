//
//  SettingsView.swift
//  FamilyTime
//
//  Settings hub: navigation entry points for Account, Family, Subscription,
//  and About, plus a Log Out action. Log Out is destructive and therefore
//  gated behind a confirmation dialog.
//

import SwiftUI

struct SettingsView: View {
    @State private var settingsVM = SettingsViewModel()
    @State private var showLogoutConfirm = false

    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    NavigationLink("Profile") { AccountView() }
                    NavigationLink("Change Password") { ChangePasswordView() }
                }

                Section("Family") {
                    NavigationLink("Co-Parents") { CoParentView() }
                    NavigationLink("Manage Child") { ChildManagementView() }
                }

                Section("Subscription") {
                    // Reuse the existing SubscriptionView — do not rebuild it.
                    NavigationLink("Manage Subscription") { SubscriptionView() }
                }

                Section("About") {
                    NavigationLink("About") { AboutView() }
                }

                Section {
                    Button(role: .destructive) {
                        showLogoutConfirm = true
                    } label: {
                        HStack {
                            if settingsVM.isLoggingOut {
                                ProgressView()
                            }
                            Text("Log Out")
                        }
                    }
                    .disabled(settingsVM.isLoggingOut)
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog(
                "Log out of FamilyTime?",
                isPresented: $showLogoutConfirm,
                titleVisibility: .visible
            ) {
                Button("Log Out", role: .destructive) {
                    Task { await settingsVM.logout() }
                }
                Button("Cancel", role: .cancel) {}
            }
            .alert(
                "Something went wrong",
                isPresented: errorBinding,
                presenting: settingsVM.errorMessage
            ) { _ in
                Button("OK", role: .cancel) {}
            } message: { message in
                Text(message)
            }
        }
    }

    /// Read-only `errorMessage` is surfaced via a presentation binding.
    /// Dismissal is a no-op (the VM owns clearing), matching the existing
    /// `SubscriptionView` convention.
    private var errorBinding: Binding<Bool> {
        Binding(
            get: { settingsVM.errorMessage != nil },
            set: { _ in }
        )
    }
}

#Preview {
    SettingsView()
}
