//
//  CoParentView.swift
//  FamilyTime
//
//  Co-parent management: invite by name/email and view/remove existing
//  co-parents. Removal is destructive and confirmed via a dialog.
//

import SwiftUI

struct CoParentView: View {
    @State private var viewModel = CoParentViewModel()
    @State private var coParentToRemove: FTCoParent?

    var body: some View {
        List {
            Section("Invite a Co-Parent") {
                TextField("Name", text: $viewModel.inviteName)
                    .textContentType(.name)
                TextField("Email", text: $viewModel.inviteEmail)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                Button("Send Invite") {
                    Task { await viewModel.invite() }
                }
            }

            Section("Co-Parents") {
                if viewModel.coParents.isEmpty {
                    Text("No co-parents yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.coParents) { coParent in
                        row(for: coParent)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    coParentToRemove = coParent
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle("Co-Parents")
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .task {
            await viewModel.load()
        }
        .confirmationDialog(
            "Remove this co-parent?",
            isPresented: removeConfirmBinding,
            titleVisibility: .visible,
            presenting: coParentToRemove
        ) { coParent in
            Button("Remove", role: .destructive) {
                Task { await viewModel.remove(coParent) }
                coParentToRemove = nil
            }
            Button("Cancel", role: .cancel) {
                coParentToRemove = nil
            }
        } message: { coParent in
            Text("\(coParent.name ?? coParent.email ?? "This co-parent") will lose access.")
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
        .alert("Invitation Sent", isPresented: invitedBinding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your co-parent invitation has been sent.")
        }
    }

    @ViewBuilder
    private func row(for coParent: FTCoParent) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(coParent.name ?? "Unnamed")
                .font(.body)
            if let email = coParent.email {
                Text(email)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if let status = coParent.status {
                Text(status.capitalized)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var removeConfirmBinding: Binding<Bool> {
        Binding(
            get: { coParentToRemove != nil },
            set: { isPresented in
                if !isPresented { coParentToRemove = nil }
            }
        )
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in }
        )
    }

    private var invitedBinding: Binding<Bool> {
        Binding(
            get: { viewModel.didInvite },
            set: { _ in }
        )
    }
}

#Preview {
    NavigationStack {
        CoParentView()
    }
}
