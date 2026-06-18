//
//  OnboardingViewModelTests.swift
//  FamilyTimeTests
//
//  Unit tests for `OnboardingViewModel` (parity sprint). Drives the shared
//  `SelectedChildStore` (seeded in setUp, reset in tearDown) and injects a
//  `MockOnboardingRepository`. async/await XCTest, @MainActor, no UIKit,
//  no force-unwraps.
//
//  NOTE: the FamilyTimeTests target is not yet wired into the build; these
//  tests are written to compile and run once it is.
//

import XCTest
@testable import FamilyTime

@MainActor
final class OnboardingViewModelTests: XCTestCase {

    private var repository: MockOnboardingRepository!

    override func setUp() {
        super.setUp()
        repository = MockOnboardingRepository()
        // Seed the shared store so the view model captures a child id on init.
        SelectedChildStore.shared.selectID("42")
    }

    override func tearDown() {
        SelectedChildStore.shared.selectID(nil)
        repository = nil
        super.tearDown()
    }

    /// Builds a view model wired to the mock and the shared store.
    private func makeSUT() -> OnboardingViewModel {
        OnboardingViewModel(
            repository: repository,
            selectedChildStore: SelectedChildStore.shared
        )
    }

    // MARK: generateQR

    func test_generateQR_onSuccess_populatesQRPayload() async {
        repository.qrResult = .success("payload-xyz")
        let sut = makeSUT()

        await sut.generateQR()

        XCTAssertEqual(sut.qrPayload, "payload-xyz")
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(repository.fetchQRCount, 1)
        XCTAssertEqual(repository.lastFetchQRChildId, "42")
    }

    func test_generateQR_onAuthFailure_setsErrorMessage() async {
        repository.qrResult = .failure(NetworkError.authenticationRequired)
        let sut = makeSUT()

        await sut.generateQR()

        XCTAssertNil(sut.qrPayload)
        XCTAssertEqual(
            sut.errorMessage,
            NetworkError.authenticationRequired.errorDescription
        )
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(repository.fetchQRCount, 1)
    }

    func test_generateQR_withNoChild_setsErrorAndSkipsRepository() async {
        // Clear the child before constructing so init captures nil.
        SelectedChildStore.shared.selectID(nil)
        let sut = makeSUT()

        await sut.generateQR()

        XCTAssertNil(sut.qrPayload)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(repository.fetchQRCount, 0)
    }

    // MARK: createChild

    // NOTE (P3/endpoint migration): createChild no longer hits the network —
    // children are brought into the account via QR pairing, not an addChild API.
    // createChild now just validates and advances welcome -> addChild.
    func test_createChild_withValidName_advancesStepWithoutNetwork() async {
        let sut = makeSUT()
        sut.childName = "Mika"
        sut.age = "9"
        sut.gender = "f"

        await sut.createChild()

        XCTAssertEqual(repository.addChildCount, 0)   // no network call
        XCTAssertEqual(sut.step, .addChild)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_createChild_withBlankName_validatesAndSkipsRepository() async {
        let sut = makeSUT()
        sut.childName = "   "

        await sut.createChild()

        XCTAssertEqual(repository.addChildCount, 0)
        XCTAssertNotNil(sut.errorMessage)
    }

    // MARK: hasChildren

    func test_hasChildren_isTrue_whenChildIdSet() {
        SelectedChildStore.shared.selectID("42")
        let sut = makeSUT()

        XCTAssertTrue(sut.hasChildren())
    }

    func test_hasChildren_isFalse_whenChildIdNil() {
        SelectedChildStore.shared.selectID(nil)
        let sut = makeSUT()

        XCTAssertFalse(sut.hasChildren())
    }

    // MARK: refreshPairingStatus

    func test_refreshPairingStatus_returnsRepositoryResult() async {
        repository.pairingResult = .success(true)
        let sut = makeSUT()

        let paired = await sut.refreshPairingStatus()

        XCTAssertTrue(paired)
        XCTAssertEqual(repository.pairingCount, 1)
        XCTAssertEqual(repository.lastPairingChildId, "42")
    }
}
