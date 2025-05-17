//
//  OrderCellView.swift
//  ProCare
//
//  Created by ahmed hussien on 17/05/2025.
//
import SwiftUI

struct OrderCellView: View {
    
    var order: Order
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 20){
                
                AppImage(
                    urlString: order.nursePicture,
                    width: 80,
                    height: 80,
                    contentMode: .fill,
                    shape: RoundedRectangle(cornerRadius: 10)
                )
                .frame(width: 80, height: 80)

                VStack(alignment: .leading, spacing: 10) {
                    Text(order.nurseName ?? "")
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.black)
                    
                    Text(order.speciality ?? "")
                        .font(.callout)
                        .foregroundStyle(.black)
                    
                    Text(order.status ?? "")
                        .font(.callout)
                        .foregroundStyle(order.status == "Completed" ? .green : .red)
                        .bold()
                   
                }
                
                Spacer()
            }
            
//            Button {
//                // TODO: Handle nurse call
//                if let url = URL(string: "tel://\(order.phoneNumber ?? "")"),
//                       UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url)
//                    }
//            } label: {
//                HStack{
//                    Image(systemName: "phone.fill")
//                    Text("التواصل مع الممرض")
//                }
//            }
//            .buttonStyle(AppButton(kind: .solid,width: 300))
        }
        .padding()
        .backgroundCard(cornerRadius: 10, shadowRadius: 1, shadowColor: .appGray)
        .padding()
    }
}

//#Preview {
//    NurseCellView(nurse: MockManger.shared.nurseMockModel)
//}

