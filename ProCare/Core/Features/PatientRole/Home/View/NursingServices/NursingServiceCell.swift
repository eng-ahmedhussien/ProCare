//
//  NursingServiceCell.swift
//  ProCare
//
//  Created by ahmed hussien on 13/06/2025.
//

import SwiftUI

struct NursingServiceCell: View {
    let nursingServices: NursingServices
    let onTap: () -> Void
    
    var body: some View {
        
        Button(action: {
            onTap()
        }) {
            HStack(alignment: .center){
                AppImage(
                    urlString: nursingServices.imageUrl  ?? "",
                    width: 72,
                    height: 72,
                    backgroundColor: .clear
                )
                
                VStack(alignment: .leading){
                    Text(nursingServices.name ?? "no_title".localized())
                        .font(.title3)
                        .foregroundStyle(.appSecode)
                        .bold()
                    
                    Text(nursingServices.description ?? "no_description".localized())
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.appSecode)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .backgroundCard(color: .white, cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
        } .buttonStyle(.plain)
    }
}

#Preview {
    NursingServiceCell(nursingServices: NursingServices.mock, onTap: {})
}
