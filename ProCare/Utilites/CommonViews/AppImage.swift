//
//  AppImage.swift
//  ProCare
//
//  Created by ahmed hussien on 13/05/2025.
//


import SwiftUI

struct AppImage<S: Shape>: View {
    let urlString: String?
    var width: CGFloat = 250
    var height: CGFloat = 250
    var contentMode: ContentMode = .fit
    var shape: S

    init(
        urlString: String?,
        width: CGFloat = 250,
        height: CGFloat = 250,
        contentMode: ContentMode = .fit,
        shape: S = RoundedRectangle(cornerRadius: 10)
    ) {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.contentMode = contentMode
        self.shape = shape
    }

    var body: some View {
//        ZStack {
//            shape
//                .fill(Color.gray.opacity(0.1))
//                .frame(height: height)

            AsyncImage(url: URL(string: urlString ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(width: width,height: height)
                        .clipShape(shape)
                case .failure(_):
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width,height: height)
                        .foregroundColor(.gray.opacity(0.6))
                @unknown default:
                    EmptyView()
                }
            }
       // }
    }
}
