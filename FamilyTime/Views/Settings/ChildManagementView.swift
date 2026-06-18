//
//  ChildManagementView.swift
//  FamilyTime
//
//  Manage the selected child. The only action here is deletion, which is
//  destructive and irreversible — it MUST be confirmed via a dialog.
//
//  NOTE: Adding/editing a child is out of scope for this screen.
//

import SwiftUI

struct ChildManagementView: View {
    @State private var viewModel = ChildManagementViewModel()
    @State private var showDeleteConfirm = false

    var body: some View {
        Form {
            Section {
                Text("Selected child: \(viewModel.selectedChildName)")
            }

            Section {
                Button(role: .destructive) {
                    showDeleteConfirm = true
                } label: {
                    Text("Delete Child")
                }
                .disabled(viewModel.isDeleting)
            } footer: {
                Text("Deleting a child permanently removes their device pairing and all collected data. This cannot be undone.")
            }
        }
        .navigationTitle("Manage Child")
        .overlay {
            if viewModel.isDeleting {
                ProgressView()
            }
        }
        .confirmationDialog(
            "Delete \(viewModel.selectedChildName)? This permanently removes their data and cannot be undone.",
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                Task { await viewModel.deleteSelectedChild() }
            }
            Button("Cancel", role: .cancel) {}
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
        .alert("Child Deleted", isPresented: deletedBinding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The child and all associated data have been removed.")
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in }
        )
    }

    private var deletedBinding: Binding<Bool> {
        Binding(
            get: { viewModel.didDelete },
            set: { _ in }
        )
    }
}

#Preview {
    NavigationStack {
        ChildManagementView()
    }
}
