//
//  TextEditorView.swift
//  ProCare
//
//  Created by ahmed hussien on 05/05/2025.
//

import SwiftUI


struct TextEditorView: View {
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .padding(4)
                .background(Color.white)
                .cornerRadius(8)
            
            if text.isEmpty {
                Text("Street Name Building Number Floor Apartment/Unit")
                    .foregroundColor(.gray)
                    .padding(8)
            }
        }
        .frame(height: 120)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        .padding()
    }
}
