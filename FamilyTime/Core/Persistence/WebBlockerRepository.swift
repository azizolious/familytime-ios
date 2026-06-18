//
//  WebBlockerRepository.swift
//  FamilyTime
//
//  WebBlocker data access on the modern async APIClient — replaces the legacy
//  CoreManager (networking) + DBManager (Core Data cache) paths used by the
//  WebBlocker view models. Network is the source of truth (no local cache).
//

import Foundation

protocol WebBlockerRepositoryProtocol {
    /// GET /web-blocker → the saved web-blocker URL list.
    func fetchWebBlockers() async throws -> [WebBlockerObj]
    /// GET /controls → the `web_blocker` feature control (on/off + ids).
    func fetchWebBlockerControl() async throws -> Control
    /// PATCH /controls/web-blocker → persist the edited list.
    func save(_ apps: [WebBlockerObj]) async throws
    /// POST /web-blocker → add new URLs.
    func add(_ apps: [WebBlockerObj]) async throws
    /// DELETE /web-blocker → remove the given URLs.
    func remove(_ apps: [WebBlockerObj]) async throws
}

final class WebBlockerRepository: WebBlockerRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchWebBlockers() async throws -> [WebBlockerObj] {
        let response: WebBlockerModel = try await apiClient.request(FamilyTimeEndpoint.webBlockerList)
        return response.webBlockers ?? []
    }

    func fetchWebBlockerControl() async throws -> Control {
        let response: ControlCodableModel = try await apiClient.request(FamilyTimeEndpoint.controlsList)
        return response.controls?.first(where: { $0.identifier == "web_blocker" }) ?? Control()
    }

    func save(_ apps: [WebBlockerObj]) async throws {
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.updateWebBlocker(body: WebBlockerListBody(data: apps)))
    }

    func add(_ apps: [WebBlockerObj]) async throws {
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.addWebBlocker(body: WebBlockerListBody(data: apps)))
    }

    func remove(_ apps: [WebBlockerObj]) async throws {
        let _: EmptyDecodableResponse = try await apiClient.request(
            FamilyTimeEndpoint.deleteWebBlocker(body: WebBlockerListBody(data: apps)))
    }
}
