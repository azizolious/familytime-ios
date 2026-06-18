import SwiftUI

/// The tab shell that assembles the migrated SwiftUI screens. Created in the
/// Phase 2 Support step so the dormant SwiftUI layer has a single home for
/// Dashboard / Reports / Settings / Support. Still dormant at runtime (the app
/// entry point is not flipped yet — see `FamilyTimeApp`).
enum AppTab: Hashable {
    case dashboard
    case reports
    case settings
    case support
}

struct AppNavigationView: View {
    @State private var selectedTab: AppTab = .dashboard

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Label("Dashboard", systemImage: "house.fill") }
                .tag(AppTab.dashboard)

            ReportsView()
                .tabItem { Label("Reports", systemImage: "chart.bar.fill") }
                .tag(AppTab.reports)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                .tag(AppTab.settings)

            SupportView()
                .tabItem { Label("Support", systemImage: "message.fill") }
                .tag(AppTab.support)
        }
    }
}
