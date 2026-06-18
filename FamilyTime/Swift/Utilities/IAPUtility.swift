//
//  IAPUtility.swift
//  FamilyTime
//  Created by Sana Ullah on 15/01/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//  Modified by Usama-Apps on 2022.
//
//  Migrated off the legacy IAP SDK to native StoreKit 2 (via `StoreService`) /
//  StoreKit 1 (`SKProductsRequest`). This type is orphaned from the SwiftUI
//  entry point (`SubscriptionView`/`SubscriptionViewModel` are the live path),
//  but the legacy UIKit `SubscriptionVC` still references it, so every public
//  method signature is preserved. Purchasing/restoring is routed to
//  `StoreService` (StoreKit 2); product metadata is fetched with native
//  `SKProductsRequest` so callers that expect `[SKProduct]` keep working.
//

import Foundation
import StoreKit

enum RegisteredPurchase: String {
    case purchase1
    case purchase2
    case nonConsumablePurchase
    case consumablePurchase
    case nonRenewingPurchase
    case autoRenewableWeekly
    case autoRenewableMonthly
    case autoRenewableYearly

    //---AUTO RENEWABLE PRODUCT ID---//
    case myfamily3quarterly
    case myfamily3weekly

}

@objc class IAPUtility : NSObject {
    //MARK: - Variables
    static let shared = IAPUtility()
    let uniqueDeviceId = UIDevice.current.identifierForVendor?.uuidString
    private var delegate = UIApplication.shared.delegate as? AppDelegate

    /// Retains in-flight `SKProductsRequest` instances (and their delegates)
    /// until their completion handler fires.
    private var productRequests = [ProductsRequestProxy]()

    //MARK: - APPDELEGATE METHOD
    @objc func setupIAP() {
        // StoreKit 2: `StoreService` owns the `Transaction.updates` listener and
        // finishes/validates transactions (renewals, out-of-app purchases,
        // deferred approvals). Starting it here preserves the previous
        // `completeTransactions` behaviour without the legacy IAP SDK.
        Task { @MainActor in
            StoreService.shared.start()
        }
    }


    //MARK: - AUTO RENEWABLE METHODS

    //METHODS EXPOSED TO OUTER CONTROLLER
    func autoRenewableGetInfo(vc:UIViewController) {
        getInfo(RegisteredPurchase.myfamily3weekly, vc: vc)
    }

    func autoRenewablePurchase(prodId:String, vc:UIViewController) {
        purchase(prodId, atomically: true, vc: vc)

    }

    func autoRenewableVerifyPurchase(vc:UIViewController) {
        verifySubscriptions([.myfamily3weekly], vc: vc)
    }

    func verifyReceipt(vc:UIViewController) {
        // StoreKit 2 verifies transactions locally; server validation is handled
        // by `StoreService`/`EntitlementService`. Surface the current state.
        NetworkActivityIndicatorManager.networkOperationStarted()
        Task { @MainActor in
            try? await EntitlementService.shared.refresh()
            NetworkActivityIndicatorManager.networkOperationFinished()
            let title = "Receipt verification"
            let message = EntitlementService.shared.isPremium
                ? "Subscription is active."
                : "No active subscription was found."
            vc.showAlert(vc.alertWithTitle(title, message: message))
        }
    }

    func restorePurchases(vc:UIViewController) {
        SwiftFTUtils.showHUDAdded(to: vc.view, withText: "", animated: true)
        NetworkActivityIndicatorManager.networkOperationStarted()
        Task { @MainActor in
            await StoreService.shared.restore()
            SwiftFTUtils.hideHUDAdded(to: vc.view, animated: true)
            NetworkActivityIndicatorManager.networkOperationFinished()
            let title: String
            let message: String
            if EntitlementService.shared.isPremium {
                title = "Purchases Restored"
                message = "All purchases have been restored"
            } else {
                title = "Nothing to restore"
                message = "No previous purchases were found"
            }
            vc.showAlert(vc.alertWithTitle(title, message: message))
        }
    }

    func getAllProducts(prodIds:Set<String>, onCompletion: @escaping ([SKProduct]) -> ()){
        NetworkActivityIndicatorManager.networkOperationStarted()
        var proxyRef: ProductsRequestProxy?
        let proxy = ProductsRequestProxy { [weak self] products in
            NetworkActivityIndicatorManager.networkOperationFinished()
            if let product = products.first {
                let priceString = product.localizedPriceString ?? ""
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            onCompletion(products)
            // Drop the retained proxy now that the request has completed.
            if let finished = proxyRef {
                self?.productRequests.removeAll { $0 === finished }
            }
        }
        proxyRef = proxy
        productRequests.append(proxy)
        proxy.start(productIdentifiers: prodIds)
    }

    func getReceipt(completion : @escaping ((String) -> ())){
        // Native App Store receipt (StoreKit 1 location). StoreKit 2 prefers the
        // per-transaction JWS, but the legacy server endpoint expects the
        // base64 app receipt, so we read it directly off the bundle.
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL) else {
            print("Fetch receipt failed: no receipt data")
            completion(SwiftConstants.Receipt_not_found)
            return
        }
        let encryptedReceipt = receiptData.base64EncodedString(options: [])
        print("Fetch receipt success:\n\(encryptedReceipt)")
        completion(encryptedReceipt)
    }

    //---METHODS EXPOSED TO OUTER CONTROLLER---//
    fileprivate func getInfo(_ purchase: RegisteredPurchase, vc:UIViewController) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        getAllProducts(prodIds: [purchase.rawValue]) { products in
            NetworkActivityIndicatorManager.networkOperationFinished()
            if let product = products.first {
                let priceString = product.localizedPriceString ?? ""
                vc.showAlert(vc.alertWithTitle(product.localizedTitle,
                                               message: "\(product.localizedDescription) - \(priceString)"))
            } else {
                vc.showAlert(vc.alertWithTitle("Could not retrieve product info",
                                               message: "Invalid product identifier: \(purchase.rawValue)"))
            }
        }
    }

    fileprivate func purchase(_ purchase: String, atomically: Bool, vc:UIViewController) {
        print("purchase productID = \(purchase)")
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftFTUtils.showHUDAdded(to: vc.view, withText: "", animated: true)
        Task { @MainActor in
            // Ensure StoreKit 2 products are loaded, then find the requested one.
            let store = StoreService.shared
            if store.products.isEmpty {
                await store.loadProducts()
            }
            guard let product = store.products.first(where: { $0.id == purchase }) else {
                self.finishPurchaseUI(vc: vc, success: false)
                return
            }
            let success = await store.purchase(product)
            NetworkActivityIndicatorManager.networkOperationFinished()
            self.finishPurchaseUI(vc: vc, success: success)
        }
    }

    /// Shared UI teardown for a completed (or failed) purchase, mirroring the
    /// legacy IAP SDK completion-handler behaviour.
    @MainActor
    private func finishPurchaseUI(vc: UIViewController, success: Bool) {
        SwiftFTUtils.hideHUDAdded(to: vc.view, animated: true)
        NotificationCenter.default.post(name: Notification.Name.init("isShowLoader"), object: nil)
        if success {
            UserDefaults.standard.set(true, forKey: UserDefaultsConstants.SUBSCRIPTION_DONE_KEY)
            UserDefaults.standard.synchronize()
            self.delegate?.drawerCont.contName = "Drawer"
            UserDefaults.standard.set("Settings", forKey: UserDefaultsConstants.DRAWER_TYPE)
            AppDelegateShared().setupDrawer(0)
        } else {
            let alert = UIAlertController(title: "Alert!", message: "Purchase failed. Please try again.", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default) {_ in
                self.delegate?.drawerCont.contName = "Drawer"
                UserDefaults.standard.set("Settings", forKey: UserDefaultsConstants.DRAWER_TYPE)
                AppDelegateShared().setupDrawer(0)
            }
            alert.addAction(action)
            vc.showAlert(alert)
        }
    }

    fileprivate func verifySubscriptions(_ purchases: Set<RegisteredPurchase>, vc:UIViewController) {
        // TODO StoreKit2: per-product verification is now handled locally by
        // StoreKit 2 (`Transaction.currentEntitlements`) and confirmed by the
        // backend through `EntitlementService`. Reuse the entitlement refresh.
        verifyReceipt(vc: vc)
    }

    fileprivate func verifyPurchase(_ purchase: RegisteredPurchase, vc:UIViewController) {
        // TODO StoreKit2: same as `verifySubscriptions` — entitlement state is the
        // single source of truth; no the legacy IAP SDK receipt parsing.
        verifyReceipt(vc: vc)
    }
}

// MARK: - Native SKProductsRequest bridge

/// Lightweight wrapper around `SKProductsRequest` so `getAllProducts` can keep
/// returning `[SKProduct]` (the contract `SubscriptionVC` depends on) without
/// the legacy IAP SDK. StoreKit 2's `Product` is used for purchasing; this is only
/// for fetching display metadata into the legacy UIKit screen.
private final class ProductsRequestProxy: NSObject, SKProductsRequestDelegate {
    private let completion: ([SKProduct]) -> Void
    private var request: SKProductsRequest?

    init(completion: @escaping ([SKProduct]) -> Void) {
        self.completion = completion
    }

    func start(productIdentifiers: Set<String>) {
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        self.request = request
        request.delegate = self
        request.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        DispatchQueue.main.async { [completion] in
            completion(products)
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Products request failed: \(error)")
        DispatchQueue.main.async { [completion] in
            completion([])
        }
    }
}

// MARK: - SKProduct localized price (replaces the legacy IAP SDK's `.localizedPrice`)

extension SKProduct {
    /// Formats `price`/`priceLocale` into a currency string. Replaces the
    /// the legacy IAP SDK `localizedPrice` extension. Returns `nil` if formatting
    /// fails (callers already treat the price string as optional).
    var localizedPriceString: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }
}

// MARK: - User facing alerts
extension UIViewController {
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }

    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
}
