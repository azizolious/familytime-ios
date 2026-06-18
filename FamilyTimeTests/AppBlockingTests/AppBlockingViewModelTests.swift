//
//  AppBlockingViewModelTests.swift
//  FamilyTimeTests
//
//  Unit tests for `AppBlockingViewModel` (parity sprint). Drives the shared
//  `SelectedChildStore` (seeded in setUp, reset in tearDown) and injects a
//  `MockAppBlockingRepository`. async/await XCTest, @MainActor, no UIKit,
//  no force-unwraps.
//
//  NOTE: the FamilyTimeTests target is not yet wired into the build; these
//  tests are written to compile and run once it is.
//

import XCTest
@testable import FamilyTime

@MainActor
final class AppBlockingViewModelTests: XCTestCase {

    private var repository: MockAppBlockingRepository!

    override func setUp() {
        super.setUp()
        repository = MockAppBlockingRepository()
        SelectedChildStore.shared.selectID("42")
    }

    override func tearDown() {
        SelectedChildStore.shared.selectID(nil)
        repository = nil
        super.tearDown()
    }

    private func makeSUT() -> AppBlockingViewModel {
        AppBlockingViewModel(
            repository: repository,
            selectedChild: SelectedChildStore.shared
        )
    }

    /// Builds a `BlockableApp` fixture via the model's memberwise init.
    private func makeApp(
        id: String,
        name: String? = "App",
        package: String? = "com.example.app",
        category: String? = "app",
        blocked: Bool = false
    ) -> BlockableApp {
        BlockableApp(
            id: id,
            appName: name,
            appPackageName: package,
            appCategory: category,
            isBlacklisted: blocked
        )
    }

    // MARK: load

    func test_load_onSuccess_populatesApps() async {
        let fixtures = [
            makeApp(id: "1", name: "Alpha"),
            makeApp(id: "2", name: "Beta"),
            makeApp(id: "3", name: "Gamma")
        ]
        repository.appsResult = .success(fixtures)
        let sut = makeSUT()

        await sut.load()

        XCTAssertEqual(sut.apps.count, 3)
        XCTAssertEqual(repository.fetchAppsCount, 1)
        XCTAssertEqual(repository.lastFetchAppsChildId, "42")
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_load_onFailure_setsErrorMessage() async {
        repository.appsResult = .failure(NetworkError.authenticationRequired)
        let sut = makeSUT()

        await sut.load()

        XCTAssertTrue(sut.apps.isEmpty)
        XCTAssertEqual(
            sut.errorMessage,
            NetworkError.authenticationRequired.errorDescription
        )
        XCTAssertFalse(sut.isLoading)
    }

    func test_load_withNoChild_setsErrorAndSkipsRepository() async {
        SelectedChildStore.shared.selectID(nil)
        let sut = makeSUT()

        await sut.load()

        XCTAssertTrue(sut.apps.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(repository.fetchAppsCount, 0)
    }

    // MARK: toggleBlock

    func test_toggleBlock_callsRepositoryWithToggledFlag() async {
        let app = makeApp(id: "7", blocked: false)
        repository.appsResult = .success([app])
        let sut = makeSUT()
        await sut.load()

        // Toggling an unblocked app should request blocked == true.
        await sut.toggleBlock(app)

        XCTAssertEqual(repository.setBlockedCount, 1)
        XCTAssertEqual(repository.lastSetBlockedAppId, "7")
        XCTAssertEqual(repository.lastSetBlockedChildId, "42")
        XCTAssertEqual(repository.lastSetBlockedFlag, true)
        // Optimistic update sticks on success.
        XCTAssertEqual(sut.apps.first?.isBlacklisted, true)
        XCTAssertNil(sut.errorMessage)
    }

    func test_toggleBlock_onFailure_rollsBackAndSetsError() async {
        let app = makeApp(id: "7", blocked: false)
        repository.appsResult = .success([app])
        repository.setBlockedResult = .failure(NetworkError.authenticationRequired)
        let sut = makeSUT()
        await sut.load()

        await sut.toggleBlock(app)

        XCTAssertEqual(repository.setBlockedCount, 1)
        XCTAssertEqual(repository.lastSetBlockedFlag, true)
        // Rolled back to the original value.
        XCTAssertEqual(sut.apps.first?.isBlacklisted, false)
        XCTAssertEqual(
            sut.errorMessage,
            NetworkError.authenticationRequired.errorDescription
        )
    }

    func test_toggleBlock_withNoChild_setsErrorAndSkipsRepository() async {
        let app = makeApp(id: "7", blocked: false)
        SelectedChildStore.shared.selectID(nil)
        let sut = makeSUT()

        await sut.toggleBlock(app)

        XCTAssertEqual(repository.setBlockedCount, 0)
        XCTAssertNotNil(sut.errorMessage)
    }
}
