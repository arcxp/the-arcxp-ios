//
//  NavigationBarTheme.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 3/15/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

class NavigationBarTheme {
    static func navigationBarColors(background: UIColor?,
                                    titleColor: UIColor? = nil,
                                    tintColor: UIColor? = nil ) {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black,
                                                    .font: UIFont(name: Constants.Fonts.ArcXPFontName, size: 18)!]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black,
                                                         .font: UIFont(name: Constants.Fonts.ArcXPFontName, size: 18)!]
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}
