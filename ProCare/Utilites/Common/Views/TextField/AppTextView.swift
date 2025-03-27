//
//  LabelTextView.swift
//  AppTest
//
//  Created by ahmed hussien on 29/04/2024.
//

import SwiftUI

struct AppTextView: View {
    var label: String
    var placeHolder: String
    @State var text: String = ""
    var body: some View {
        
        VStack{
            TextField("phone number", text: $text, axis: .vertical)
                .mainTextFieldStyle()
            
            PasswordTextField(password: $text)
        }
        
    }
}

#Preview{
    AppTextView(label: "asd", placeHolder: "place", text: "")
}

struct MainTextFieldStyle : TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .padding(.horizontal, 24)
            .background(Color.white) // Add a background color
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding()
    }
}
struct LeadingTextFieldView <ContentLeading: View>:TextFieldStyle {
    let leadingView: ContentLeading
    
    init(@ViewBuilder leadingView: () -> ContentLeading = { EmptyView() }){
        self.leadingView = leadingView()
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            leadingView
            configuration
        }
        
    }
}
struct TrailingTextFieldView <ContentTrailing: View>: TextFieldStyle {
    let trailingView: ContentTrailing
    
    init(@ViewBuilder trailingView: () -> ContentTrailing = {
            EmptyView() }
    ){
        self.trailingView = trailingView()
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            configuration
            trailingView
        }
    }
}

/// we make this extension to make easy use like " .mainTextFieldStyle "
extension View {
    func mainTextFieldStyle() -> some View {
        textFieldStyle(MainTextFieldStyle())
    }
    
    func leadingView<Leading: View>(
        @ViewBuilder leadingView: @escaping () -> Leading = { EmptyView() }
    ) -> some View {
        self.textFieldStyle(LeadingTextFieldView(leadingView: leadingView))
    }
    
    func trailingView<Trailing: View>(
        @ViewBuilder trailingView: @escaping () -> Trailing = { EmptyView() }
    ) -> some View {
        self.textFieldStyle(TrailingTextFieldView(trailingView: trailingView))
    }
}
