//
//  ServiceIconView.swift
//  ProCare
//
//  Created by ahmed hussien on 20/04/2025.
//

import SwiftUI

struct ServiceIconView: View {
    var title: String
    var icon: String

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color("service"))
                    .frame(width: 70, height: 70)

                AsyncImage(url: URL(string: icon)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        //.clipShape(Circle()) // Optional: circular crop
                } placeholder: {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            Text(title)
                .lineLimit(1)
                .font(.footnote)
                .foregroundColor(.black)
                .frame(maxWidth: 70) // Ensures text wraps if needed
        }
    }
}

#Preview {
    ServiceIconView(title: "", icon: "")
}
