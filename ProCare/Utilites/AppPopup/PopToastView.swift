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

    var body: some View {
        VStack {
            if toast.position == .top {
                toastBody
            }
            Spacer()
            if toast.position == .center {
                toastCenterBody
            }
            Spacer()
        }
    }

    private var toastBody: some View {
        HStack {
            Spacer()
            Text(toast.message)
                .font(.body)
                .foregroundColor(.white)
                .padding(.vertical)
            Spacer()
        }
        .frame(maxWidth: toast.width)
        .background(toast.style.themeColor)
        .offset(y: offset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Allow upward or downward drag depending on position
                    if toast.position == .top {
                        offset = min(value.translation.height, 0)
                    } else {
                        offset = max(value.translation.height, 0)
                    }
                }
                .onEnded { value in
                    let threshold: CGFloat = 50
                    if abs(value.translation.height) > threshold {
                        withAnimation {
                            onDismiss?()
                        }
                    } else {
                        // Snap back
                        withAnimation {
                            offset = 0
                        }
                    }
                }
        )
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(100)
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
        //.zIndex(100)
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

enum ToastPosition {
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
                position: .center
            )
        )
    }
}
