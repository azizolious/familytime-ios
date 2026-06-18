//
//  NotificationsView.swift
//  FamilyTime
//
//  Phase 2 Notifications — SwiftUI feed list.
//

import SwiftUI

struct NotificationsView: View {
    @State private var viewModel = NotificationsViewModel()

    var body: some View {
        NavigationStack {
            List {
                if viewModel.feed.isEmpty && !viewModel.isLoading {
                    Text("No notifications")
                        .foregroundColor(.secondary)
                }
                ForEach(viewModel.feed, id: \.id) { item in
                    NavigationLink {
                        NotificationDetailView(item: item)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.feedSnippet)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                    }
                }
            }
            .navigationTitle("Notifications")
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .refreshable {
                await viewModel.load()
            }
            .task {
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
}
