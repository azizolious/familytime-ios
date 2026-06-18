//
//  SocialReportView.swift
//  FamilyTime
//
//  Grouped chat-style view of SocialMessage rows for a given date.
//  SwiftUI, iOS 17, @Observable view model via @State. No UIKit,
//  no networking in views, no force-unwraps.
//

import SwiftUI

/// A grouped, chat-style view of `SocialMessage` rows. Messages are grouped by
/// contact (via `SocialReportViewModel.groupedByContact`) and rendered as
/// chat bubbles, aligned by `fromMe`. Date filtering, loading, error and empty
/// states are driven by `SocialReportViewModel`.
struct SocialReportView: View {
    @State private var viewModel = SocialReportViewModel()

    var body: some View {
        List {
            DatePicker(
                "Date",
                selection: $viewModel.selectedDate,
                displayedComponents: .date
            )

            if viewModel.messages.isEmpty && !viewModel.isLoading {
                Text("No social activity for this date.")
                    .foregroundColor(.secondary)
            }

            ForEach(viewModel.groupedByContact, id: \.contact) { group in
                Section(group.contact) {
                    ForEach(group.messages) { msg in
                        HStack {
                            if msg.fromMe { Spacer() }
                            Text(msg.body ?? "")
                                .padding(8)
                                .background(
                                    msg.fromMe
                                        ? Color.blue.opacity(0.15)
                                        : Color.gray.opacity(0.15)
                                )
                                .cornerRadius(8)
                            if !msg.fromMe { Spacer() }
                        }
                    }
                }
            }
        }
        .navigationTitle("Social Chat")
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
