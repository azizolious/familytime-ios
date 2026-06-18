import Foundation

// MARK: - Response Models

/// Decoded shape of the account/entitlement endpoint.
///
/// - Note: Server JSON is not yet finalized. Field names and the date encoding
///   below are best-effort guesses.
/// - TODO: confirm server JSON (key names, date format, nullability).
struct EntitlementResponse: Decodable {
    let isSubscribed: Bool
    let plan: String?
    let expiryDate: Date?

    // TODO: confirm server JSON — adjust these CodingKeys to match the
    // actual payload keys once the contract is finalized.
    private enum CodingKeys: String, CodingKey {
        case isSubscribed = "is_subscribed"
        case plan
        case expiryDate = "expiry_date"
    }
}

/// Decoded shape of the receipt-validation endpoint.
///
/// - TODO: confirm server JSON (key name for `valid`, any extra metadata).
struct ReceiptValidationResponse: Decodable {
    let valid: Bool

    // TODO: confirm server JSON — adjust this CodingKey to match the payload.
    private enum CodingKeys: String, CodingKey {
        case valid
    }
}

// MARK: - EntitlementService

/// Single source of truth for the user's subscription/entitlement state.
///
/// State is held in-memory only and exposed via observable properties so
/// SwiftUI views and other observers can react to changes. There is no hard
/// dependency on CoreData; persistence into the `BillingSubscription` entity
/// is deferred (see the TODO in `refresh()`).
///
/// This intentionally replaces all `UserDefaults.BILLING_STATUS` reads — use
/// `isPremium` / `isSubscribed` instead.
@MainActor
@Observable
final class EntitlementService {

    /// Shared singleton backed by the production `APIClient`.
    static let shared = EntitlementService()

    private(set) var isSubscribed: Bool = false
    private(set) var currentPlan: String?
    private(set) var expiryDate: Date?

    private let apiClient: APIClientProtocol

    /// - Parameter apiClient: Injectable to allow unit tests to supply a mock.
    ///   Defaults to the shared production client.
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    /// Fetches the latest entitlement state from the backend and updates the
    /// published properties.
    ///
    /// - Throws: `NetworkError` propagated from the API client.
    func refresh() async throws {
        let response: EntitlementResponse = try await apiClient.request(FamilyTimeEndpoint.accountInfo)

        isSubscribed = response.isSubscribed
        currentPlan = response.plan
        expiryDate = response.expiryDate

        // TODO(Phase 1 integration): persist into CoreData `BillingSubscription`
        // entity (entity exists; attributes TBD). For now state is in-memory only.
        // Never read or write UserDefaults.BILLING_STATUS.
    }

    /// Validates an App Store receipt with the backend and, on success,
    /// refreshes the local entitlement state.
    ///
    /// - Parameter receiptData: Base64-encoded App Store receipt.
    /// - Throws: `NetworkError` propagated from the API client when validation
    ///   fails or the network request errors.
    func validateReceipt(_ receiptData: String) async throws {
        let _: ReceiptValidationResponse = try await apiClient.request(
            FamilyTimeEndpoint.validateReceipt(receiptData: receiptData)
        )
        // On a successful (non-throwing) validation, sync entitlement state.
        try await refresh()
    }

    /// Single source of truth for premium access; replaces
    /// `UserDefaults.BILLING_STATUS` reads.
    var isPremium: Bool { isSubscribed }
}
