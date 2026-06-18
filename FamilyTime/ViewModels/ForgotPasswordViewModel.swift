import Foundation

/// Server response for the forgot-password request.
struct ForgotPasswordResponse: Decodable {
    let success: Bool // TODO confirm server JSON
}

/// Drives the forgot-password screen: validates the email, calls the API,
/// and surfaces loading / success / error state to the view.
@MainActor
@Observable
final class ForgotPasswordViewModel {
    var email = ""
    var isLoading = false
    var errorMessage: String?
    var successMessage: String?
    var isSubmitted = false

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    /// Validates the email and requests a password-reset link.
    func submit() async {
        guard email.isValidEmail else {
            errorMessage = "Enter a valid email"
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let _: ForgotPasswordResponse = try await apiClient.request(
                FamilyTimeEndpoint.forgotPassword(email: email)
            )
            successMessage = "Password reset link sent."
            isSubmitted = true
            errorMessage = nil
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
