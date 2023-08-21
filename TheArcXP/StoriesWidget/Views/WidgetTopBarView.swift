//
//  WidgetTopBarView.swift
//  StoriesWidgetExtension
//
//  Created by Amani Hunter on 7/12/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct WidgetTopBarView: View {
    @Environment(\.colorScheme) var colorScheme
    var updatedTime: Date?
    var section: String
    
    init(updatedTime: Date? = nil, section: String) {
        self.updatedTime = updatedTime
        self.section = section
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Text(Constants.title)
                    .font(.custom(Constants.Fonts.ArcXPFontName, size: 17).bold())
                    .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeLabelTextColor :
                                        ThemeManager.lightModeLabelTextColor)
                    .frame(maxWidth: geometry.size.width / 3, alignment: .leading)
                    .padding()
                SectionTitleView(sectionName: section)
                    .font(.system(size: 11))
                    .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeLabelTextColor :
                                        ThemeManager.lightModeLabelTextColor)
                if let date = updatedTime {
                    Text("\(Constants.WidgetConstants.updated) \(DateFormatter.widgetFormatter.string(from: date))")
                        .font(.system(size: 9))
                        .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeLabelTextColor :
                                            ThemeManager.lightModeLabelTextColor)
                        .frame(maxWidth: geometry.size.width / 3, alignment: .trailing)
                        .padding()
                }
            }
        }
        .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
    }
}

struct WidgetTopBarView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetTopBarView(section: "Top Stories")
    }
}
