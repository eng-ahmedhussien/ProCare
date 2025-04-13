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
    
    var textPrompt: String {
        if text.isEmpty || isTextValid() {
            return ""
        } else {
            return "Must be 8–15 characters, include 1 number and 1 uppercase letter"
        }
    }
    
    func isTextValid() -> Bool {
        // criteria in regex.  See http://regexlib.com
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$")
        return passwordTest.evaluate(with: text)
    }
    
    var body: some View {
        
        VStack{
            TextField("phone number", text: $text, axis: .vertical)
                .mainTextFieldStyle(errorMessage: textPrompt)
            
            PasswordTextField(password: $text)
                .mainTextFieldStyle(errorMessage: textPrompt)
        }
        
    }
}

#Preview{
    AppTextView(label: "asd", placeHolder: "place", text: "")
}

//struct MainTextFieldStyle : TextFieldStyle {
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        configuration
//            .frame(maxWidth: .infinity)
//            .padding(.vertical)
//            .padding(.horizontal, 24)
//            .background(.white) // Add a background color
//            .overlay(
//                RoundedRectangle(cornerRadius: 5)
//                    .stroke(Color.gray, lineWidth: 1)
//            )
//            .padding()
//    }
//}
//struct LeadingTextFieldView <ContentLeading: View>:TextFieldStyle {
//    let leadingView: ContentLeading
//    
//    init(@ViewBuilder leadingView: () -> ContentLeading = { EmptyView() }){
//        self.leadingView = leadingView()
//    }
//    
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        HStack {
//            leadingView
//            configuration
//        }
//        
//    }
//}
//struct TrailingTextFieldView <ContentTrailing: View>: TextFieldStyle {
//    let trailingView: ContentTrailing
//    
//    init(@ViewBuilder trailingView: () -> ContentTrailing = {
//            EmptyView() }
//    ){
//        self.trailingView = trailingView()
//    }
//    
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        HStack {
//            configuration
//            trailingView
//        }
//    }
//}
//
///// we make this extension to make easy use like " .mainTextFieldStyle "
//extension View {
//    func mainTextFieldStyle() -> some View {
//        textFieldStyle(MainTextFieldStyle())
//    }
//    
//    func leadingView<Leading: View>(
//        @ViewBuilder leadingView: @escaping () -> Leading = { EmptyView() }
//    ) -> some View {
//        self.textFieldStyle(LeadingTextFieldView(leadingView: leadingView))
//    }
//    
//    func trailingView<Trailing: View>(
//        @ViewBuilder trailingView: @escaping () -> Trailing = { EmptyView() }
//    ) -> some View {
//        self.textFieldStyle(TrailingTextFieldView(trailingView: trailingView))
//    }
//}


struct MainTextFieldStyle : ViewModifier {
    var showError: Bool = true
    var errorMessage: String? = nil
    
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing:10) {
            content
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .padding(.horizontal, 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke( errorMessage == "" ? .gray : .red, lineWidth: 1)
                )
            
                Text(errorMessage ?? "")
                    .foregroundColor(.red)
                    .font(.caption)
        }
            
    }
}
extension View {
    func mainTextFieldStyle(errorMessage: String) -> some View {
        self
            .modifier(MainTextFieldStyle(errorMessage: errorMessage))
    }
}
