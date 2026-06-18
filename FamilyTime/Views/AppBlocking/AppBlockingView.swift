import SwiftUI

/// App-Blocking screen: installed apps grouped by category, each with an
/// Allow/Block toggle. Also links to category controls and content filters.
struct AppBlockingView: View {

    @State private var viewModel = AppBlockingViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        AppCategoryView(viewModel: viewModel)
                    } label: {
                        Label(
                            String(localized: "appblocking.link.categories"),
                            systemImage: "square.grid.2x2.fill"
                        )
                    }
                    NavigationLink {
                        ContentFilterView(viewModel: viewModel)
                    } label: {
                        Label(
                            String(localized: "appblocking.link.content_filters"),
                            systemImage: "shield.lefthalf.filled"
                        )
                    }
                    NavigationLink {
                        WebBlockerView()
                    } label: {
                        Label(
                            String(localized: "web_blocker"),
                            systemImage: "globe"
                        )
                    }
                }

                if viewModel.apps.isEmpty && !viewModel.isLoading {
                    Section {
                        Text(String(localized: "appblocking.apps.empty"))
                            .foregroundStyle(.secondary)
                    }
                } else {
                    ForEach(viewModel.groupedApps, id: \.category) { group in
                        Section(viewModel.title(for: group.category)) {
                            ForEach(group.apps) { app in
                                AppBlockingRow(app: app) {
                                    Task { await viewModel.toggleBlock(app) }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "appblocking.title"))
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .refreshable { await viewModel.load() }
            .task { await viewModel.load() }
            .alert(
                String(localized: "appblocking.error.title"),
                isPresented: .constant(viewModel.errorMessage != nil)
            ) {
                Button(String(localized: "appblocking.action.ok")) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

/// A single installed-app row with an Allow/Block toggle.
private struct AppBlockingRow: View {
    let app: BlockableApp
    let onToggle: () -> Void

    var body: some View {
        Toggle(isOn: Binding(
            get: { app.isBlacklisted },
            set: { _ in onToggle() }
        )) {
            VStack(alignment: .leading, spacing: 2) {
                Text(app.appName ?? app.appPackageName ?? app.id)
                Text(app.isBlacklisted
                     ? String(localized: "appblocking.state.blocked")
                     : String(localized: "appblocking.state.allowed"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
