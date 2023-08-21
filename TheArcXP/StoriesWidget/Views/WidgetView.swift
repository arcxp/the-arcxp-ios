//
//  WidgetView.swift
//  StoriesWidgetExtension
//
//  Created by Amani Hunter on 7/12/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct WidgetView: View {
    @Environment(\.colorScheme) var colorScheme
    var updatedTime: Date
    var stories: [HeadlineData]
    let section: String
    init(updatedTime: Date, section: String, stories: [HeadlineData]) {
        self.updatedTime = updatedTime
        self.section = section
        self.stories = stories
    }
    
    var body: some View {
        VStack {
            WidgetTopBarView(updatedTime: updatedTime, section: section)
            ForEach(stories) { story in
                if let id = URL(string: story.identifier) {
                    Link(destination: id) {
                        WidgetRowView(headline: story.headline,
                                      headlineImageURL: story.headlineImageURL,
                                      placeholderFilename: story.placeHolderImageFilename, section: section)
                    }
                }
            }
        }
        .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
    }
}
