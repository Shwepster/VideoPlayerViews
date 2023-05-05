//
//  ImageFetcher.swift
//  
//
//  Created by Maxim Vynnyk on 04.05.2023.
//

import SwiftUI

enum ImageFetcher {
    static public func makeImage(from url: URL?, size: CGSize? = nil) async -> Image? {
        guard let url,
              var image = UIImage(contentsOfFile: url.path())
        else { return nil }
        
        if let size, let thumbnail = await image.byPreparingThumbnail(ofSize: size) {
            image = thumbnail
            // TODO: Add cache
        }
        
        return Image(uiImage: image)
    }
}
