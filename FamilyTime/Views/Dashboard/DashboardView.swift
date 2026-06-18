//
//  DashboardView.swift
//  FamilyTime
//
//  The Phase 2 dashboard screen.
//  iOS 16 minimum — SwiftUI only, no UIKit, no iOS 17+ API, no force unwraps.
//

import SwiftUI

struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.children.isEmpty && !viewModel.isLoading {
                    emptyState
                } else {
                    List {
                        if let name = viewModel.account?.name {
                            Section {
                                Text("Welcome, \(name)")
                            }
                        }
                        if !viewModel.isPremium {
                            Section {
                                Text("Upgrade to Premium")
                                    .foregroundColor(.orange)
                            }
                        }
                        Section("Children") {
                            ForEach(viewModel.children, id: \.childInfo?.childID) { child in
                                ChildCardView(child: child)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dashboard")
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
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    // iOS 16-safe empty state (ContentUnavailableView is iOS 17+).
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.2.slash")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("No children yet")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
