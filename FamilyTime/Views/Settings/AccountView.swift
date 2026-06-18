//
//  AccountView.swift
//  FamilyTime
//
//  Editable account profile. Loads on appear, saves via toolbar action.
//  All networking lives in AccountViewModel; this view only binds state.
//

import SwiftUI

struct AccountView: View {
    @State private var viewModel = AccountViewModel()

    var body: some View {
        Form {
            Section("Profile") {
                TextField("Name", text: $viewModel.name)
                    .textContentType(.name)
                TextField("Phone", text: $viewModel.phone)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
                TextField("Relationship", text: $viewModel.relationship)
                TextField("Language", text: $viewModel.language)
            }
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task { await viewModel.save() }
                }
                .disabled(viewModel.isSaving)
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
        .alert(
            "Something went wrong",
            isPresented: errorBinding,
            presenting: viewModel.errorMessage
        ) { _ in
            Button("OK", role: .cancel) {}
        } message: { message in
            Text(message)
        }
        .alert("Saved", isPresented: savedBinding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your profile has been updated.")
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in }
        )
    }

    private var savedBinding: Binding<Bool> {
        Binding(
            get: { viewModel.didSave },
            set: { _ in }
        )
    }
}

#Preview {
    NavigationStack {
        AccountView()
    }
}
