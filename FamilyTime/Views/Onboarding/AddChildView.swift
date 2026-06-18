//
//  AddChildView.swift
//  FamilyTime
//
//  Onboarding step: collect the child's basic profile (name, age, gender)
//  bound to the shared `OnboardingViewModel`, then create the child.
//
//  All copy is localized via `String(localized:)`. No UIKit.
//

import SwiftUI

struct AddChildView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text(String(localized: "onboarding.addChild.title"))
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(String(localized: "onboarding.addChild.subtitle"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Form {
                Section {
                    TextField(
                        String(localized: "onboarding.addChild.namePlaceholder"),
                        text: $viewModel.childName
                    )
                    .textContentType(.givenName)

                    TextField(
                        String(localized: "onboarding.addChild.agePlaceholder"),
                        text: $viewModel.age
                    )
                    .keyboardType(.numberPad)

                    TextField(
                        String(localized: "onboarding.addChild.genderPlaceholder"),
                        text: $viewModel.gender
                    )
                    .textInputAutocapitalization(.words)
                } header: {
                    Text(String(localized: "onboarding.addChild.sectionHeader"))
                }
            }
            .scrollContentBackground(.hidden)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

            Button {
                Task { await viewModel.createChild() }
            } label: {
                Text(String(localized: "onboarding.addChild.continue"))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!viewModel.canSubmitChild || viewModel.isLoading)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
            }
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
        AddChildView(viewModel: OnboardingViewModel())
    }
}
