//
//  LinearProgressView.swift
//  VideoPlayerMV
//
//  Created by Maxim Vynnyk on 26.04.2023.
//

import SwiftUI

public struct LinearProgressView: View {
    @State private var width: CGFloat = 0
    @State private var offset: CGFloat = 0

    public init() {}
    
    public var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .foregroundColor(Color(uiColor: .systemGroupedBackground))
                .overlay(
                    Rectangle()
                        .foregroundColor(Color.accentColor)
                        .frame(width: geometry.width * 0.25)
                        .clipShape(Capsule())
                        .offset(x: -geometry.width * 0.5, y: 0)
                        .offset(x: geometry.width * 1 * offset, y: 0)
                        .animation(.default.repeatForever().speed(0.265), value: offset)
                )
                .clipShape(Capsule())
                .onAppear {
                    Task.detached(priority: .userInitiated) {
                        let delay: Double = [0.1, 0.05, 0, 0.15].randomElement() ?? 0
                        try await Task.sleep(for: .seconds(delay))
                        
                        await MainActor.run {
                            withAnimation(.default.delay(delay)) {
                                offset = 1
                            }
                        }
                    }
                }
        }
    }
}

struct Previews_LinearProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LinearProgressView()
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
    }
}
