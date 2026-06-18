import SwiftUI

struct RootView: View {
    @Environment(SessionManager.self) private var sessionManager

    // Observe the selected-child store so onboarding vs. dashboard routing updates
    // live when a child is selected (e.g. at the end of the onboarding flow).
    @State private var selectedChildStore = SelectedChildStore.shared

    // Bridge wired: `.sessionExpired` (defined in Utilities/NotificationNames.swift) is posted by the
    // central logout sinks (SwiftCommonModel.clearDataAndLogout(on:isPresentedVC:) and
    // CommonModel.clearDataAndLogoutOnController:isPresentedVC:), so this fires at runtime when any
    // legacy screen detects session expiry and runs the central logout.
    var body: some View {
        Group {
            if sessionManager.isAuthenticated {
                // "Has children" detection: route to onboarding until a child is selected.
                if selectedChildStore.selectedChildID == nil {
                    OnboardingView()
                } else {
                    AppNavigationView()
                }
            } else {
                AuthRootView()                     // provided by another agent (Views/Auth/)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .sessionExpired)) { _ in
            sessionManager.clearSession()
        }
    }
}
