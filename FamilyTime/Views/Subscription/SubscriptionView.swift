//
//  SubscriptionView.swift
//  FamilyTime
//
//  Phase 2 — Subscription UI. iOS 16 only (no iOS 17 APIs).
//
//  Premium state is derived exclusively from `EntitlementService.isPremium`
//  via the view model. Products come from `StoreServing.products`.
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {

    @State private var viewModel = SubscriptionViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isPremium {
                    premiumState
                } else {
                    planList
                }
            }
            .navigationTitle("Premium")
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
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

    private var premiumState: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.largeTitle)
                .foregroundColor(.green)
            Text("You're Premium")
                .font(.title2)
        }
    }

    private var planList: some View {
        List {
            Section("Choose a plan") {
                ForEach(viewModel.products, id: \.id) { product in
                    Button {
                        Task { await viewModel.buy(product) }
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.displayName)
                                Text(product.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(product.displayPrice)
                                .bold()
                        }
                    }
                }
            }

            Section {
                Button("Restore Purchases") {
                    Task { await viewModel.restore() }
                }
            }
        }
    }
}
