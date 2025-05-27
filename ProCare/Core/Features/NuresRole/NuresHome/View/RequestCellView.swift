//
//  RequestCellView.swift
//  ProCare
//
//  Created by ahmed hussien on 20/05/2025.
//


import SwiftUI

struct RequestCellView: View {
    
    var request: Request
    let height = UIScreen.main.bounds.height * 0.1
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 15){
            
            AppImage(
                urlString: request.patientPicture,
                width: 80,
                height: height,
                contentMode: .fill,
                shape: RoundedRectangle(cornerRadius: 10)
            )
            .frame(width: 80, height: height)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(request.patientName ?? "")
                    .font(.headline)
                    .bold()
                    .foregroundStyle(.black)
                
                Text(request.createdDate ?? "")
                    .font(.callout)
                    .foregroundStyle(.gray)
                
                Text(request.status ?? "")
                    .font(.callout)
                    .foregroundStyle(request.statusId == .Completed ? .green : .red)
                    .bold()
                
            }
  
            Spacer()
        }
        .padding()
        .backgroundCard(cornerRadius: 10, shadowRadius: 1, shadowColor: .gray)
        .padding()
    }
}

//#Preview {
//    VStack{
//        RequestCellView(order: MockManger.shared.orderMockModel)
//    }
//}

