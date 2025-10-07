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
                VStack(spacing: 24) {
                    nurseInfoSection(for: order)
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
            }
            else {
                AppEmptyView(message: "no_orders_available".localized())
            }
        }
//        .onAppear{
//            Task{
//                await vm.fetchCurrentOrder()
//            }
//        }
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
                width: 88,
                height: 88,
                contentMode: .fill,
                shape: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )

            VStack(alignment: .leading, spacing: 8) {
                Text(order.nurseName ?? "")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text(order.speciality ?? "")
                    .font(.callout)
                    .foregroundStyle(.black)

                if let minutes = order.estimatedTimeMinutes {
                    Label {
                        Text(String(format: "within_minutes".localized(), minutes))
                            .foregroundColor(.gray)
                            .font(.caption)
                    } icon: {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Label {
                    Text((order.totalPrice ?? 0).asEGPCurrency())
                        .font(.callout)
                        .foregroundStyle(.gray)
                } icon: {
                    Image(systemName: "banknote")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
             

            Spacer()
        }
    }

    var actionButtons: some View {
        HStack(spacing: 12) {
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

            Button {
                showCancelAlert.toggle()
            } label: {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .font(.callout)
                    Text("cancel".localized())
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

#Preview {
        let vm = OrdersVM()
        vm.currentOrder = Order.mock
        return currentOrderCellView(vm: vm)
}
