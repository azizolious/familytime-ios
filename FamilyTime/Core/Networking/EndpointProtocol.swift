import Foundation

/// Describes a single API endpoint and how to turn it into a `URLRequest`.
protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPVerb { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: String]? { get }
    var body: (any Encodable)? { get }
}

extension EndpointProtocol {
    /// Builds a fully configured `URLRequest` for this endpoint.
    /// - Parameter authToken: Optional bearer token added as an `Authorization` header.
    /// - Throws: `NetworkError.invalidURL` if a valid URL cannot be constructed.
    func urlRequest(authToken: String?) throws -> URLRequest {
        // Combine baseURL + path. Either may already contain the full URL, so we
        // build via URLComponents to safely append query parameters.
        let urlString = baseURL + path
        guard var components = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }

        if let queryParameters, !queryParameters.isEmpty {
            let items = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            // Preserve any pre-existing query items already encoded in the path.
            components.queryItems = (components.queryItems ?? []) + items
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        if let authToken {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
        }

        return request
    }
}

/// Type-erasing wrapper that allows encoding a value held as `any Encodable`.
private struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void

    init(_ wrapped: any Encodable) {
        self.encodeFunc = { encoder in
            try wrapped.encode(to: encoder)
        }
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
