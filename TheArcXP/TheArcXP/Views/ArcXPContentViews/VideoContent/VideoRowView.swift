//
//  VideoRowView.swift
//  TheArcXP
//
//  Created by Mahesh Venkateswarlu on 5/23/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct VideoRowView: View {
    
    private var headline: String
    private var imageUrlString: String?
    var videoContent: ArcXPContent
    private var width: CGFloat
    private var height: CGFloat
    private var isFirstItem: Bool
    @Environment(\.colorScheme) var colorScheme
    
    init(videoContent: ArcXPContent, width: CGFloat, height: CGFloat, isFirstItem: Bool) {
        self.videoContent = videoContent
        self.headline = videoContent.headlines?.basic ?? ""
        let contentElement = videoContent.promoItems?.content as? ImageContentElement
        imageUrlString = contentElement?.url
        self.width = width
        self.height = height
        self.isFirstItem = isFirstItem
    }
    
    var body: some View {
        VStack {
            if isFirstItem {
                VStack(alignment: .leading) {
                    ZStack {
                        if let imageUrlString = imageUrlString,
                            !imageUrlString.isEmpty {
                            ImageView(withURL: imageUrlString)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom)
                        }
                        Image("VideoPlayIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                    }
                    Text(headline)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
                }
            } else {
                HStack(alignment: .top) {
                    Text(headline)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
                        .padding(.top)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    if let imageUrlString = imageUrlString,
                        !imageUrlString.isEmpty {
                        ZStack {
                            ImageView(withURL: imageUrlString)
                                .frame(width: width * 0.3)
                                .frame(minHeight: height * 0.1)
                            Image("VideoPlayIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 36, maxHeight: 36)
                        }.padding(.top)
                    }
                }
            }
        }
        .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
    }
}
