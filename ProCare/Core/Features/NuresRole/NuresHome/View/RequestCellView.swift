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
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
            //.frame(width: 80, height: height)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(request.patientName ?? "")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                Label {
                    Text(request.createdDate ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } icon: {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Label {
                    Text((request.totalPrice ?? 0).asEGPCurrency())
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                } icon: {
                    Image(systemName: "banknote")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(request.status ?? "")
                    .font(.subheadline)
                    .foregroundStyle(request.statusId == .Completed ? .green : .red)
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
        RequestCellView(request: Request.mock)
            
        Spacer()
    } .environment(\.locale, .init(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
}

