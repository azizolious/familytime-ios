//
//  MockAppBlockingRepository.swift
//  FamilyTimeTests
//
//  Test double for `AppBlockingRepositoryProtocol`. Methods return a
//  caller-configured `Result`, count their invocations and capture the last
//  arguments they received. No UIKit, no force-unwraps.
//

import Foundation
@testable import FamilyTime

/// Configurable, stateful mock for `AppBlockingRepositoryProtocol`.
final class MockAppBlockingRepository: AppBlockingRepositoryProtocol {

    // MARK: Stubbed outcomes

    /// Outcome for `fetchApps`. Defaults to an empty list.
    var appsResult: Result<[BlockableApp], Error> = .success([])

    /// Outcome for `setBlocked`. `Void` success by default.
    var setBlockedResult: Result<Void, Error> = .success(())

    /// Outcome for `fetchContentFilters`. Defaults to an empty list.
    var contentResult: Result<[ContentFilterSetting], Error> = .success([])

    /// Outcome for `updateContentFilters`. `Void` success by default.
    var updateContentResult: Result<Void, Error> = .success(())

    // MARK: Call counters

    private(set) var fetchAppsCount = 0
    private(set) var setBlockedCount = 0
    private(set) var fetchContentFiltersCount = 0
    private(set) var updateContentFiltersCount = 0

    // MARK: Last-received arguments

    private(set) var lastFetchAppsChildId: String?
    private(set) var lastSetBlockedChildId: String?
    private(set) var lastSetBlockedAppId: String?
    private(set) var lastSetBlockedFlag: Bool?
    private(set) var lastFetchContentChildId: String?
    private(set) var lastUpdateContentId: Int?
    private(set) var lastUpdateContentChildId: String?
    private(set) var lastUpdateContentPayload: String?

    // MARK: AppBlockingRepositoryProtocol

    func fetchApps(childId: String) async throws -> [BlockableApp] {
        fetchAppsCount += 1
        lastFetchAppsChildId = childId
        return try appsResult.get()
    }

    func setBlocked(childId: String, appId: String, blocked: Bool) async throws {
        setBlockedCount += 1
        lastSetBlockedChildId = childId
        lastSetBlockedAppId = appId
        lastSetBlockedFlag = blocked
        try setBlockedResult.get()
    }

    func fetchContentFilters(childId: String) async throws -> [ContentFilterSetting] {
        fetchContentFiltersCount += 1
        lastFetchContentChildId = childId
        return try contentResult.get()
    }

    func updateContentFilters(id: Int, childId: String, mdmPayload: String) async throws {
        updateContentFiltersCount += 1
        lastUpdateContentId = id
        lastUpdateContentChildId = childId
        lastUpdateContentPayload = mdmPayload
        try updateContentResult.get()
    }
}
