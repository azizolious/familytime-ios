//
//  CoreSmokeTests.swift
//  FamilyTimeTests
//
//  Smoke tests for the core SwiftUI/Swift layer — confirm the key singletons and
//  value types exist and behave at the most basic level after the P3 teardown +
//  CocoaPods elimination. @testable import gives access to internal types.
//

import XCTest
@testable import FamilyTime

@MainActor
final class CoreSmokeTests: XCTestCase {

    func testSessionManagerExists() {
        XCTAssertNotNil(SessionManager.shared)
    }

    func testPersistedTokenReturnsOptional() {
        // Must not crash — returns nil or a String.
        _ = SessionManager.persistedToken
        XCTAssertTrue(true)
    }

    func testNetworkErrorDescriptions() {
        let errors: [NetworkError] = [
            .invalidURL,
            .noData,
            .authenticationRequired,
            .timeout
        ]
        for error in errors {
            XCTAssertNotNil(error.errorDescription)
        }
    }

    func testHTTPVerbRawValues() {
        XCTAssertEqual(HTTPVerb.get.rawValue, "GET")
        XCTAssertEqual(HTTPVerb.post.rawValue, "POST")
        XCTAssertEqual(HTTPVerb.put.rawValue, "PUT")
        XCTAssertEqual(HTTPVerb.delete.rawValue, "DELETE")
    }

    func testEntitlementServiceExists() {
        XCTAssertNotNil(EntitlementService.shared)
    }

    func testSelectedChildStoreExists() {
        XCTAssertNotNil(SelectedChildStore.shared)
    }
}
