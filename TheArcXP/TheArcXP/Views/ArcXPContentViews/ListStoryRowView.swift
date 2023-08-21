//
//  ListStoryRowView.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 4/4/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct ListStoryRowView: View {
    var story: ArcXPContent
    var summary: String
    var headline: String
    var storydetails: String
    var imageUrlString: String?
    var width: CGFloat
    var height: CGFloat
    var firstItem: Bool
    @Environment(\.colorScheme) var colorScheme

    init(story: ArcXPContent, width: CGFloat, height: CGFloat, first: Bool) {
        self.story = story
        self.firstItem = first
        summary = story.description?.basic ?? ""
        headline = story.headlines?.basic ?? ""
        summary = story.description?.basic ?? ""
        headline = story.headlines?.basic ?? ""
        
        let publishedDate = SDKUtils.convertDateFormat(fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                                                       toFormat: "MMMM d, yyyy",
                                                       story.publishDate) ?? ""
        if let authorNames = SDKUtils.formattedAuthorNamesText(story.authorNames),
           !authorNames.isEmpty {
            storydetails = "\(authorNames) • \(publishedDate)"
        } else {
            storydetails = publishedDate
        }
        var imageElement: ImageContentElement?

        switch story.type {
        case .story:
            imageElement = story.promoItems?.content as? ImageContentElement
        case .gallery:
            let firstElement = story.contentElements?.first
            if firstElement?.type == GalleryContentElement.contentType.rawValue {
                let galleryElement = firstElement as? GalleryContentElement
                imageElement = galleryElement?.contentElements?.first
            } else if firstElement?.type == ImageContentElement.contentType.rawValue {
                imageElement = firstElement as? ImageContentElement
            }
        case .video:
            break
        default:
            break
        }

        imageUrlString = SDKUtils.getResizeImageUrl(imageContentElement: imageElement,
                                                         isFullSize: firstItem)
        self.width = width
        self.height = height
    }

    var body: some View {
        if firstItem {
            StoryFocusedRowView(summary: summary,
                                headline: headline,
                                storydetails: storydetails,
                                imageUrlString: imageUrlString,
                                width: width,
                                height: height)
            .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
        } else {
            StoryStandardRowView(summary: summary,
                                 headline: headline,
                                 storydetails: storydetails,
                                 imageUrlString: imageUrlString,
                                 width: width,
                                 height: height)
            .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
        }
    }
}
