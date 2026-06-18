import SwiftUI

/// Lets the user request a password-reset link by entering their email.
struct ForgotPasswordView: View {
    @State private var viewModel = ForgotPasswordViewModel()

    var body: some View {
        Form {
            Section {
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .font(.caption)
            }

            Button("Send Reset Link") {
                Task { await viewModel.submit() }
            }
            .disabled(viewModel.email.isEmpty || viewModel.isLoading)
        }
        .navigationTitle("Forgot Password")
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}
