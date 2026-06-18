import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    @Environment(SessionManager.self) private var sessionManager

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
                // TODO(Phase 2): GoogleSignIn is UIKit-based — wire via a SwiftUI bridge later
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
            .environment(SessionManager.shared)
    }
}
