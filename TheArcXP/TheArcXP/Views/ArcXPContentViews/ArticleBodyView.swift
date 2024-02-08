//
//  ArticleBodyView.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 4/11/22.
//  Copyright © 2022 Arc XP. All rights reserved.
// 

import SwiftUI
import ArcXP
import UIKit

struct ArticleBodyView: View {
    var contentElements = [ContentElement]()
    var width: CGFloat
    var height: CGFloat
    @Environment(\.colorScheme) var colorScheme
    /**
        For each item in contentElements, map to correct ContentType
        then switch on its ContentType (total of 13 types) and 
        based on the type of content, build the UI out accordingly.
     */
    
    var body: some View {
        VStack {
            ForEach(contentElements, id: \.id) { contentElement in
                if let typeString = contentElement.type {
                    switch typeString {
                    case ContentType.text.rawValue:
                        if let textContent = contentElement.content {
                            HTMLStringView(width: width, html: textContent)
                        }
                    case ContentType.image.rawValue:
                        if let imageUrlString = SDKUtils.getResizeImageUrl(imageContentElement: contentElement) {
                            ImageView(withURL: imageUrlString)
                                .padding()
                            if let imageSubtitle = getImageSubtitle(from: contentElement) {
                                Text(imageSubtitle)
                                    .font(.caption)
                                    .foregroundColor(colorScheme == .dark ?
                                                     ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
                                    .fontWeight(.bold)
                                    .padding([.leading, .trailing])
                            }
                            if let imageCaption = getImageCaption(from: contentElement) {
                                Text(imageCaption)
                                    .font(.caption)
                                    .foregroundColor(colorScheme == .dark ?
                                                     ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
                                    .padding([.leading, .trailing, .bottom])
                            }
                        }
                    case ContentType.gallery.rawValue:
                        if let galleryContent = contentElement as? GalleryContentElement,
                            let galleryImages = galleryContent.contentElements {
                            
                            GalleryView(maxIndex: galleryImages.count - 1) {
                                ForEach(galleryImages, id: \.id) { imageContentElement in
                                    if let imageUrlString = SDKUtils.getResizeImageUrl(imageContentElement: imageContentElement) {
                                        VStack {
                                            ImageView(withURL: imageUrlString)
                                                .padding()
                                            if let imageSubtitle = getImageSubtitle(from: imageContentElement) {
                                                Text(imageSubtitle)
                                                    .font(.caption)
                                                    .foregroundColor(colorScheme == .dark ?
                                                                     ThemeManager.darkModeContentTextColor :
                                                                        ThemeManager.lightModeContentTextColor)
                                                    .fontWeight(.bold)
                                                    .padding([.leading, .trailing])
                                            }
                                            if let imageCaption = getImageCaption(from: imageContentElement) {
                                                Text(imageCaption)
                                                    .font(.caption)
                                                    .foregroundColor(colorScheme == .dark ?
                                                                     ThemeManager.darkModeContentTextColor :
                                                                        ThemeManager.lightModeContentTextColor)
                                                    .padding([.leading, .trailing, .bottom])
                                            }
                                        }
                                    }
                                }
                            }
                            .aspectRatio(4/3, contentMode: .fit)
                        }
                    case ContentType.video.rawValue:
                        VideoPlayerView(storyIdentfier: contentElement.id, 
                                        isFullScreen: false,
                                        fromArticle: true)
                            .frame(width: width * 0.85, height: height * 0.3)
                    default:
                        Text("")
                    }
                }
            }
        }
    }
    private func getImageSubtitle(from content: ContentElement) -> String? {
            guard let imageElement = content as? ImageContentElement,
                  let subtitleString = imageElement.subtitle, !subtitleString.isEmpty else {
                return nil
            }
            return subtitleString
        }

    private func getImageCaption(from content: ContentElement) -> String? {
        let imageCaption: String? = nil
        
        let imageElement = content as? ImageContentElement
        if let captionString = imageElement?.caption, !captionString.isEmpty {
            return captionString
        } else {
            return imageCaption
        }
    }
}
