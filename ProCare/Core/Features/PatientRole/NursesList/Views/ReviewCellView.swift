//
//  ReviewCellView.swift
//  ProCare
//
//  Created by ahmed hussien on 13/05/2025.
//
import SwiftUI

struct ReviewCellView: View {
    
    var body: some View {
        HStack(alignment: .center){
            AsyncImage(url: URL(string: "https://picsum.photos/seed/picsum/200/300")) { image in
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
                Text( "Customer name")
                    .font(.headline)
                
                Text("review")
                    .font(.subheadline)
        
            }
            
            Spacer()
            
            HStack{
                Text("5")
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
               
        }
       // .padding()
       // .backgroundCard(color: .white, cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
        .padding(.horizontal)
    }
}
