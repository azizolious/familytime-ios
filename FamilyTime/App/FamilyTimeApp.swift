import SwiftUI

// NOTE: `@main` is intentionally NOT applied here. `main` is a live UIKit app
// (entry point is `main.m` → UIApplicationMain → AppDelegate). This SwiftUI App
// is compiled but dormant; the entry point will be flipped to SwiftUI only once
// the SwiftUI screens fully replace the UIKit launch flow (later modernization step).
struct FamilyTimeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // Convention: process-wide services (SessionManager, EntitlementService,
    // SelectedChildStore) are observed directly via their `.shared` singletons in
    // each View (e.g. RootView/LoginView). The runtime test showed App-level
    // `.environment(...)` injection did NOT reach the WindowGroup content view, so
    // there is no environment injection here — views read `.shared` directly.
    var body: some Scene {
        WindowGroup {
            RootView()
                .task {
                    await SessionManager.shared.restoreSession()
                    StoreService.shared.start() // StoreKit 2 Transaction.updates listener (replaces legacy IAPUtility.setupIAP)
                }
        }
    }
}
