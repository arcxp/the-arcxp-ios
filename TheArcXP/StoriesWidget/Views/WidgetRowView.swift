//
//  WidgetRowView.swift
//  StoriesWidgetExtension
//
//  Created by Amani Hunter on 7/12/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct WidgetRowView: View {
    @Environment(\.colorScheme) var colorScheme
    var headline: String
    var headlineImageURL: String?
    var placeholderFilename: String?
    var section: String
    
    init(headline: String, headlineImageURL: String? = nil, placeholderFilename: String? = nil, section: String) {
        self.headline = headline
        self.headlineImageURL = headlineImageURL
        self.placeholderFilename = placeholderFilename
        self.section = section
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text(headline)
                        .font(.system(size: 14))
                        .foregroundColor(colorScheme == .dark ?
                                         ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
                        .frame(maxWidth: geometry.size.width, alignment: .leading)
                        .padding([.leading, .trailing])
                    ImageView(withURL: headlineImageURL ?? "", withFilename: placeholderFilename)
                        .frame(maxWidth: 50, maxHeight: 50)
                    Spacer()
                }
                Divider()
            }
        }
        .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
    }
}
