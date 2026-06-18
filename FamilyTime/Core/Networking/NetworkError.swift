import Foundation

/// Errors that can occur while performing a network request.
enum NetworkError: Error, LocalizedError {
    /// The endpoint produced a URL that could not be constructed.
    case invalidURL
    /// The server returned an empty/absent response body.
    case noData
    /// Decoding the response into the expected model failed.
    case decodingFailed(Error)
    /// The server responded with a non-success status code.
    case serverError(statusCode: Int, message: String?)
    /// The request requires authentication (e.g. HTTP 401).
    case authenticationRequired
    /// The request exceeded its allotted time.
    case timeout
    /// Any other, unclassified error.
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request could not be sent because the URL was invalid."
        case .noData:
            return "The server returned no data."
        case .decodingFailed(let error):
            return "The server response could not be read. (\(error.localizedDescription))"
        case .serverError(let statusCode, let message):
            if let message, !message.isEmpty {
                return "The server returned an error (\(statusCode)): \(message)"
            }
            return "The server returned an error with status code \(statusCode)."
        case .authenticationRequired:
            return "You need to sign in again to continue."
        case .timeout:
            return "The request timed out. Please check your connection and try again."
        case .unknown(let error):
            return "An unexpected error occurred. (\(error.localizedDescription))"
        }
    }
}
