//
//  StoryStandardRowView.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 5/17/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct StoryStandardRowView: View {
    var summary: String
    var headline: String
    var storydetails: String
    var imageUrlString: String?
    var width: CGFloat
    var height: CGFloat
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(headline)
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
                Spacer()
                if let imageUrlString = imageUrlString,
                    !imageUrlString.isEmpty {
                    ImageView(withURL: imageUrlString)
                        .padding([.leading, .trailing])
                }
            }
            
            if !summary.isEmpty {
                Text(summary)
                    .font(.subheadline)
                    .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
                    .padding([.top], 0.5)
            }
            
            if !storydetails.isEmpty {
                Text(storydetails)
                    .font(.caption)
                    .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
                    .padding([.top], 0.5)
            }
        }
        .padding([.top, .bottom])
        .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
    }
}
