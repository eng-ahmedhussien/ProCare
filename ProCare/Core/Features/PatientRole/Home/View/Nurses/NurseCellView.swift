//
//  NurseCellView.swift
//  ProCare
//
//  Created by ahmed hussien on 24/04/2025.
//

import SwiftUI

struct NurseCellView: View {
    
    var nurse: Nurse
    let distance: Double? // in meters
    
    var body: some View {
            HStack(alignment: .center){
                AsyncImage(url: URL(string: nurse.image ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                } placeholder: {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                VStack(alignment: .leading){
                    Text(nurse.fullName ?? "no_title".localized())
                        .font(.headline)
                        .bold()
                    
                    Text(nurse.specialization ?? "no_description".localized())
                        .font(.subheadline)
                        .bold()
                    
                    if let distance = distance {
                        Text(String(format: NSLocalizedString("km_away", comment: ""), distance / 1000))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                HStack{
                    Text("5")
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                   
            }
            .padding()
            .backgroundCard(color: .white, cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
            .padding()
    }
}

//#Preview {
//    NurseCellView(nurse: MockManger.shared.nurseMockModel)
//}

