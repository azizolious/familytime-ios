import SwiftUI
import UIKit
import AuthenticationServices

struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    @State private var sessionManager = SessionManager.shared

    /// The frontmost UIViewController, used as the presenter for GoogleSignIn's
    /// OAuth flow (GoogleSignIn 7.x requires a presenting UIViewController).
    static func topViewController() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive } ?? UIApplication.shared.connectedScenes.first as? UIWindowScene
        var top = scene?.keyWindow?.rootViewController
            ?? scene?.windows.first?.rootViewController
        while let presented = top?.presentedViewController { top = presented }
        return top
    }

    var body: some View {
        VStack(spacing: 16) {
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 80)

            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
                .textFieldStyle(.roundedBorder)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .font(.caption)
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button {
                Task { await viewModel.login() }
            } label: {
                Text("Log In")
                    .frame(maxWidth: .infinity)
            }
            .disabled(!viewModel.isLoginEnabled)
            .buttonStyle(.borderedProminent)

            NavigationLink {
                ForgotPasswordView()
            } label: {
                Text("Forgot Password?")
            }

            Divider()

            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                        Task { await viewModel.signInWithApple(credential: credential) }
                    }
                case .failure(let error):
                    viewModel.errorMessage = error.localizedDescription
                }
            }
            .frame(height: 44)

            Button {
                guard let presenter = Self.topViewController() else { return }
                Task { await viewModel.signInWithGoogle(presenting: presenter) }
            } label: {
                Text("Sign in with Google")
                    .frame(maxWidth: .infinity)
            }

            NavigationLink {
                SignUpView()
            } label: {
                Text("Don't have an account? Sign Up")
            }
        }
        .padding()
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
