//
//  ChangePasswordView.swift
//  FamilyTime
//
//  Change-password form. Passwords are entered via SecureField only and are
//  never displayed. Submission is gated on the view model's `canSubmit`.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var viewModel = ChangePasswordViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("Current") {
                SecureField("Current Password", text: $viewModel.currentPassword)
                    .textContentType(.password)
            }
            Section("New") {
                SecureField("New Password", text: $viewModel.newPassword)
                    .textContentType(.newPassword)
                SecureField("Confirm New Password", text: $viewModel.confirmPassword)
                    .textContentType(.newPassword)
            }
            Section {
                Button("Change Password") {
                    Task { await viewModel.submit() }
                }
                .disabled(!viewModel.canSubmit || viewModel.isSubmitting)
            }
        }
        .navigationTitle("Change Password")
        .overlay {
            if viewModel.isSubmitting {
                ProgressView()
            }
        }
        .alert(
            "Something went wrong",
            isPresented: errorBinding,
            presenting: viewModel.errorMessage
        ) { _ in
            Button("OK", role: .cancel) {}
        } message: { message in
            Text(message)
        }
        .alert("Password Changed", isPresented: changedBinding) {
            Button("OK", role: .cancel) { dismiss() }
        } message: {
            Text("Your password has been updated.")
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in }
        )
    }

    private var changedBinding: Binding<Bool> {
        Binding(
            get: { viewModel.didChange },
            set: { _ in }
        )
    }
}

#Preview {
    NavigationStack {
        ChangePasswordView()
    }
}
