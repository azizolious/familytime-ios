//
//  PairingConfirmationView.swift
//  FamilyTime
//
//  Final onboarding step: confirm the child's device has paired and proceed to
//  the dashboard. Calling `viewModel.finish()` selects the child id in
//  `SelectedChildStore`, which causes `RootView` to route to `AppNavigationView`.
//
//  Pairing status is polled best-effort (`// TODO confirm`). The user can also
//  proceed manually. All copy is localized via `String(localized:)`. No UIKit.
//

import SwiftUI

struct PairingConfirmationView: View {
    @Bindable var viewModel: OnboardingViewModel

    @State private var isPaired = false
    @State private var isChecking = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: isPaired ? "checkmark.circle.fill" : "hourglass.circle")
                .font(.system(size: 80))
                .foregroundStyle(isPaired ? .green : .secondary)

            Text(
                isPaired
                    ? String(localized: "onboarding.confirm.successTitle")
                    : String(localized: "onboarding.confirm.pendingTitle")
            )
            .font(.title2.bold())
            .multilineTextAlignment(.center)

            Text(
                isPaired
                    ? String(localized: "onboarding.confirm.successSubtitle")
                    : String(localized: "onboarding.confirm.pendingSubtitle")
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)

            if !isPaired {
                Button {
                    Task { await checkStatus() }
                } label: {
                    if isChecking {
                        ProgressView()
                    } else {
                        Text(String(localized: "onboarding.confirm.checkStatus"))
                    }
                }
                .buttonStyle(.bordered)
                .disabled(isChecking)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            Button {
                viewModel.finish()
            } label: {
                Text(String(localized: "onboarding.confirm.goToDashboard"))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(String(localized: "onboarding.common.back")) {
                    viewModel.back()
                }
            }
        }
        .task {
            await checkStatus()
        }
    }

    private func checkStatus() async {
        isChecking = true
        defer { isChecking = false }
        isPaired = await viewModel.refreshPairingStatus()
    }
}

#Preview {
    NavigationStack {
        PairingConfirmationView(viewModel: OnboardingViewModel())
    }
}
