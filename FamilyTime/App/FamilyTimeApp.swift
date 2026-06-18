import SwiftUI

// NOTE: `@main` is intentionally NOT applied here. `main` is a live UIKit app
// (entry point is `main.m` → UIApplicationMain → AppDelegate). This SwiftUI App
// is compiled but dormant; the entry point will be flipped to SwiftUI only once
// the SwiftUI screens fully replace the UIKit launch flow (later modernization step).
struct FamilyTimeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var sessionManager = SessionManager.shared
    @State private var entitlementService = EntitlementService.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(sessionManager)
                .environment(entitlementService)
                .task {
                    await sessionManager.restoreSession()
                    StoreService.shared.start() // StoreKit 2 Transaction.updates listener (replaces legacy IAPUtility.setupIAP)
                }
        }
    }
}
