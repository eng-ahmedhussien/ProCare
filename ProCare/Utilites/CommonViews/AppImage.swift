//
//  AppImage.swift
//  ProCare
//
//  Created by ahmed hussien on 13/05/2025.
//


import SwiftUI

struct AppImage: View {
    let urlString: String?
    var height: CGFloat = 250
    var cornerRadius: CGFloat = 0
    var contentMode: ContentMode = .fit

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray.opacity(0.1))
                .frame(height: height)
                .cornerRadius(cornerRadius)

            AsyncImage(url: URL(string: urlString ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(height: height)
                        .clipped()
                        .cornerRadius(cornerRadius)
                case .failure(_):
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray.opacity(0.6))
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}
