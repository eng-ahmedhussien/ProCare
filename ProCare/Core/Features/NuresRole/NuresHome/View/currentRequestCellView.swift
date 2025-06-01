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
        .alert("Rejection request", isPresented: $showRejectAlert) {
            Button("Cancel", role: .destructive) { }
            Button("Yes", role: .cancel) {
                Task{
                    await vm.rejectRequest(id: vm.currentRequest?.id ?? "")
                }
            }
        } message: {
            Text("Are you sure you want to reject this request?")
        }
        .alert("approve request", isPresented: $showApproveAlert) {
            Button("Cancel", role: .destructive) { }
            Button("approve", role: .cancel) {
                Task{
                    await vm.approveRequest(id: vm.currentRequest?.id ?? "")
                }
            }
        } message: {
            Text("Are you sure you want to approve this request?")
        }
        .alert("Finish request", isPresented: $showFinishAlert) {
            Button("Cancel", role: .destructive) { }
            Button("Finish", role: .cancel) {
                appRouter.pushView(ReportScreen(vm: vm))
            }
        } message: {
            Text("Are you sure you want to Finish this request?")
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
                        Text("Finish Request".localized())
                    }//.frame(maxWidth: .infinity)
                }
                .buttonStyle(AppButton(kind: .solid, backgroundColor: .green))
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
                .buttonStyle(AppButton(kind: .solid, backgroundColor: .green))
                
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
                .buttonStyle(AppButton(kind: .solid,backgroundColor: .red))
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
