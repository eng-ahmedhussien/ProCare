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
    var placeholder: Image?
    var overlay: AnyView?
    var showLoadingIndicator: Bool
    var backgroundColor: Color = Color.gray.opacity(0.1)
    
    init(
        urlString: String?,
        width: CGFloat = 250,
        height: CGFloat = 250,
        contentMode: ContentMode = .fit,
        shape: S = RoundedRectangle(cornerRadius: 10),
        placeholder: Image? = nil,
        overlay: AnyView? = nil,
        showLoadingIndicator: Bool = false,
        backgroundColor: Color = Color.gray.opacity(0.1)
    ) {
        self.urlString = urlString
        self.width = width
        self.height = height
        self.contentMode = contentMode
        self.shape = shape
        self.placeholder = placeholder
        self.overlay = overlay
        self.showLoadingIndicator = showLoadingIndicator
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        ZStack {
            // Background shape
            shape
                .fill(backgroundColor)
                .frame(width: width, height: height)
            
            AsyncImage(url: URL(string: urlString ?? "")) { phase in
                switch phase {
                case .empty:
                    if showLoadingIndicator {
                        ProgressView()
                            .frame(width: width, height: height)
                    } else if let placeholder = placeholder {
                        placeholder
                            .resizable()
                            .aspectRatio(contentMode: contentMode)
                            .frame(width: width, height: height)
                            .clipShape(shape)
                    } else {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.5, height: height * 0.5)
                            .foregroundColor(.gray.opacity(0.6))
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(width: width, height: height)
                        .clipShape(shape)
                        .transition(.opacity)
                case .failure:
                    Group {
                        if let placeholder = placeholder {
                            placeholder
                                .resizable()
                                .aspectRatio(contentMode: contentMode)
                                .frame(width: width, height: height)
                                .clipShape(shape)
                        } else {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width * 0.5, height: height * 0.5)
                                .foregroundColor(.gray.opacity(0.6))
                        }
                    }
                @unknown default:
                    Color.clear
                }
            }
            .animation(.easeInOut(duration: 0.3), value: urlString)
            
            if let overlay = overlay {
                overlay
            }
        }
        .frame(width: width, height: height)
    }
}

// MARK: - Preview Provider
#if DEBUG
struct AppImage_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            // Basic usage
            AppImage(urlString: "https://example.com/image.jpg")
            
            // Custom shape
            AppImage(
                urlString: "https://example.com/image.jpg",
                shape: Circle()
            )
            
            // With overlay
            AppImage(
                urlString: "https://example.com/image.jpg",
                overlay: AnyView(
                    Text("Overlay")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                )
            )
            
            // Custom placeholder
            AppImage(
                urlString: nil,
                placeholder: Image(systemName: "photo")
            )
        }
        .padding()
    }
}
#endif
