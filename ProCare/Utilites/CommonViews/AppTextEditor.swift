//
//  PlaceholderTextEditor.swift
//  ProCare
//
//  Created by ahmed hussien on 12/06/2025.
//


import SwiftUI

struct PlaceholderTextEditor: View {
    @Binding var text: String
    var placeholder: String
    var height: CGFloat = 120
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .focused($isFocused)
                .frame(height: height)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(8)
            }
        }
        .frame(height: height)
    }
}