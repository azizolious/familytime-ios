//
//  CancelSubscriptionView.swift
//  FamilyTime
//
//  Created by Ahmad on 04/06/2026.
//  Copyright © 2026 YumyApps. All rights reserved.
//

import SwiftUI

struct CancellationReason: Identifiable, Equatable {
    
    let id = UUID()
    
    let title: String
    
    let description: String
    
    let icon: String
}

struct CancelSubscriptionView: View {
    
    let selectedIndex: Int?

    let onBack: () -> Void
    
    let onSelectReason: (Int) -> Void
    
    let onContinue: (CancellationReason) -> Void
        
    private let reasons: [CancellationReason] = [
        
        .init(
            title: "Too expensive",
            description: "The subscription no longer fits my budget.",
            icon: "expensiveIcon"
        ),
        
            .init(
                title: "Something isn't working",
                description: "I'm experiencing technical issues or bugs.",
                icon: "notWorkingIcon"
            ),
        
            .init(
                title: "My child is older now",
                description: "I no longer need parental controls.",
                icon: "childOlderIcon"
            ),
        
            .init(
                title: "Other reason",
                description: "Tell us why you're leaving.",
                icon: "otherReasonIcon"
            )
    ]
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // HEADER
            
            VStack(spacing: 12) {
                
                headerView
                
                Divider()
            }
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("We're sorry to see you go")
                            .font(.SemiboldFont(size: 20))
                        
                        Text("Before you cancel, let us know what's not working. We may be able to help.")
                            .font(.RegularFont(size: 14))
                            .foregroundStyle(Color(hex: "#666666"))
                    }
                    
                    VStack(alignment: .leading,spacing: 16) {
                        
                        Text("Why are you cancelling?")
                            .font(.SemiboldFont(size: 18))
                                                
                        ForEach(Array(reasons.enumerated()), id: \.offset) { index, reason in
                            
                            reasonCard(
                                reason,
                                index: index
                            )
                        }
                    }
                }
                .padding(16)
            }
            
            VStack(spacing: 12) {
                
                Divider()
                
                Button {
                    
                    guard let selectedIndex else {
                        return
                    }
                    
                    onContinue(
                        reasons[selectedIndex]
                    )
                    
                } label: {
                    
                    Text("Continue")
                        .font(
                            .RegularFont(size: 16)
                        )
                        .foregroundStyle(.white)
                        .frame(
                            maxWidth: .infinity
                        )
                        .padding()
                        .background(
                            selectedIndex == nil
                            ? Color.gray.opacity(0.5)
                            : Color.accentColor
                        )
                        .cornerRadius(16)
                }
                .disabled(
                    selectedIndex == nil
                )
                .padding(.horizontal)
            }
            .background(.white)
        }
        .background(Color(hex: "#F8F8F8"))
        .navigationBarBackButtonHidden()
    }
}

extension CancelSubscriptionView {
    
    var headerView: some View {
        
        HStack {
            
            Button {
                
                onBack()
                
            } label: {
                
                Image(systemName: "arrow.left")
                    .font(.RegularFont(size: 16))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Cancel Subscription")
                .font(.SemiboldFont(size: 18))
            
            Spacer()
            
            Image(systemName: "")
                .font(.RegularFont(size: 16))
                .foregroundColor(.black)
            
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
}

extension CancelSubscriptionView {
    
    @ViewBuilder
    private func reasonCard(_ reason: CancellationReason, index: Int) -> some View {
        
        Button {
            print("selected index: ", index)
            onSelectReason(index)
            
        } label: {
            
            HStack(alignment: .center, spacing: 16) {
                
                Image(reason.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(reason.title)
                        .font(.RegularFont(size: 16))
                        .foregroundColor(.black)
                    
                    Text(reason.description)
                    .font(.RegularFont(size: 14))
                    .foregroundColor(Color(hex: "#888888"))
                    .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding(16)
            .background(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selectedIndex == index ? Color.accentColor.opacity(0.6) : Color.clear, lineWidth: 2)
            }
            .cornerRadius(16)
        }
    }
}

#Preview {
    CancelSubscriptionView(selectedIndex: 1, onBack: {}, onSelectReason: {_ in }, onContinue: {_ in })
}
