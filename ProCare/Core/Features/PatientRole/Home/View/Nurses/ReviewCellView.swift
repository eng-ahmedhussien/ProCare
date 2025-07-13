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
            
            Label("\(review.rating ?? 0)", systemImage: stareRate(review.rating ?? 0))
                .labelStyle(.titleAndIcon)
                .foregroundColor(.yellow)
                .font(.subheadline)
                .accessibilityLabel(Text("Rating"))
               
        }
       // .padding()
       // .backgroundCard(color: .white, cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
        .padding(.horizontal)
    }
    
    private func stareRate(_ rate: Int) -> String {
              switch rate {
              case 1...3:
                  return "star.leadinghalf.filled"
              case 4...5:
                  return "star.fill"
              default:
                  return "star"
              }
          }
}


#Preview {
    ReviewCellView(review: Review.mock)
}
