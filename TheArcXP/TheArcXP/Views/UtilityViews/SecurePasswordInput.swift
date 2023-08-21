//
//  SecurePasswordInput.swift
//  the-arcxp-iOS
//
//  Created by Cassandra Balbuena on 3/10/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct SecureInput: View {
    let placeholder: String
    @State private var showText: Bool = false
    @Binding var text: String
    var onCommit: (() -> Void)?
    
    var body: some View {
        
        HStack {
            ZStack {
                SecureField(placeholder, text: $text, onCommit: {
                    onCommit?()
                })
                .opacity(showText ? 0 : 1)
                
                if showText {
                    HStack {
                        TextField(placeholder, text: $text)
                            .lineLimit(1)
                        Spacer()
                    }
                }
            }
            
            Button(action: {
                showText.toggle()
            }, label: {
                Image(systemName: showText ? "eye.slash.fill" : "eye.fill")
            })
            .accentColor(.secondary)
        }
    }
}
