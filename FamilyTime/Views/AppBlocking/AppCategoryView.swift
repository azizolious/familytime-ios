import SwiftUI

/// Block-by-category controls. Shows each app category with a summary and a
/// bulk Allow/Block toggle that applies to every app in that category.
struct AppCategoryView: View {

    @Bindable var viewModel: AppBlockingViewModel

    var body: some View {
        List {
            if viewModel.groupedApps.isEmpty && !viewModel.isLoading {
                Section {
                    Text(String(localized: "appblocking.apps.empty"))
                        .foregroundStyle(.secondary)
                }
            } else {
                ForEach(viewModel.groupedApps, id: \.category) { group in
                    Section {
                        let allBlocked = group.apps.allSatisfy { $0.isBlacklisted }
                        Toggle(isOn: Binding(
                            get: { allBlocked },
                            set: { newValue in
                                Task { await blockAll(group.apps, blocked: newValue) }
                            }
                        )) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(viewModel.title(for: group.category))
                                Text(String(
                                    format: String(localized: "appblocking.category.count"),
                                    group.apps.count
                                ))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(String(localized: "appblocking.categories.title"))
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }

    /// Applies a bulk block/allow to every app in a category, sequentially.
    private func blockAll(_ apps: [BlockableApp], blocked: Bool) async {
        for app in apps where app.isBlacklisted != blocked {
            await viewModel.toggleBlock(app)
        }
    }
}
