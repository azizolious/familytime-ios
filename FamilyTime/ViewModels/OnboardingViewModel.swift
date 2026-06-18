//
//  OnboardingViewModel.swift
//  FamilyTime
//
//  Drives the SwiftUI Onboarding / Device-Pairing flow (parity sprint).
//
//  Flow: welcome → addChild → platform (device setup) → qr → confirm.
//  A child is typically pre-created, but this flow can also create one
//  (best-effort; see `// TODO confirm`). On success the new/selected child
//  id is written to `SelectedChildStore`, which routes the user to the
//  dashboard via `RootView`.
//
//  QR rendering deliberately avoids UIKit: the view model only exposes the
//  raw `qrPayload` string and a `qrImage()` helper that builds a SwiftUI
//  `Image` through CoreImage + CoreGraphics. See `qrImage(scale:)`.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

@MainActor
@Observable
final class OnboardingViewModel {

    // MARK: Steps

    /// The ordered steps of the onboarding flow.
    enum Step: Int, CaseIterable {
        case welcome
        case addChild
        case platform
        case qr
        case confirm
    }

    /// "ios" | "android" — the target platform for the child's device.
    enum Platform: String, CaseIterable, Identifiable {
        case iOS = "ios"
        case android = "android"

        var id: String { rawValue }
    }

    // MARK: Navigation state

    private(set) var step: Step = .welcome

    // MARK: Editable fields (bound to UI)

    var childName = ""
    var age = ""
    var gender = ""
    var platform: Platform = .iOS

    // MARK: UI state

    private(set) var isLoading = false
    private(set) var errorMessage: String?

    /// Raw QR payload returned by the backend; the view renders it.
    private(set) var qrPayload: String?

    /// The id of the child currently being paired (pre-existing or newly created).
    private(set) var childId: String?

    // MARK: Dependencies

    private let repository: OnboardingRepositoryProtocol
    private let selectedChildStore: SelectedChildStore

    init(
        repository: OnboardingRepositoryProtocol = OnboardingRepository(),
        selectedChildStore: SelectedChildStore = .shared
    ) {
        self.repository = repository
        self.selectedChildStore = selectedChildStore
        // If a child already exists, prefer pairing it directly.
        self.childId = selectedChildStore.selectedChildID
    }

    // MARK: Derived state

    /// `true` when a child is already associated with this account.
    func hasChildren() -> Bool {
        selectedChildStore.selectedChildID != nil
    }

    /// Whether the add-child form has the minimum required input.
    var canSubmitChild: Bool {
        !childName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: Step navigation

    /// Advances to the next step in the flow, clamped to the last step.
    func next() {
        errorMessage = nil
        let allSteps = Step.allCases
        if let index = allSteps.firstIndex(of: step), index + 1 < allSteps.count {
            step = allSteps[index + 1]
        }
    }

    /// Returns to the previous step, clamped to the first step.
    func back() {
        errorMessage = nil
        let allSteps = Step.allCases
        if let index = allSteps.firstIndex(of: step), index > 0 {
            step = allSteps[index - 1]
        }
    }

    // MARK: Actions

    /// Validates the add-child form, then advances to the platform / QR-pairing step.
    ///
    /// Children are no longer created via a dedicated API call: a child is brought
    /// into the account by generating a pairing QR code and having the child's
    /// device scan it, after which the child appears under `/devices`. This step
    /// therefore only collects the form input and moves the flow forward; the
    /// real "creation" happens during QR pairing.
    func createChild() async {
        guard canSubmitChild else {
            errorMessage = String(localized: "onboarding.addChild.validation")
            return
        }
        errorMessage = nil
        // No network call here anymore — proceed to platform/QR pairing.
        next()
    }

    /// Generates the pairing QR payload for the active child.
    func generateQR() async {
        guard let childId, !childId.isEmpty else {
            errorMessage = String(localized: "onboarding.qr.missingChild")
            return
        }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            qrPayload = try await repository.fetchQRCode(childId: childId)
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Polls pairing status once. Returns `true` if the device has paired.
    func refreshPairingStatus() async -> Bool {
        guard let childId, !childId.isEmpty else { return false }
        do {
            return try await repository.checkPairingStatus(childId: childId)
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
            return false
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    /// Finalises onboarding: ensures the child id is selected so `RootView`
    /// routes to the dashboard.
    func finish() {
        if let childId {
            selectedChildStore.selectID(childId)
        }
    }

    // MARK: QR rendering (no UIKit)

    /// Builds a crisp SwiftUI `Image` from `qrPayload` using CoreImage's
    /// `CIQRCodeGenerator` and a CoreGraphics `CGImage`. Returns `nil` when no
    /// payload is available or generation fails (no force-unwraps).
    func qrImage(scale: CGFloat = 10) -> Image? {
        guard let qrPayload, let cgImage = Self.makeQRCGImage(from: qrPayload, scale: scale) else {
            return nil
        }
        return Image(decorative: cgImage, scale: 1.0, orientation: .up)
    }

    /// Generates a scaled `CGImage` QR code without importing UIKit.
    private static func makeQRCGImage(from string: String, scale: CGFloat) -> CGImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        // Medium error correction balances density and resilience.
        filter.correctionLevel = "M"

        guard let output = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let scaled = output.transformed(by: transform)
        return context.createCGImage(scaled, from: scaled.extent)
    }
}
