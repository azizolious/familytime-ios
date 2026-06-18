import SwiftUI
import GoogleMaps

// FamilyTime is a SwiftUI app: `FamilyTimeApp` is the permanent entry point (the
// legacy UIKit `main.m`/`UIApplicationMain` was removed June 2026). The UIKit
// `AppDelegate` is retained via `@UIApplicationDelegateAdaptor` so push
// notifications, Firebase, and legacy VC hosting keep working while the remaining
// UIKit screens are deleted one by one.
@main
struct FamilyTimeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        // GoogleMaps key (SPM GoogleMaps; read in Swift to avoid an ObjC binary-
        // framework import). Key from Info.plist -> Config.xcconfig; none in source.
        let mapsKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String ?? ""
        if !mapsKey.isEmpty { GMSServices.provideAPIKey(mapsKey) }
    }

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
