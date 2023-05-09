//
//  ImageFetcher.swift
//  
//
//  Created by Maxim Vynnyk on 04.05.2023.
//

import SwiftUI

enum ImageFetcher {
    static public func makeImage(from url: URL?, size: CGSize? = nil) async -> Image? {
        guard let url else { return nil }
                
        if let size, let cachedImage = cache.getImage(at: url, for: size) {
            return Image(uiImage: cachedImage)
        } else {
            guard var image = UIImage(contentsOfFile: url.path()) else {
                return nil
            }
            
            if let size, let thumbnail = await image.byPreparingThumbnail(ofSize: size) {
                image = thumbnail
                cache.saveImage(thumbnail, at: url, for: size)
            }
            
            return Image(uiImage: image)
        }
    }
}

extension ImageFetcher {
    private static var cache: Cache { .shared }
    
    private class Cache {
        static let shared = Cache()
        private let fileManager = FileManager.default
        
        func getImage(at url: URL, for size: CGSize) -> UIImage? {
            let cacheURL = getCachedURL(from: url, size: size)
            return UIImage(contentsOfFile: cacheURL.path())
        }
        
        func saveImage(_ image: UIImage, at url: URL, for size: CGSize) {
            Task.detached {
                let cacheURL = self.getCachedURL(from: url, size: size)
                let folderURL = cacheURL.deletingLastPathComponent()
                
                do {
                    if !self.fileManager.fileExists(atPath: folderURL.path()) {
                        try self.fileManager.createDirectory(
                            at: folderURL,
                            withIntermediateDirectories: true
                        )
                    }
                    
                    let data = image.jpegData(compressionQuality: 1)
                    try data?.write(to: cacheURL)
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
        }
        
        private func getCachedURL(from url: URL, size: CGSize) -> URL {
            let file = url.lastPathComponent
            var newURL = url.deletingLastPathComponent()
            newURL = newURL.appendingPathComponent(size.stringRepresentation, conformingTo: .folder)
            return newURL.appendingPathComponent(file, conformingTo: .fileURL)
        }
    }
}

private extension CGSize {
    var stringRepresentation: String {
        "\(width)x\(height)"
    }
}
