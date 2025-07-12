//
//  OrderCellView.swift
//  ProCare
//
//  Created by ahmed hussien on 17/05/2025.
//
import SwiftUI

struct OrderCellView: View {
    
    var order: Order
    let height = UIScreen.main.bounds.height * 0.1
    
    var body: some View {
        HStack(alignment: .top, spacing: 15){
            AppImage(
                urlString: order.nursePicture,
                width: 80,
                height: height,
                contentMode: .fill,
                shape: RoundedRectangle(cornerRadius: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(order.nurseName ?? "")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                Text(order.speciality ?? "")
                    .font(.callout)
                    .foregroundStyle(.black)
                
                
                Label {
                    Text(order.createdDate ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } icon: {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Label {
                    Text((order.totalPrice ?? 0).asEGPCurrency())
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                } icon: {
                    Image(systemName: "banknote")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(order.status ?? "")
                    .font(.subheadline)
                    .foregroundStyle(order.statusId == .Completed ? .green : .red)
                    .bold()
                
            }
  
            Spacer()
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
}

#Preview {
    VStack{
        OrderCellView(order:Order.mock)
    }
}

