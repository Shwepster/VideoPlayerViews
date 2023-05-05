//
//  ItemImageView.swift
//  VideoPlayer
//
//  Created by Maxim Vynnyk on 17.04.2023.
//

import SwiftUI

public struct ItemImageView: View {
    let url: URL?
    @State private var image: Image?
    
    public init(url: URL?) {
        self.url = url
    }
    
    public var body: some View {
        GeometryReader { geometry in
            (image ?? Image("kp"))
                .resizable()
                .scaledToFill()
                .frame(
                    width: geometry.width,
                    height: geometry.height
                )
                .background(.red)
                .contentShape(Rectangle())
                .animation(.default, value: url)
                .task {
                    guard image == nil else { return }
                    image = await ImageFetcher
                        .makeImage(from: url, size: geometry.size)
                }
        }
    }
}
