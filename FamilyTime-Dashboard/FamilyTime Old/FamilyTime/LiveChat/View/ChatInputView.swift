//
//  ChatInputView.swift
//  FamilyTime
//
//  Created by Ahmad on 19/05/2026.
//  Copyright © 2026 YumyApps. All rights reserved.
//

import SwiftUI

struct ChatInputView: View {
    
    @Binding var text: String
    
    let onSend: () -> Void
    
    var body: some View {
        
        HStack(spacing: 12) {
            
            TextField(
                "Say something..",
                text: $text
            )
            .font(.RegularFont(size: 15))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(hex: "#F3F8FF"))
            .cornerRadius(25)
            
            Button {
                
                onSend()
                
            } label: {
                
                Image("sendIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
            }
        }
        .padding(.horizontal, 16)
        .background(Color.white)
    }
}
