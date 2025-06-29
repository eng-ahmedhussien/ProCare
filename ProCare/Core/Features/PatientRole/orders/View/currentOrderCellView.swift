//
//  OrderCellView 2.swift
//  ProCare
//
//  Created by ahmed hussien on 19/05/2025.
//

import SwiftUI

struct currentOrderCellView: View {
    
    @ObservedObject var vm: OrdersVM
    let buttonWidth = UIScreen.main.bounds.width * 0.1
    @State var showCancelAlert: Bool = false
    @State private var showContactOptions = false
    
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
                AppEmptyView(message: "no_orders_available".localized())
            }
        }
        .onAppear{
            Task{
                await vm.fetchCurrentOrder()
            }
        }
        .refreshable {
            Task {
                await vm.fetchCurrentOrder()
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
        .confirmationDialog(
            "contact_options".localized(),
            isPresented: $showContactOptions,
            titleVisibility: .visible
        ) {
            Button("call".localized()) {
                if let url = URL(string: "tel://\(vm.currentOrder?.phoneNumber ?? "")"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            Button("WhatsApp".localized()) {
                if let phone = vm.currentOrder?.phoneNumber,
                   let url = URL(string: "https://wa.me/\(phone)") {
                    UIApplication.shared.open(url)
                }
            }
            Button("cancel".localized(), role: .cancel) { }
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
        HStack(spacing: 0) {
            Button {
                showContactOptions = true
            } label: {
                HStack {
                    Image(systemName: "phone.fill")
                    Text("call".localized())
                }
            }
            .buttonStyle(AppButton(kind: .solid,width: buttonWidth,height: 45, backgroundColor: .green))

            Button {
                showCancelAlert.toggle()
            } label: {
                HStack {
                    Image(systemName: "xmark")
                    Text("cancel".localized())
                }
            }
            .buttonStyle(AppButton(kind: .solid,width: buttonWidth, height: 45,backgroundColor: .red))
        }
    }
}

#Preview {
        var vm = OrdersVM()
        vm.currentOrder = Order.mock
        return currentOrderCellView(vm: vm)
}
