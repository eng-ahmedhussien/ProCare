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
//                            VStack(spacing: 16) {
//                                Text("Total requests")
//                                    .font(.headline)
//                                Text("500")
//                                    .font(.title)
//                                Button("Dismiss") {
//                                    PopupManager.shared.dismissCustomPopup()
//                                }
//                            }
//                            .frame(maxWidth: 200)
//                            .padding()
//                            .background(.ultraThinMaterial)
//                            .cornerRadius(20)
//                            VStack(spacing: 16) {
//                                Text("forced_update")
//                                    .font(.title)
//                                
//                                Text("يجب عليك تحديث التطبيق لمواصلة الاستخدام.")
//                                    .font(.subheadline)
//                                Button("update") {
//                                    if let url = URL(string: "https://apps.apple.com/app/6748255985") {
//                                        UIApplication.shared.open(url)
//                                    }
//                                }.buttonStyle(AppButton())
//                            }
//                            .frame(maxWidth: 250,maxHeight: 250)
//                            .padding()
//                            .background(.ultraThinMaterial)
//                            .cornerRadius(20)
                            
                            VStack(spacing: 20) {
                                // Icon
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundStyle(Color.appPrimary)
                                
                                VStack(spacing: 12) {
                                    // Title - More descriptive and user-friendly
                                    Text("update_required")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                    
                                    // Description - Clear explanation in Arabic
                                    Text("يتوفر إصدار جديد من التطبيق. يرجى التحديث للاستمرار في الاستخدام والحصول على أحدث الميزات.")
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                                // Single primary action button for force update
                                Button {
                                    if let url = URL(string: "https://apps.apple.com/app/6748255985") {
                                        UIApplication.shared.open(url)
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "arrow.down.circle.fill")
                                        Text("update_now")
                                            .fontWeight(.medium)
                                    }
                                }.buttonStyle(AppButton())
                            }
                            .padding(24)
                            .frame(maxWidth: 320) // Better constraint for readability
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.regularMaterial)
                                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.quaternary, lineWidth: 0.5)
                            }
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
