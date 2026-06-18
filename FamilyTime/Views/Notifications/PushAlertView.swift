//
//  PushAlertView.swift
//  FamilyTime
//
//  Phase 2 Notifications — modern SwiftUI push alert presenter.
//  NO UIKit, NO UIAlertController.
//

import SwiftUI

struct PushAlertModifier: ViewModifier {
    @Bindable var center: PushAlertCenter

    func body(content: Content) -> some View {
        content.sheet(item: $center.currentAlert) { alert in
            VStack(spacing: 16) {
                Text(alert.title)
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)

                Text(alert.message)
                    .multilineTextAlignment(.center)

                if let child = alert.childName {
                    Text(child)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                switch alert.type {
                case .pickup:
                    // TODO Phase 2: POST kPickupBack with the chosen response.
                    HStack(spacing: 12) {
                        Button("Coming") {
                            center.dismiss()
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Can't") {
                            center.dismiss()
                        }
                        .buttonStyle(.bordered)
                    }
                case .panic:
                    Button("Acknowledge") {
                        center.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                default:
                    Button("Dismiss") {
                        center.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .presentationDetents([.medium])
        }
    }
}

extension View {
    func pushAlerts(_ center: PushAlertCenter) -> some View {
        modifier(PushAlertModifier(center: center))
    }
}
