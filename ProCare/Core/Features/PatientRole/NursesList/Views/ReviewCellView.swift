//
//  ReviewCellView.swift
//  ProCare
//
//  Created by ahmed hussien on 13/05/2025.
//
import SwiftUI

struct ReviewCellView: View {
    
    var review: Review
    
    var body: some View {
        HStack(alignment: .center){
            VStack(alignment: .leading){
                Text(review.patientName ?? "")
                    .font(.headline)
                
                Text(review.comment ?? "")
                    .font(.subheadline)
                
                Text(review.formattedCreatedAt ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
        
            }
            
            Spacer()
            
            HStack{
                Text("\(review.rating ?? 0)")
                    
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
               
        }
       // .padding()
       // .backgroundCard(color: .white, cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
        .padding(.horizontal)
    }
}


#Preview {
    ReviewCellView(review: Review.mock)
}
