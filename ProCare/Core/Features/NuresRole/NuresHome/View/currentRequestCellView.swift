//
//  currentRequestCellView.swift
//  ProCare
//
//  Created by ahmed hussien on 20/05/2025.
//
import SwiftUI

struct currentRequestCellView: View {
    
    @ObservedObject var vm: RequestsVM
    @EnvironmentObject var appRouter: AppRouter
    let buttonWidth = UIScreen.main.bounds.width * 0.33
    @State var showRejectAlert: Bool = false
    @State var showApproveAlert: Bool = false
    @State var showFinishAlert: Bool = false
    
    var body: some View {
        ScrollView {
            if let request = vm.currentRequest {
                VStack {
                    
                    patientInfoSection(for: request)
                    
                    actionButtons
                    
                }
                .padding()
                .backgroundCard(cornerRadius: 10, shadowRadius: 1, shadowColor: .gray)
                .padding()
            }
            else {
                AppEmptyView()
            }
        }
        .alert("rejection_request".localized(), isPresented: $showRejectAlert) {
            Button("cancel".localized(), role: .destructive) { }
            Button("yes".localized(), role: .cancel) {
                Task{
                    await vm.rejectRequest(id: vm.currentRequest?.id ?? "")
                }
            }
        } message: {
            Text("are_you_sure_reject".localized())
        }
        .alert("approve_request".localized(), isPresented: $showApproveAlert) {
            Button("cancel".localized(), role: .destructive) { }
            Button("approve".localized(), role: .cancel) {
                Task{
                    await vm.approveRequest(id: vm.currentRequest?.id ?? "")
                }
            }
        } message: {
            Text("are_you_sure_approve".localized())
        }
        .alert("finish_request".localized(), isPresented: $showFinishAlert) {
            Button("cancel".localized(), role: .destructive) { }
            Button("finish".localized(), role: .cancel) {
                appRouter.pushView(ReportScreen(vm: vm))
            }
        } message: {
            Text("are_you_sure_finish".localized())
        }

    }
}

//MARK: views
extension currentRequestCellView{
    @ViewBuilder
    private func patientInfoSection(for request: Request) -> some View {
        HStack(alignment: .top, spacing: 20) {
            AppImage(
                urlString: request.patientPicture,
                width: 80,
                height: 80,
                contentMode: .fill,
                shape: RoundedRectangle(cornerRadius: 10)
            )

            VStack(alignment: .leading, spacing: 10) {
                Text(request.patientName ?? "")
                    .font(.headline)
                    .bold()
                    .foregroundStyle(.black)
                
                Text(request.createdDate ?? "")
                    .font(.callout)
                    .foregroundStyle(.gray)
                
                Text((request.totalPrice ?? 0).asEGPCurrency())
                    .font(.callout)
                    .foregroundStyle(.gray)
                
                Text((request.patientGovernorate ?? "") + " - " + (request.patientCity ?? ""))
                    .font(.callout)
                    .foregroundStyle(.gray)
            }

            Spacer()
        }
    }

    var actionButtons: some View {
        
        if vm.currentRequest?.statusId == .Approved {
            return VStack{
                Button {
                    showFinishAlert.toggle()
                } label: {
                    HStack {
                        Text("finish_request".localized())
                    }//.frame(maxWidth: .infinity)
                }
                .buttonStyle(AppButton(kind: .solid, height: 45, backgroundColor: .green))
            }
           
        }else{
           return HStack(spacing: 8) {
                Button {
                    showApproveAlert.toggle()
                } label: {
                    HStack {
                        Text("accept".localized())
                    }//.frame(width: buttonWidth)
                }
                .buttonStyle(AppButton(kind: .solid, height: 45, backgroundColor: .green))
                
                Button {
                    showRejectAlert.toggle()
                } label: {
                    HStack {
                        Image(systemName: "xmark")
                        Text("reject".localized())
                    }
                   // .frame(width: buttonWidth)
                    //.frame(maxWidth: .infinity)
                }
                .buttonStyle(AppButton(kind: .solid,height: 45, backgroundColor: .red))
            }
        }
        
   
    }
    
}

#Preview {
    VStack{
        let vm = RequestsVM()
        vm.currentRequest = Request.mock
        return currentRequestCellView(vm: vm)
    }
}
