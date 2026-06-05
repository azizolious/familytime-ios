//
//  IAPUtility.swift
//  FamilyTime
//  Created by Sana Ullah on 15/01/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//  Modified by Usama-Apps on 2022.
//

import Foundation
import StoreKit
import SwiftyStoreKit

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
    
    //MARK: - APPDELEGATE METHOD
    @objc func setupIAP() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        //                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                        self.validateServerPurchaseForStartup(purchase: purchase, vc: UIViewController())
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
        //        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
        //
        //            // contentURL is not nil if downloadState == .finished
        //            let contentURLs = downloads.compactMap { $0.contentURL }
        //            if contentURLs.count == downloads.count {
        //                print("Saving: \(contentURLs)")
        //                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
        //            }
        //        }
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
        //        verifySubscriptions([.autoRenewableWeekly, .autoRenewableMonthly, .autoRenewableYearly])
    }
    
    func verifyReceipt(vc:UIViewController) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            vc.showAlert(vc.alertForVerifyReceipt(result))
        }
    }
    
    func restorePurchases(vc:UIViewController) {
        SwiftFTUtils.showHUDAdded(to: vc.view, withText: "", animated: true)
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            SwiftFTUtils.hideHUDAdded(to: vc.view, animated: true)
            NetworkActivityIndicatorManager.networkOperationFinished()
            for purchase in results.restoredPurchases {
                if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            SwiftFTUtils.hideHUDAdded(to: vc.view, animated: true)
            vc.showAlert(vc.alertForRestorePurchases(results))
        }
    }
    
    func getAllProducts(prodIds:Set<String>, onCompletion: @escaping ([SKProduct]) -> ()){
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo(prodIds) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            if let product = result.retrievedProducts.first {
                _ = result.retrievedProducts.map{print("product price = \(String(describing: $0.localizedPrice)) \ntitle = \($0.localizedTitle)\ndescription = \($0.localizedDescription)")}
                //                _ = result.retrievedProducts.map{print("product price = \($0.localizedPrice) \ntitle = \($0.localizedTitle) and \ndescription = \($0.localizedDescription) \nproductIdentifier = \($0.productIdentifier) \nsubscriptionPeriod = \($0.subscriptionPeriod) \ndiscounprice = \($0.introductoryPrice) \ngroupIdentifier = \($0.subscriptionGroupIdentifier)")}
                onCompletion(Array(result.retrievedProducts))
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        }
    }
    
    func getReceipt(completion : @escaping ((String) -> ())){
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                print("Fetch receipt success:\n\(encryptedReceipt)")
                completion(encryptedReceipt)
            case .error(let error):
                print("Fetch receipt failed: \(error)")
                completion(SwiftConstants.Receipt_not_found)
            }
        }
    }
    
    //---METHODS EXPOSED TO OUTER CONTROLLER---//
    fileprivate func getInfo(_ purchase: RegisteredPurchase, vc:UIViewController) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([purchase.rawValue]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            vc.showAlert(vc.alertForProductRetrievalInfo(result))
        }
    }
    
    fileprivate func purchase(_ purchase: String, atomically: Bool, vc:UIViewController) {
        print("purchase productID = \(purchase)")
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftFTUtils.showHUDAdded(to: vc.view, withText: "", animated: true)
        SwiftyStoreKit.purchaseProduct(purchase, atomically: atomically,applicationUsername: uniqueDeviceId ?? "uniqueDeviceID") { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            SwiftFTUtils.hideHUDAdded(to: vc.view, animated: true)
            NotificationCenter.default.post(name: Notification.Name.init("isShowLoader"), object: nil)
            print("purchase result = \(result)")
            if case .success(let purchase) = result {
                self.validateServerPurchase(purchase: purchase, vc: vc)
                ///IF PURCHASE SUCCESSFUL THEN TAKE TO HOME AND REFRESH
//                NotificationCenter.default.post(name: NSNotification.Name("RELOAD_DASHBOARD"), object: nil)
                UserDefaults.standard.set(true, forKey: UserDefaultsConstants.SUBSCRIPTION_DONE_KEY)
                UserDefaults.standard.synchronize()
                self.delegate?.drawerCont.contName = "Drawer"
                UserDefaults.standard.set("Settings", forKey: UserDefaultsConstants.DRAWER_TYPE)
                AppDelegateShared().setupDrawer(0)
            }
            if case .error = result {
                ///Un Comment the following code when you have to switch between payment methods
//                let lastTimeClickedUpgrade = UserDefaults.standard.string(forKey: UserDefaultsConstants.LAST_TIME_CLICKED_UPGRADE)
//                let lastTimeClickedTrail = UserDefaults.standard.string(forKey: UserDefaultsConstants.LAST_TIME_CLICKED_TRIAL)
//                if lastTimeClickedUpgrade != nil, let lastTimeClicked = lastTimeClickedUpgrade {
//                    if lastTimeClicked == StringConstants.Constants.INTERNAL {
//                        UserDefaults.standard.set(StringConstants.Constants.EXTERNAL, forKey: UserDefaultsConstants.LAST_TIME_CLICKED_UPGRADE)
//                        UserDefaults.standard.synchronize()
//                    } else if lastTimeClicked == StringConstants.Constants.EXTERNAL {
//                        UserDefaults.standard.set(StringConstants.Constants.INTERNAL, forKey: UserDefaultsConstants.LAST_TIME_CLICKED_UPGRADE)
//                        UserDefaults.standard.synchronize()
//                    }
//                }
//                if lastTimeClickedTrail != nil, let lastTimeClciked = lastTimeClickedTrail {
//                    if lastTimeClciked == StringConstants.Constants.APPLE_TRIAL_INT {
//                        UserDefaults.standard.set(StringConstants.Constants.FAST_SPRING_TRIAL_EXT, forKey: UserDefaultsConstants.LAST_TIME_CLICKED_TRIAL)
//                        UserDefaults.standard.synchronize()
//                    } else if lastTimeClciked == StringConstants.Constants.FAST_SPRING_TRIAL_EXT {
//                        UserDefaults.standard.set(StringConstants.Constants.APPLE_TRIAL_INT, forKey: UserDefaultsConstants.LAST_TIME_CLICKED_TRIAL)
//                        UserDefaults.standard.synchronize()
//                    }
//                }
                
                let productName = UserDefaults.standard.string(forKey: UserDefaultsConstants.PRODUCT_NAME_INTERNAL) ?? ""
                let productPrice = UserDefaults.standard.string(forKey: UserDefaultsConstants.PRODUCT_PRICE_INTERNAL) ?? ""
                let params = [ "sub_url" : purchase,
                               "product_name" : productName,
                               "product_price" : productPrice
                ] as! [String :Any]
                HLApiManager.networkCallSubscriptionCancelled(params: params) { response, error in
                    if let responseData = response {
                        if responseData {
                            NotificationCenter.default.post(name: Notification.Name.init("isShowAlert"), object: nil)
                            UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PRODUCT_NAME_INTERNAL)
                            UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PRODUCT_PRICE_INTERNAL)
                            UserDefaults.standard.synchronize()
                            let alert = UIAlertController(title: "Alert!", message: "Subscription is cancelled!", preferredStyle: .alert)
                            let action = UIAlertAction(title: "ok", style: .default) {_ in
                                let showNotification = UserDefaults.standard.bool(forKey: UserDefaultsConstants.SHOW_SUB_INT_NOTIFICATION)
                                if showNotification == false {
                                    UserDefaults.standard.setValue(true, forKey: UserDefaultsConstants.SHOW_SUB_INT_NOTIFICATION)
                                    UserDefaults.standard.setValue(true, forKey: UserDefaultsConstants.SUBSCRIPTION_CHECK_KEY)
                                    UserDefaults.standard.synchronize()
                                }
                                self.delegate?.drawerCont.contName = "Drawer"
                                UserDefaults.standard.set("Settings", forKey: UserDefaultsConstants.DRAWER_TYPE)
                                AppDelegateShared().setupDrawer(0)
                            }
                            alert.addAction(action)
                            vc.showAlert(alert)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func validateServerPurchase(purchase:PurchaseDetails, vc:UIViewController){
        self.getReceipt(completion: { (receipt) in
            if receipt != SwiftConstants.Receipt_not_found {
                SwiftyStoreKit.finishTransaction(purchase.transaction)
//                ApiManager.shared().postApiToValidateReceipt(withVC: vc, andParams: ["receipt" : receipt], withApi: SwiftAPIConstants.kValidateReceipt_mesh2, withResponse: { (error, statusCode, verifyStatusCode) in
//                    print(receipt)
//                    print(statusCode)
//                    print("error = \(error), statusCode = \(statusCode), verifyStatusCode = \(verifyStatusCode)")
//                    if statusCode == 200, verifyStatusCode == 0 {
//                        print("going to finish transaction after verifying from server")
//                        //if purchase.needsFinishTransaction {
//
//                        //}
//                    }
//                })
            }
            else{
                print("receipt not found")
            }
        })
    }
    
    //---FOR INITIAL SETUP IT TAKES PURCHASE NOT PURCHASE DETAILS---//
    fileprivate func validateServerPurchaseForStartup(purchase:Purchase, vc:UIViewController){
        self.getReceipt(completion: { (receipt) in
            if receipt != SwiftConstants.Receipt_not_found{
                print(receipt)
                SwiftyStoreKit.finishTransaction(purchase.transaction)
//                ApiManager.shared().postApiToValidateReceipt(withVC: vc, andParams: ["receipt" : receipt], withApi: SwiftAPIConstants.kValidateReceipt_mesh2, withResponse: { (error, statusCode, verifyStatusCode) in
//                    print("error = \(error), statusCode = \(statusCode), verifyStatusCode = \(verifyStatusCode)")
//                    if statusCode == 200, verifyStatusCode == 0{
//                        print("going to finish transaction after verifying from server")
//                        //if purchase.needsFinishTransaction {
//
//                        //}
//                    }
//                })
            } else {
                print("receipt not found")
            }
        })
    }
    
    fileprivate func verifySubscriptions(_ purchases: Set<RegisteredPurchase>, vc:UIViewController) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            switch result {
            case .success(let receipt):
                let productIds = Set(purchases.map { $0.rawValue })
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                vc.showAlert(vc.alertForVerifySubscriptions(purchaseResult, productIds: productIds))
            case .error:
                vc.showAlert(vc.alertForVerifyReceipt(result))
            }
        }
    }
    
    fileprivate func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "your-shared-secret")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    fileprivate func verifyPurchase(_ purchase: RegisteredPurchase, vc:UIViewController) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            switch result {
            case .success(let receipt):
                let productId = purchase.rawValue
                switch purchase {
                case .autoRenewableWeekly, .autoRenewableMonthly, .autoRenewableYearly:
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .autoRenewable,
                        productId: productId,
                        inReceipt: receipt)
                    vc.showAlert(vc.alertForVerifySubscriptions(purchaseResult, productIds: [productId]))
                case .nonRenewingPurchase:
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .nonRenewing(validDuration: 60),
                        productId: productId,
                        inReceipt: receipt)
                    vc.showAlert(vc.alertForVerifySubscriptions(purchaseResult, productIds: [productId]))
                default:
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(
                        productId: productId,
                        inReceipt: receipt)
                    vc.showAlert(vc.alertForVerifyPurchase(purchaseResult, productId: productId))
                }
            case .error:
                vc.showAlert(vc.alertForVerifyReceipt(result))
            }
        }
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
    
    func alertForProductRetrievalInfo(_ result: RetrieveResults) -> UIAlertController {
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        } else if let invalidProductId = result.invalidProductIDs.first {
            return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
        } else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            return alertWithTitle("Could not retrieve product info", message: errorString)
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            return nil
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error.code {
            case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            default:
                return alertWithTitle("Purchase failed", message: (error as NSError).localizedDescription)
            }
        }
    }
    
    func alertForRestorePurchases(_ results: RestoreResults) -> UIAlertController {
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
        } else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            return alertWithTitle("Purchases Restored", message: "All purchases have been restored")
        } else {
            print("Nothing to Restore")
            return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
        }
    }
    
    func alertForVerifyReceipt(_ result: VerifyReceiptResult) -> UIAlertController {
        switch result {
        case .success(let receipt):
            print("Verify receipt Success: \(receipt)")
            return alertWithTitle("Receipt verified", message: "Receipt verified remotely")
        case .error(let error):
            print("Verify receipt Failed: \(error)")
            switch error {
            case .noReceiptData:
                return alertWithTitle("Receipt verification", message: "No receipt data. Try again.")
            case .networkError(let error):
                return alertWithTitle("Receipt verification", message: "Network error while verifying receipt: \(error)")
            default:
                return alertWithTitle("Receipt verification", message: "Receipt verification failed: \(error)")
            }
        }
    }
    
    func alertForVerifySubscriptions(_ result: VerifySubscriptionResult, productIds: Set<String>) -> UIAlertController {
        switch result {
        case .purchased(let expiryDate, let items):
            print("\(productIds) is valid until \(expiryDate)\n\(items)\n")
            return alertWithTitle("Product is purchased", message: "Product is valid until \(expiryDate)")
        case .expired(let expiryDate, let items):
            print("\(productIds) is expired since \(expiryDate)\n\(items)\n")
            return alertWithTitle("Product expired", message: "Product is expired since \(expiryDate)")
        case .notPurchased:
            print("\(productIds) has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
    
    func alertForVerifyPurchase(_ result: VerifyPurchaseResult, productId: String) -> UIAlertController {
        switch result {
        case .purchased:
            print("\(productId) is purchased")
            return alertWithTitle("Product is purchased", message: "Product will not expire")
        case .notPurchased:
            print("\(productId) has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
}

