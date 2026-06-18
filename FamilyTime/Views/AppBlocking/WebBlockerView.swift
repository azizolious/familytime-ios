import SwiftUI

/// SwiftUI replacement for the legacy UIKit `WebBlockerVC` (+ AddURLVC / RemoveURLVC /
/// WebBlockerPopUp / cells). Master on/off toggle, searchable URL list with per-row
/// Allow/Block toggles, select-all, add via sheet, remove via swipe. Backed by the
/// @Observable `WebBlockerViewModel` (Tier 1 repository / async APIClient).
struct WebBlockerView: View {
    @State private var viewModel = WebBlockerViewModel()
    @State private var searchText = ""
    @State private var showAddSheet = false

    private var filteredApps: [WebBlockerObj] {
        guard !searchText.isEmpty else { return viewModel.webBlockerArr }
        return viewModel.webBlockerArr.filter {
            ($0.url ?? "").localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            Section {
                Toggle(isOn: Binding(
                    get: { viewModel.isEnabled },
                    set: { newValue in Task { await viewModel.setEnabled(newValue) } }
                )) {
                    Text(String(localized: "web_blocker"))
                }
            }

            if viewModel.isEnabled {
                Section {
                    Button {
                        showAddSheet = true
                    } label: {
                        Label(String(localized: "add_url"), systemImage: "plus")
                    }
                    if !viewModel.webBlockerArr.isEmpty {
                        Toggle(String(localized: "select_all"), isOn: Binding(
                            get: { viewModel.allBlocked },
                            set: { viewModel.setAll($0) }
                        ))
                    }
                }

                if filteredApps.isEmpty {
                    Section {
                        ContentUnavailableView(
                            String(localized: "no_Websites_to_show"),
                            systemImage: "globe",
                            description: Text(String(localized: "empty_web_msg"))
                        )
                    }
                } else {
                    Section {
                        ForEach(filteredApps, id: \.id) { app in
                            Toggle(isOn: Binding(
                                get: { app.isBlocked == 1 },
                                set: { viewModel.setBlocked(app, blocked: $0) }
                            )) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(app.url ?? "")
                                    if let type = app.type, !type.isEmpty {
                                        Text(type)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        .onDelete { offsets in
                            let toRemove = offsets.map { filteredApps[$0] }
                            Task { await viewModel.remove(toRemove) }
                        }
                    }
                }
            }
        }
        .navigationTitle(String(localized: "web_blocker"))
        .searchable(text: $searchText, prompt: String(localized: "search_site"))
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "save")) {
                    Task { await viewModel.save() }
                }
                .disabled(!viewModel.isEnabled)
            }
        }
        .overlay {
            if viewModel.isLoading || viewModel.isSaving {
                ProgressView()
            }
        }
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
        .sheet(isPresented: $showAddSheet) {
            AddWebBlockerURLView { url in
                Task { await viewModel.addURL(url) }
            }
        }
        .alert(
            String(localized: "alert_error"),
            isPresented: Binding(
                get: { viewModel.alertMessage != nil },
                set: { if !$0 { viewModel.alertMessage = nil } }
            )
        ) {
            Button(String(localized: "appblocking.action.ok")) { viewModel.alertMessage = nil }
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
    }
}

/// Add-URL sheet — replaces the legacy `AddURLVC`.
private struct AddWebBlockerURLView: View {
    let onAdd: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var url = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField(String(localized: "search_site"), text: $url)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .autocorrectionDisabled()
            }
            .navigationTitle(String(localized: "add_url"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "appblocking.action.ok")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "add_url")) {
                        onAdd(url)
                        dismiss()
                    }
                    .disabled(url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
