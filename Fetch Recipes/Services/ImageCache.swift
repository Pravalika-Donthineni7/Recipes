import Foundation
import UIKit

actor ImageCache {
    static let shared = ImageCache()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    private func cacheFileURL(for key: String) -> URL {
        return cacheDirectory.appendingPathComponent(key.replacingOccurrences(of: "/", with: "_"))
    }
    
    func cacheImage(_ image: UIImage, for url: URL) async {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let fileURL = cacheFileURL(for: url.absoluteString)
        try? data.write(to: fileURL)
    }
    
    func getCachedImage(for url: URL) async -> UIImage? {
        let fileURL = cacheFileURL(for: url.absoluteString)
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    func loadImage(from url: URL) async throws -> UIImage {
        if let cachedImage = await getCachedImage(for: url) {
            return cachedImage
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidResponse
        }
        
        await cacheImage(image, for: url)
        return image
    }
} 