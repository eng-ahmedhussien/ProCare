import SwiftUI

struct PopContentViewRoot: View {
    var body: some View {
        NavigationView {
            PopContentView()
                .popupHost()
                .navigationTitle("Popup Demo")
        }
        
    }
}

#Preview {
    PopContentViewRoot()
}

struct PopContentView: View {
    var body: some View {
        VStack(spacing: 30) {
            Button("Show Global Alert") {
                PopupManager.shared.showAlert(title: "Global Alert", message: "This alert can be triggered from anywhere!")
            }
            Button("Show Global Toast") {
                PopupManager.shared.showToast(message: "This is a toast!", style: .success, duration: 3.0)
            }
            Button("Show Custom Popup") {
                PopupManager.shared.showCustomPopup {
                    VStack(spacing: 16) {
                        Text("Custom Popup")
                            .font(.headline)
                        Text("You can put any SwiftUI view here!")
                        Button("Dismiss") {
                            PopupManager.shared.dismissCustomPopup()
                        }
                    }
                    .frame(maxWidth: 300)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
            }
        }
        .navigationTitle("Popup Demo")
    }
}
