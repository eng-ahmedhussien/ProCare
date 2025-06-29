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
                    .foregroundStyle(.appSecode)
                
                Text(request.createdDate ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Text((request.totalPrice ?? 0).asEGPCurrency())
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Text(request.status ?? "")
                    .font(.subheadline)
                    .foregroundStyle(request.statusId == .Completed ? .green : .red)
                    .bold()
                
            }
  
            Spacer()
        }
        .padding()
        .backgroundCard(cornerRadius: 10, shadowRadius: 1)
        .padding()
    }
}

#Preview {
    VStack{
        RequestCellView(request: Request.mock)
            
        Spacer()
    }.environment(\.locale, .init(identifier: "ar"))
}

