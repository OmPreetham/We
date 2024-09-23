//
//  VerificationCodeInputCell.swift
//  We
//
//  Created by Om Preetham Bandi on 9/22/24.
//

import SwiftUI

struct VerificationCodeInput: View {
    @Binding var code: String
    let codeLength: Int
    
    @FocusState private var isInputActive: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(0..<codeLength, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                            .frame(width: 50, height: 60)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
                        
                        if index < code.count {
                            Text(String(code[code.index(code.startIndex, offsetBy: index)]))
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .overlay(
                TextField("", text: $code)
                    .keyboardType(.numberPad)
                    .focused($isInputActive)
                    .opacity(0)
                    .onChange(of: code) { oldValue, newValue in
                        if newValue.count > codeLength {
                            code = String(newValue.prefix(codeLength))
                        }
                    }
            )
        }
        .onTapGesture {
            isInputActive = true
        }
    }
}

#Preview {
    VerificationCodeInput(code: .constant("123"), codeLength: 6)
}
