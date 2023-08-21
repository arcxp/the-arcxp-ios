//
//  GalleryView.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 5/23/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct GalleryView<Content>: View where Content: View {
    @State var index = 0
    let maxIndex: Int
    let galleryContent: () -> Content
    
    @State private var offset = CGFloat.zero
    @State private var dragging = false
    
    init(maxIndex: Int, @ViewBuilder content: @escaping () -> Content) {
        self.maxIndex = maxIndex
        galleryContent = content
    }
    
    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        galleryContent()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    }
                }
                .content.offset(x: offset(in: geometry), y: 0)
                .frame(width: geometry.size.width, alignment: .leading)
                .gesture(
                    DragGesture().onChanged { value in
                        dragging = true
                        offset = -CGFloat(index) * geometry.size.width + value.translation.width
                    }
                    .onEnded { value in
                        let predictedEndOffset = -CGFloat(index) * geometry.size.width + value.predictedEndTranslation.width
                        let predictedIndex = Int(round(predictedEndOffset / -geometry.size.width))
                        index = clampedIndex(from: predictedIndex)
                        withAnimation(.easeOut) {
                            dragging = false
                        }
                    }
                )
            }
            .clipped()

            PageControl(index: $index, maxIndex: maxIndex)
        }
    }
    
    func offset(in geometry: GeometryProxy) -> CGFloat {
        if dragging {
            return max(min(offset, 0), -CGFloat(maxIndex) * geometry.size.width)
        } else {
            return -CGFloat(index) * geometry.size.width
        }
    }
    
    func clampedIndex(from predictedIndex: Int) -> Int {
        let newIndex = min(max(predictedIndex, index - 1), index + 1)
        guard newIndex >= 0 else { return 0 }
        guard newIndex <= maxIndex else { return maxIndex }
        return newIndex
    }
}

struct PageControl: View {
    @Binding var index: Int
    let maxIndex: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0...maxIndex, id: \.self) { index in
                Circle()
                    .fill(index == index ? Color.gray.opacity(0.8) : Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(15)
    }
}
