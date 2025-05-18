//
//  OrderCellView 2.swift
//  ProCare
//
//  Created by ahmed hussien on 19/05/2025.
//

import SwiftUI

struct currentOrderCellView: View {
    
    @ObservedObject var vm: OrdersVM
    let buttonWidth = UIScreen.main.bounds.width * 0.33
    @State var showCancelAlert: Bool = false
    
    var body: some View {
        ScrollView {
            if let order = vm.currentOrder {
                VStack {
                    nurseInfoSection(for: order)
                    actionButtons
                }
                .padding()
                .backgroundCard(cornerRadius: 10, shadowRadius: 1, shadowColor: .appGray)
                .padding()
            }
            else {
                Text("No requests".localized())
            }
        }
        .alert("Cancel current request", isPresented: $showCancelAlert) {
            Button("Cancel", role: .destructive) { }
            Button("Yes", role: .cancel) {
                Task{
                    await  vm.cancelRequest(id: vm.currentOrder?.id ?? "")
                }
            }
        } message: {
            Text("Are you sure you want to cancel this request?")
        }

    }
}

extension currentOrderCellView{
    @ViewBuilder
    private func nurseInfoSection(for order: Order) -> some View {
        HStack(alignment: .top, spacing: 20) {
            AppImage(
                urlString: order.nursePicture,
                width: 80,
                height: 80,
                contentMode: .fill,
                shape: RoundedRectangle(cornerRadius: 10)
            )

            VStack(alignment: .leading, spacing: 10) {
                Text(order.nurseName ?? "")
                    .font(.headline)
                    .bold()
                    .foregroundStyle(.black)

                Text(order.speciality ?? "")
                    .font(.callout)
                    .foregroundStyle(.black)

                if let minutes = order.estimatedTimeMinutes {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text(String(format: "within_minutes".localized(), minutes))
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
            }

            Spacer()
        }
    }

    var actionButtons: some View {
        HStack(spacing: 8) {
                   Button {
                       if let url = URL(string: "tel://\(vm.currentOrder?.phoneNumber ?? "")"),
                          UIApplication.shared.canOpenURL(url) {
                           UIApplication.shared.open(url)
                       }
                   } label: {
                       HStack {
                           Image(systemName: "phone.fill")
                           Text("call".localized())
                       }.frame(width: buttonWidth)
                   }
                   .buttonStyle(AppButton(kind: .solid, backgroundColor: .green))

                   Button {
                       showCancelAlert.toggle()
                   } label: {
                       HStack {
                           Image(systemName: "xmark")
                           Text("Cancel".localized())
                       }
                       .frame(width: buttonWidth)
                       //.frame(maxWidth: .infinity)
                   }
                   .buttonStyle(AppButton(kind: .solid,backgroundColor: .red))
               }
    }
}

#Preview {
    VStack{
        currentOrderCellView(vm: OrdersVM())
    }
}
