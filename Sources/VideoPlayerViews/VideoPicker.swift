//
//  VideoPicker.swift
//  VideoPlayer
//
//  Created by Maxim Vynnyk on 04.04.2023.
//

import SwiftUI
import PhotosUI

public struct VideoPicker: View {
    let maxCount: Int
    @Binding var videoSelection: [PhotosPickerItem]
    
    public init(videoSelection: Binding<[PhotosPickerItem]>, maxCount: Int = 1) {
        _videoSelection = videoSelection
        self.maxCount = maxCount
    }
        
    public var body: some View {
        PhotosPicker(
            selection: $videoSelection,
            maxSelectionCount: maxCount,
            matching: .videos
        ) {
            HStack {
                Text("Import").bold()
                Spacer()
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct VideoPicker_Previews: PreviewProvider {
    static var previews: some View {
        VideoPicker(videoSelection: .constant([]), maxCount: 8)
    }
}
