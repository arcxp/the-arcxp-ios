//
//  StoryFocusedRowView.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 5/17/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct StoryFocusedRowView: View {
    var summary: String
    var headline: String
    var storydetails: String
    var imageUrlString: String?
    var width: CGFloat
    var height: CGFloat
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageUrlString = imageUrlString,
                !imageUrlString.isEmpty {
                ImageView(withURL: imageUrlString)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
            }
            Text(headline)
                .font(.headline)
                .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
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
