//
//  CategoryCard.swift
//  ProCare
//
//  Created by ahmed hussien on 04/06/2025.
//
import SwiftUI

struct CategoryCard: View {
    let category: Category
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack(alignment: .top,spacing: 20) {
                AppImage(
                    urlString: category.imageUrl ?? "",
                    width: 100,
                    height: 100,
                    backgroundColor: .clear
                )
                
                VStack(alignment: .leading, spacing: 5){
                    Text(category.name ?? "Unknown Category")
                        .font(.title2)
                        .foregroundStyle(.appPrimary)
                    
                    Text(category.description ?? "No description available")
                        .font(.headline)
                        .foregroundStyle(.appSecode)
                }
               
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .backgroundCard(
                color: .service,
                cornerRadius: 12,
                shadowRadius: 2
            )
           
        }
        .buttonStyle(.plain)
    }
}

#if DEBUG
#Preview {
    CategoryCard(category: Category.mockCategorie, onTap: {})
}
#endif
