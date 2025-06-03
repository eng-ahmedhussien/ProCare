
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
            if toast.position == .bottom {
                toastBody
            }
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
    case top, bottom
}


#Preview {
    VStack{
        PopToastView(toast: ToastData(style: .success, message: "sccuess", duration: 3, width: .infinity, position: .top))
    }
}
