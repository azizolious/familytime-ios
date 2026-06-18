//
//  StoreService.swift
//  FamilyTime
//
//  Phase 2 Subscription — native StoreKit 2 purchasing service.
//
//  StoreKit 2 only (no SwiftyStoreKit, no UIKit, no completion handlers).
//  Server-side receipt validation is delegated to `EntitlementService`,
//  which remains the single source of truth for entitlement state.
//

import Foundation
import StoreKit

/// Abstraction over the StoreKit 2 purchasing flow so callers (and tests)
/// can depend on behaviour rather than the concrete `StoreService`.
@MainActor
protocol StoreServing: AnyObject {
    var products: [Product] { get }
    func loadProducts() async
    func purchase(_ product: Product) async -> Bool
    func restore() async
}

@MainActor
@Observable
final class StoreService: StoreServing {

    static let shared = StoreService()

    private(set) var products: [Product] = []
    private(set) var isProcessing = false
    private(set) var lastError: String?

    /// Legacy product identifiers carried over from the previous billing stack.
    static let productIDs: Set<String> = ["myfamily3weekly", "myfamily3quarterly"]

    /// App Store shared secret used for server-side receipt validation of the
    /// legacy auto-renewable subscriptions. StoreKit 2 verification is local and
    /// does not need this, but the backend receipt-validation endpoint still
    /// expects it; expose it here so the single subscription service owns it.
    /// Injected at build time from `Config.xcconfig` → Info.plist (key
    /// `APP_STORE_SHARED_SECRET`). Never hardcoded in source. Empty until the
    /// xcconfig base-configuration link is wired (Phase 3) — StoreKit 2
    /// verification is local and does not need it.
    static let appStoreSharedSecret = Bundle.main.object(forInfoDictionaryKey: "APP_STORE_SHARED_SECRET") as? String ?? ""

    private let entitlement: EntitlementService
    private var updatesTask: Task<Void, Never>?

    init(entitlement: EntitlementService = .shared) {
        self.entitlement = entitlement
    }

    /// Call once at launch. Listens for transaction updates (renewals,
    /// out-of-app purchases, deferred approvals) for the app's lifetime.
    func start() {
        updatesTask = updatesTask ?? Task { [weak self] in
            for await update in Transaction.updates {
                await self?.handle(update)
            }
        }
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: Self.productIDs)
                .sorted { $0.price < $1.price }
        } catch {
            lastError = error.localizedDescription
        }
    }

    func purchase(_ product: Product) async -> Bool {
        isProcessing = true
        defer { isProcessing = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await validateAndFinish(transaction, jws: verification.jwsRepresentation)
                return true
            case .userCancelled, .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            lastError = error.localizedDescription
            return false
        }
    }

    func restore() async {
        isProcessing = true
        defer { isProcessing = false }
        do {
            try await AppStore.sync()
            try? await entitlement.refresh()
        } catch {
            lastError = error.localizedDescription
        }
    }

    private func handle(_ result: VerificationResult<Transaction>) async {
        guard let transaction = try? checkVerified(result) else { return }
        await validateAndFinish(transaction, jws: result.jwsRepresentation)
    }

    private func validateAndFinish(_ transaction: Transaction, jws: String) async {
        // Server-side validation through EntitlementService (single source of truth).
        // TODO: confirm backend payload for StoreKit 2 — sending the JWS representation here;
        // the legacy flow sent the base64 app receipt.
        try? await entitlement.validateReceipt(jws)
        await transaction.finish()
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw StoreError.failedVerification
        }
    }
}

enum StoreError: LocalizedError {
    case failedVerification

    var errorDescription: String? {
        "The App Store transaction could not be verified."
    }
}
