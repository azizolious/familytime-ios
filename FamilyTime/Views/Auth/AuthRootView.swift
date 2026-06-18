import SwiftUI

struct AuthRootView: View {
    var body: some View {
        NavigationStack {
            LoginView()
        }
    }
}

#Preview {
    AuthRootView()
        .environment(SessionManager.shared)
}
