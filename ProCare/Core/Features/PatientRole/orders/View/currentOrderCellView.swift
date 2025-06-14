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
                .backgroundCard(cornerRadius: 10, shadowRadius: 1, shadowColor: .gray)
                .padding()
            }
            else {
                Text("no_requests".localized())
            }
        }
        .alert("cancel_current_request".localized(), isPresented: $showCancelAlert) {
            Button("cancel".localized(), role: .destructive) { }
            Button("yes".localized(), role: .cancel) {
                Task{
                    await  vm.cancelOrder(id: vm.currentOrder?.id ?? "")
                }
            }
        } message: {
            Text("cancel_request_confirmation".localized())
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
            
                Text((order.totalPrice ?? 0).asEGPCurrency())
                    .font(.callout)
                    .foregroundStyle(.gray)
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
                    Text("cancel".localized())
                }
                .frame(width: buttonWidth)
            }
            .buttonStyle(AppButton(kind: .solid,backgroundColor: .red))
        }
    }
}

#Preview {
        var vm = OrdersVM()
        vm.currentOrder = Order.mock
        return currentOrderCellView(vm: vm)
}
