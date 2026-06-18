import Foundation

/// Abstraction over the networking layer so callers can be tested with mocks.
protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T
}

/// Default `URLSession`-backed implementation of `APIClientProtocol`.
final class APIClient: APIClientProtocol {
    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T {
        // SessionManager is @MainActor, so the token must be awaited.
        let token = await SessionManager.shared.currentToken

        let req: URLRequest
        do {
            req = try endpoint.urlRequest(authToken: token)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: req)
        } catch let error as URLError where error.code == .timedOut {
            throw NetworkError.timeout
        } catch {
            throw NetworkError.unknown(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }

        if httpResponse.statusCode == 401 {
            throw NetworkError.authenticationRequired
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let message = String(data: data, encoding: .utf8)
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: message)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
