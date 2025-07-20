//
//  PopToastView.swift
//  ProCare
//
//  Created by ahmed hussien on 01/06/2025.
//



import SwiftUI

struct PopToastView: View {
    var toast: ToastData
    var onDismiss: (() -> Void)? = nil
    
    @State private var offset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        VStack {
            if toast.position == .top {
                toastBody
                Spacer()
            } else {
                Spacer()
                toastCenterBody
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring()) {
                offset = 0
            }
        }
    }

    private var toastBody: some View {
        HStack {
            Spacer()
            Text(toast.message)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding()
        .frame(maxWidth: toast.width == .infinity ? nil : toast.width)
        .background(toast.style.themeColor)
        .offset(y: dragOffset)
        .gesture(createDragGesture())
        .transition(.asymmetric(
                   insertion: .move(edge: .top).combined(with: .opacity),
                   removal: .move(edge: .top).combined(with: .opacity)
               ))
    }
    
    
    private func createDragGesture() -> some Gesture {
           DragGesture()
               .onChanged { value in
                   let translation = value.translation.height
                   if toast.position == .top {
                       dragOffset = min(translation, 0)
                   } else {
                       dragOffset = translation
                   }
               }
               .onEnded { value in
                   let threshold: CGFloat = 50
                   let velocity = value.velocity.height
                   
                   if abs(value.translation.height) > threshold || abs(velocity) > 500 {
                       withAnimation(.spring()) {
                           dragOffset = toast.position == .top ? -200 : 200
                       }
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                           onDismiss?()
                       }
                   } else {
                       withAnimation(.spring()) {
                           dragOffset = 0
                       }
                   }
               }
       }
    
    private var toastCenterBody: some View {
        VStack {
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
            
            Text(toast.message)
                .font(.title2)
                .foregroundColor(.appText)
        }
        .frame(maxWidth: 200)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
       // .frame(maxWidth: toast.width)
      //  .background(toast.style.themeColor)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}



//MARK: - ToastStyleEnums
enum ToastStyle {
    case success, error, warning, info

    var themeColor: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
}

enum ToastPosition:  CaseIterable, Equatable {
    case top, center
}


#Preview {
    VStack{
        PopToastView(
            toast: ToastData(
                style: .success,
                message: "sccuess",
                duration: 3,
                width: .infinity,
                position: .top
            )
        )
    }
}
