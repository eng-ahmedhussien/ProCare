//
//  currentRequestCellView.swift
//  ProCare
//
//  Created by ahmed hussien on 20/05/2025.
//
import SwiftUI

struct CurrentRequestCellView: View {
    
    @ObservedObject var vm: RequestsVM
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var authManager: AuthManager
    
    @State private var showRejectAlert = false
    @State private var showApproveAlert = false
    @State private var showFinishAlert = false
    @State private var showContactOptions = false
    
    var body: some View {
        ScrollView {
            if let request = vm.currentRequest {
                VStack(spacing: 24) {
                    patientInfoSection(for: request)
                    actionButtons
                }
                .padding(20)
                .backgroundCard(
                    cornerRadius: 16,
                    shadowRadius: 8,
                    shadowX: 0,
                    shadowY: 2
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            } else {
                AppEmptyView(message: "no_requests".localized())
            }
        }
        .background(Color(.systemGroupedBackground))
        .onFirstAppear {
            Task {
                await vm.fetchCurrentRequest {
                    authManager.logout()
                }
            }
        }
        .refreshable {
            Task {
                await vm.fetchCurrentRequest()
            }
        }
        .alert("rejection_request".localized(), isPresented: $showRejectAlert) {
            Button("cancel".localized(), role: .cancel) { }
            Button("reject".localized(), role: .destructive) {
                Task {
                    await vm.rejectRequest(id: vm.currentRequest?.id ?? "")
                }
            }
        } message: {
            Text("are_you_sure_reject".localized())
        }
        .alert("approve_request".localized(), isPresented: $showApproveAlert) {
            Button("cancel".localized(), role: .cancel) { }
            Button("approve".localized()) {
                Task {
                    await vm.approveRequest(id: vm.currentRequest?.id ?? "")
                }
            }
        } message: {
            Text("are_you_sure_approve".localized())
        }
        .alert("finish_request".localized(), isPresented: $showFinishAlert) {
            Button("cancel".localized(), role: .cancel) { }
            Button("finish".localized()) {
                appRouter.pushView(ReportScreen(vm: vm))
            }
        } message: {
            Text("are_you_sure_finish".localized())
        }
        .confirmationDialog(
            "contact_options".localized(),
            isPresented: $showContactOptions,
            titleVisibility: .visible
        ) {
            Button("call".localized()) {
                if let url = URL(string: "tel://\(vm.currentRequest?.phoneNumber ?? "")"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            Button("WhatsApp") {
                if let phone = vm.currentRequest?.phoneNumber,
                   let url = URL(string: "https://wa.me/\(phone)") {
                    UIApplication.shared.open(url)
                }
            }
            Button("cancel".localized(), role: .cancel) { }
        }
    }
}

// MARK: - Views
extension CurrentRequestCellView {
    
    @ViewBuilder
    private func patientInfoSection(for request: Request) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Patient Image
            AppImage(
                urlString: request.patientPicture,
                width: 88,
                height: 88,
                contentMode: .fill,
                shape: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
            
            // Patient Info
            VStack(alignment: .leading, spacing: 8) {
                Text(request.patientName ?? "")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                Label {
                    Text(request.createdDate ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } icon: {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Label {
                    Text((request.totalPrice ?? 0).asEGPCurrency())
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                } icon: {
                    Image(systemName: "banknote")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Label {
                    Text("\(request.patientGovernorate ?? "") - \(request.patientCity ?? "")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                } icon: {
                    Image(systemName: "location")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    var actionButtons: some View {
        if vm.currentRequest?.statusId == .Approved {
            // Finish Button (Approved State)
            Button {
                showFinishAlert.toggle()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.body)
                    Text("finish_request".localized())
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.green)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            
            
        } else {
            // Action Buttons (Pending State)
            VStack(spacing: 12) {
                // Primary Action - Accept
                Button {
                    showApproveAlert.toggle()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.body)
                        Text("accept".localized())
                            .fontWeight(.medium)
                    }
                }
                .buttonStyle(
                    AppButton(
                        kind: .solid,
                        height: 45,
                        backgroundColor: .blue
                    )
                )
                
                // Secondary Actions
                HStack(spacing: 12) {
                    // Contact Button
                    Button {
                        showContactOptions = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "phone.fill")
                                .font(.callout)
                            Text("call".localized())
                                .fontWeight(.medium)
                        }
                    }
                    .buttonStyle(
                        AppButton(
                            kind: .solid,
                            height: 45,
                            backgroundColor: .green
                        )
                    )
                    
                    // Reject Button
                    Button {
                        showRejectAlert.toggle()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.callout)
                            Text("reject".localized())
                                .fontWeight(.medium)
                        }
                    }
                    .buttonStyle(
                        AppButton(
                            kind: .solid,
                            height: 45,
                            backgroundColor: .red
                        )
                    )
                }
            }
        }
    }
}


#Preview {
    VStack{
        let vm = RequestsVM()
        vm.currentRequest = Request.mock
        return CurrentRequestCellView(vm: vm)
            .environmentObject(AuthManager())
            .environment(\.locale, .init(identifier: "ar")) // For Arabic text
                       .environment(\.layoutDirection, .rightToLeft)   //
    }
}
