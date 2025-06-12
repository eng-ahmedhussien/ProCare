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
            .frame(width: 80, height: height)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(order.nurseName ?? "")
                    .font(.headline)
                    .bold()
                    .foregroundStyle(.black)
                
                Text(order.speciality ?? "")
                    .font(.callout)
                    .foregroundStyle(.black)
                
                Text(order.createdDate ?? "")
                    .font(.callout)
                    .foregroundStyle(.gray)
                
                Text((order.totalPrice ?? 0).asEGPCurrency())
                    .font(.callout)
                    .foregroundStyle(.gray)
                
                Text(order.status ?? "")
                    .font(.callout)
                    .foregroundStyle(order.statusId == .Completed ? .green : .red)
                    .bold()
                
            }
  
            Spacer()
        }
        .padding()
        .backgroundCard(cornerRadius: 10, shadowRadius: 1, shadowColor: .gray)
        .padding()
    }
}

#Preview {
    VStack{
        OrderCellView(order:Order.mock)
    }
}

