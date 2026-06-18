import SwiftUI

/// Content-filter toggles (Apps / Movies / TV Shows / Explicit Content /
/// Book Store Erotica) backed by the shared App-Blocking view model.
struct ContentFilterView: View {

    @Bindable var viewModel: AppBlockingViewModel

    var body: some View {
        List {
            Section {
                Text(String(localized: "appblocking.filter.footer"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if viewModel.contentFilters.isEmpty && !viewModel.isLoading {
                Section {
                    Text(String(localized: "appblocking.filter.empty"))
                        .foregroundStyle(.secondary)
                }
            } else {
                Section(String(localized: "appblocking.filter.section")) {
                    ForEach(viewModel.contentFilters) { setting in
                        Toggle(isOn: Binding(
                            get: { setting.isOn },
                            set: { newValue in
                                Task { await viewModel.setFilter(setting, on: newValue) }
                            }
                        )) {
                            Text(setting.title)
                        }
                    }
                }
            }
        }
        .navigationTitle(String(localized: "appblocking.filter.title"))
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}
