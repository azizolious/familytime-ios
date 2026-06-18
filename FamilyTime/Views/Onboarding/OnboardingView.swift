//
//  OnboardingView.swift
//  FamilyTime
//
//  Step container for the SwiftUI Onboarding / Device-Pairing flow.
//  Owns the single source-of-truth view model and routes between steps:
//  welcome → AddChild → DeviceSetup → QRPairing → PairingConfirmation.
//
//  All user-facing copy is localized via `String(localized:)` keys under the
//  `onboarding.*` namespace (Agent C adds them to Base). No UIKit.
//

import SwiftUI

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.step {
                case .welcome:
                    welcomeStep
                case .addChild:
                    AddChildView(viewModel: viewModel)
                case .platform:
                    DeviceSetupView(viewModel: viewModel)
                case .qr:
                    QRPairingView(viewModel: viewModel)
                case .confirm:
                    PairingConfirmationView(viewModel: viewModel)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: Welcome step

    private var welcomeStep: some View {
        VStack(spacing: 24) {
            Spacer()

            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 96)

            Text(String(localized: "onboarding.welcome.title"))
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text(String(localized: "onboarding.welcome.subtitle"))
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            Button {
                // If a child already exists, skip creation and go straight to setup.
                if viewModel.hasChildren() {
                    viewModel.next() // → addChild
                    viewModel.next() // → platform
                } else {
                    viewModel.next() // → addChild
                }
            } label: {
                Text(String(localized: "onboarding.welcome.getStarted"))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
}

#Preview {
    OnboardingView()
}
