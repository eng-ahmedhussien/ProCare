//
//  currentRequestCellView.swift
//  ProCare
//
//  Created by ahmed hussien on 20/05/2025.
//
import SwiftUI

struct currentRequestCellView: View {
    
    @ObservedObject var vm: RequestsVM
    let buttonWidth = UIScreen.main.bounds.width * 0.33
    @State var showRejectAlert: Bool = false
    @State var showApproveAlert: Bool = false
    @State var isApproveRequest: Bool = false
    
    var body: some View {
        ScrollView {
            if let request = vm.currentRequest {
                VStack {
                    
                    patientInfoSection(for: request)
                    
                    actionButtons
                    
                }
                .padding()
                .backgroundCard(cornerRadius: 10, shadowRadius: 1, shadowColor: .appGray)
                .padding()
            }
            else {
                AppEmptyView()
            }
        }
        .alert("Rejection request", isPresented: $showRejectAlert) {
            Button("Cancel", role: .destructive) { }
            Button("Reject", role: .cancel) {
                Task{
                    await vm.rejectRequest(id: vm.currentRequest?.id ?? "")
                }
            }
        } message: {
            Text("Are you sure you want to reject this request?")
        }
        .alert("Accept request", isPresented: $showApproveAlert) {
            Button("Cancel", role: .destructive) { }
            Button("Accept", role: .cancel) {
                Task{
                    isApproveRequest.toggle()
                }
            }
        } message: {
            Text("Are you sure you want to Accept this request?")
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
                    .foregroundStyle(.appGray)
                
                Text((request.patientGovernorate ?? "") + " - " + (request.patientCity ?? ""))
                    .font(.callout)
                    .foregroundStyle(.appGray)
            }

            Spacer()
        }
    }

    var actionButtons: some View {
        
        if isApproveRequest{
           
            return VStack{
                SwipeToFinishButton{
                    
                 }
            }
           
        }else{
           return HStack(spacing: 8) {
                Button {
                    showApproveAlert.toggle()
                } label: {
                    HStack {
                        Text("accept".localized())
                    }.frame(width: buttonWidth)
                }
                .buttonStyle(AppButton(kind: .solid, backgroundColor: .green))
                
                Button {
                    showRejectAlert.toggle()
                } label: {
                    HStack {
                        Image(systemName: "xmark")
                        Text("reject".localized())
                    }
                    .frame(width: buttonWidth)
                    //.frame(maxWidth: .infinity)
                }
                .buttonStyle(AppButton(kind: .solid,backgroundColor: .red))
            }
        }
        
   
    }
    
}

#Preview {
    VStack{
        var vm = RequestsVM()
        vm.currentRequest = Request.mock
        return currentRequestCellView(vm: vm)
    }
}


