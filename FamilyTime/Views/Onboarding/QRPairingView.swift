//
//  QRPairingView.swift
//  FamilyTime
//
//  Onboarding step: render the pairing QR code so the child's device can scan
//  it, plus a link to the install guide. The QR is rendered from
//  `viewModel.qrPayload` via CoreImage's `CIQRCodeGenerator` → `CGImage` →
//  SwiftUI `Image` — NO UIKit is imported.
//
//  All copy is localized via `String(localized:)`.
//

import SwiftUI

struct QRPairingView: View {
    @Bindable var viewModel: OnboardingViewModel

    /// Install-guide URL. core.familytime.io only.
    private let installGuideURL = URL(string: "https://core.familytime.io/install")

    var body: some View {
        VStack(spacing: 20) {
            Text(String(localized: "onboarding.qr.title"))
                .font(.title2.bold())

            Text(String(localized: "onboarding.qr.instruction"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            qrContent

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            if let installGuideURL {
                Link(destination: installGuideURL) {
                    Text(String(localized: "onboarding.qr.installGuide"))
                }
                .font(.callout)
            }

            Spacer()

            Button {
                viewModel.next()
            } label: {
                Text(String(localized: "onboarding.qr.continue"))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewModel.qrPayload == nil)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(String(localized: "onboarding.common.back")) {
                    viewModel.back()
                }
            }
        }
        .task {
            // Generate the QR when the step appears, if not already loaded.
            if viewModel.qrPayload == nil {
                await viewModel.generateQR()
            }
        }
    }

    // MARK: QR content

    @ViewBuilder
    private var qrContent: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(width: 220, height: 220)
        } else if let qrImage = viewModel.qrImage() {
            qrImage
                .interpolation(.none) // keep QR modules crisp
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
                .accessibilityLabel(Text(String(localized: "onboarding.qr.accessibilityLabel")))
        } else {
            VStack(spacing: 12) {
                Image(systemName: "qrcode")
                    .font(.system(size: 64))
                    .foregroundStyle(.secondary)
                Button(String(localized: "onboarding.qr.retry")) {
                    Task { await viewModel.generateQR() }
                }
            }
            .frame(width: 220, height: 220)
        }
    }
}

#Preview {
    NavigationStack {
        QRPairingView(viewModel: OnboardingViewModel())
    }
}
