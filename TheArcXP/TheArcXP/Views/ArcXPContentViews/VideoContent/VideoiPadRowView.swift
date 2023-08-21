//
//  VideoiPadRowView.swift
//  TheArcXP
//
//  Created by Mahesh Venkateswarlu on 5/27/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct VideoiPadRowView: View {
    
    private var headline: String
    private var imageUrlString: String?
    var videoContent: ArcXPContent
    @State private var isActive = false
    @Environment(\.colorScheme) var colorScheme
    
    init(videoContent: ArcXPContent) {
        self.videoContent = videoContent
        headline = videoContent.headlines?.basic ?? ""
        let contentElement = videoContent.promoItems?.content as? ImageContentElement
        imageUrlString = contentElement?.url
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                if let imageUrlString = imageUrlString,
                    !imageUrlString.isEmpty {
                    ImageView(withURL: imageUrlString)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                Image("VideoPlayIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
            }
            Text(headline)
                .bold()
                .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
                .font(.title)
            
        }.onTapGesture {
            isActive = true
        }.background(
            NavigationLink(
                destination: VideoPlayerView(storyIdentfier: videoContent.identifier),
                 isActive: $isActive,
                 label: {
                   EmptyView()
                 }
            )
        )
    }
}
