//
//  ReportListView.swift
//  FamilyTime
//
//  Generic dated list of ReportEntry rows for a given ReportKind.
//  SwiftUI, iOS 17, @Observable view model via @State. No UIKit,
//  no networking in views, no force-unwraps.
//

import SwiftUI

/// A generic dated list of `ReportEntry` rows for a single `ReportKind`
/// (web history, web search, YouTube, TikTok). Date filtering, loading,
/// error and empty states are driven by `ReportListViewModel`.
struct ReportListView: View {
    @State private var viewModel: ReportListViewModel

    init(kind: ReportKind) {
        _viewModel = State(initialValue: ReportListViewModel(kind: kind))
    }

    var body: some View {
        List {
            DatePicker(
                "Date",
                selection: $viewModel.selectedDate,
                displayedComponents: .date
            )

            if viewModel.entries.isEmpty && !viewModel.isLoading {
                Text("No activity for this date.")
                    .foregroundColor(.secondary)
            }

            ForEach(viewModel.entries) { entry in
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.title)
                        .font(.body)
                        .lineLimit(2)

                    if let sub = entry.subtitle {
                        Text(sub)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        if let ts = entry.timestamp {
                            Text(ts)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if let c = entry.visitCount, c > 0 {
                            Text("\(c)×")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.kind.title)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .task {
            await viewModel.load()
        }
        .onChange(of: viewModel.selectedDate) {
            Task { await viewModel.load() }
        }
        .refreshable {
            await viewModel.load()
        }
        .alert(
            "Error",
            isPresented: .constant(viewModel.errorMessage != nil)
        ) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
