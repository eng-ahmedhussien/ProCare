    //
    //  AppImage.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 13/05/2025.
    //


import SwiftUI

    // Simple image cache
class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    func get(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func set(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

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
    
    @State private var loadedImage: UIImage?
    @State private var isLoading = false
    @State private var loadingFailed = false
    
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
            
            Group {
                if let loadedImage = loadedImage {
                    Image(uiImage: loadedImage)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(width: width, height: height)
                        .clipShape(shape)
                        .transition(.opacity)
                } else if isLoading && showLoadingIndicator {
                    ProgressView()
                        .frame(width: width, height: height)
                } else {
                        // Show placeholder
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
            }
            .animation(.easeInOut(duration: 0.3), value: loadedImage != nil)
            
            if let overlay = overlay {
                overlay
            }
        }
        .frame(width: width, height: height)
        .onAppear {
            loadImage()
        }
        .onChange(of: urlString) { _ in
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            loadingFailed = true
            return
        }
        
            // Check cache first
        if let cachedImage = ImageCache.shared.get(for: urlString) {
            loadedImage = cachedImage
            return
        }
        
            // Don't reload if already loading
        guard !isLoading else { return }
        
        isLoading = true
        loadingFailed = false
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let data = data, let uiImage = UIImage(data: data) {
                        // Cache the image
                    ImageCache.shared.set(uiImage, for: urlString)
                    loadedImage = uiImage
                } else {
                    loadingFailed = true
                }
            }
        }.resume()
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




//struct AppImage<S: Shape>: View {
//    let urlString: String?
//    var width: CGFloat = 250
//    var height: CGFloat = 250
//    var contentMode: ContentMode = .fit
//    var shape: S
//    var placeholder: Image?
//    var overlay: AnyView?
//    var showLoadingIndicator: Bool
//    var backgroundColor: Color = Color.gray.opacity(0.1)
//
//    init(
//        urlString: String?,
//        width: CGFloat = 250,
//        height: CGFloat = 250,
//        contentMode: ContentMode = .fit,
//        shape: S = RoundedRectangle(cornerRadius: 10),
//        placeholder: Image? = nil,
//        overlay: AnyView? = nil,
//        showLoadingIndicator: Bool = false,
//        backgroundColor: Color = Color.gray.opacity(0.1)
//    ) {
//        self.urlString = urlString
//        self.width = width
//        self.height = height
//        self.contentMode = contentMode
//        self.shape = shape
//        self.placeholder = placeholder
//        self.overlay = overlay
//        self.showLoadingIndicator = showLoadingIndicator
//        self.backgroundColor = backgroundColor
//    }
//
//    var body: some View {
//        ZStack {
//            // Background shape
//            shape
//                .fill(backgroundColor)
//                .frame(width: width, height: height)
//
//            AsyncImage(url: URL(string: urlString ?? "")) { phase in
//                switch phase {
//                case .empty:
//                    if showLoadingIndicator {
//                        ProgressView()
//                            .frame(width: width, height: height)
//                    } else if let placeholder = placeholder {
//                        placeholder
//                            .resizable()
//                            .aspectRatio(contentMode: contentMode)
//                            .frame(width: width, height: height)
//                            .clipShape(shape)
//                    } else {
//                        Image(systemName: "photo.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: width * 0.5, height: height * 0.5)
//                            .foregroundColor(.gray.opacity(0.6))
//                    }
//                case .success(let image):
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: contentMode)
//                        .frame(width: width, height: height)
//                        .clipShape(shape)
//                        .transition(.opacity)
//                case .failure:
//                    Group {
//                        if let placeholder = placeholder {
//                            placeholder
//                                .resizable()
//                                .aspectRatio(contentMode: contentMode)
//                                .frame(width: width, height: height)
//                                .clipShape(shape)
//                        } else {
//                            Image(systemName: "photo.fill")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: width * 0.5, height: height * 0.5)
//                                .foregroundColor(.gray.opacity(0.6))
//                        }
//                    }
//                @unknown default:
//                    Color.clear
//                }
//            }
//            .animation(.easeInOut(duration: 0.3), value: urlString)
//
//            if let overlay = overlay {
//                overlay
//            }
//        }
//        .frame(width: width, height: height)
//    }
    //}
