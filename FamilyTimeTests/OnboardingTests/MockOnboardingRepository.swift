//
//  MockOnboardingRepository.swift
//  FamilyTimeTests
//
//  Test double for `OnboardingRepositoryProtocol`. Each method returns a
//  caller-configured `Result` and records how many times it was invoked plus
//  the last arguments it received. No UIKit, no force-unwraps.
//

import Foundation
@testable import FamilyTime

/// Configurable, stateful mock for `OnboardingRepositoryProtocol`.
final class MockOnboardingRepository: OnboardingRepositoryProtocol {

    // MARK: Stubbed outcomes

    /// Outcome for `fetchQRCode`. Defaults to a benign success payload.
    var qrResult: Result<String, Error> = .success("qr-payload")

    /// Outcome for `addChild`. Defaults to a benign new-child id.
    var addChildResult: Result<String, Error> = .success("new-child-id")

    /// Outcome for `checkPairingStatus`. Defaults to "not yet paired".
    var pairingResult: Result<Bool, Error> = .success(false)

    // MARK: Call counters

    private(set) var fetchQRCount = 0
    private(set) var addChildCount = 0
    private(set) var pairingCount = 0

    // MARK: Last-received arguments

    private(set) var lastFetchQRChildId: String?
    private(set) var lastPairingChildId: String?
    private(set) var lastAddChildName: String?
    private(set) var lastAddChildPlatform: String?
    private(set) var lastAddChildRelationship: String?
    private(set) var lastAddChildGender: String?
    private(set) var lastAddChildAge: String?

    // MARK: OnboardingRepositoryProtocol

    func fetchQRCode(childId: String) async throws -> String {
        fetchQRCount += 1
        lastFetchQRChildId = childId
        return try qrResult.get()
    }

    func addChild(
        name: String,
        platform: String,
        relationship: String?,
        gender: String?,
        age: String?
    ) async throws -> String {
        addChildCount += 1
        lastAddChildName = name
        lastAddChildPlatform = platform
        lastAddChildRelationship = relationship
        lastAddChildGender = gender
        lastAddChildAge = age
        return try addChildResult.get()
    }

    func checkPairingStatus(childId: String) async throws -> Bool {
        pairingCount += 1
        lastPairingChildId = childId
        return try pairingResult.get()
    }
}
