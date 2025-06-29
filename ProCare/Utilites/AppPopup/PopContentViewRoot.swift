    //
    //  PopContentViewRoot.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 01/06/2025.
    //


import SwiftUI
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
            Form {
                Section(header: Text("Alerts")) {
                    Button("Show Global Alert") {
//                        PopupManager.shared.showAlert(title: "Global Alert", message: "This alert can be triggered from anywhere!")
                        showAlert(title: "Global Alert", message: "This alert can be triggered from anywhere!")
                    }
                }
                Section(header: Text("Toasts")) {
                    Button("Show Global Toast") {
                        showToast(
                            "This is a toast!",
                            appearance: .error,
                            position: .top
                        )
                    }
                    Button("Show Toast using PopupManager") {
                        PopupManager.shared
                            .showToast(
                                message: "This is a toast!",
                                style: .success,
                                duration: 3.0,
                                position: .top
                            )
                    }
                }
                Section(header: Text("Popups")) {
                    Button("Show Global Custom Popup") {
                        showPopup {
                            VStack(spacing: 16) {
                                Text("Total requests")
                                    .font(.headline)
                                Text("500")
                                    .font(.title)
                                Button("Dismiss") {
                                    PopupManager.shared.dismissCustomPopup()
                                }
                            }
                            .frame(maxWidth: 200)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                        }
                    }
                    Button("Show Custom Popup using PopupManager") {
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
            }
        }
        .navigationTitle("Popup Demo")
    }
}
