//
//  SubscriptionViewModel.swift
//  FamilyTime
//
//  Phase 2 — Subscription UI. Drives `SubscriptionView`.
//
//  Premium gating: the ONLY source of truth is `EntitlementService.isPremium`.
//  We never read `UserDefaults.BILLING_STATUS` (or any other legacy flag) here.
//  Products are read through the `StoreServing` protocol so this view model has
//  no dependency on the concrete `StoreService` type.
//

import SwiftUI
import StoreKit

@MainActor
@Observable
final class SubscriptionViewModel {

    /// `true` while products are being loaded or entitlements refreshed.
    private(set) var isLoading = false

    /// Non-`nil` when the most recent operation surfaced a user-facing error.
    private(set) var errorMessage: String?

    private let store: StoreServing
    private let entitlement: EntitlementService

    init(store: StoreServing = StoreService.shared,
         entitlement: EntitlementService = .shared) {
        self.store = store
        self.entitlement = entitlement
    }

    /// The single premium gate for the subscription UI.
    var isPremium: Bool { entitlement.isPremium }

    /// Purchasable products, sourced from the store service (not the concrete type).
    var products: [Product] { store.products }

    /// Loads available products and refreshes the current entitlement state.
    func load() async {
        isLoading = true
        await store.loadProducts()
        try? await entitlement.refresh()
        isLoading = false
    }

    /// Attempts to purchase `product`, then refreshes entitlement state.
    func buy(_ product: Product) async {
        _ = await store.purchase(product)
        try? await entitlement.refresh()
    }

    /// Restores previously purchased entitlements.
    func restore() async {
        await store.restore()
    }
}
