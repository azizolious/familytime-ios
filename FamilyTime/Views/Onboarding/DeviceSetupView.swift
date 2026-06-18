//
//  DeviceSetupView.swift
//  FamilyTime
//
//  Onboarding step: pick the child's device platform (iOS / Android) before
//  generating the pairing QR. Bound to the shared `OnboardingViewModel`.
//
//  All copy is localized via `String(localized:)`. No UIKit.
//

import SwiftUI

struct DeviceSetupView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text(String(localized: "onboarding.deviceSetup.title"))
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(String(localized: "onboarding.deviceSetup.subtitle"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Picker(
                String(localized: "onboarding.deviceSetup.platformLabel"),
                selection: $viewModel.platform
            ) {
                Text(String(localized: "onboarding.deviceSetup.platform.ios"))
                    .tag(OnboardingViewModel.Platform.iOS)
                Text(String(localized: "onboarding.deviceSetup.platform.android"))
                    .tag(OnboardingViewModel.Platform.android)
            }
            .pickerStyle(.segmented)

            Spacer()

            Button {
                viewModel.next()
            } label: {
                Text(String(localized: "onboarding.deviceSetup.continue"))
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
    }
}

#Preview {
    NavigationStack {
        DeviceSetupView(viewModel: OnboardingViewModel())
    }
}
