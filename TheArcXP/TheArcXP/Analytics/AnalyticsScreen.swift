//
//  AnalyticsScreen.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 8/14/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import Foundation

/// Represents the screen to report a screen view to an analytics provider.
/// Can be extended in order to create custom screen views..
struct AnalyticsScreen {
    /// Name of the screen.
    var name: String
    
    /// Name of the class associated with the screen.
    var className: String?
    
    /// Additional information about the screen that you wish to report.
    var params: [String: String]?
}

extension AnalyticsScreen {
    /// Creates and returns a custom `AnalyticsScreen` for the account tab view.
    /// - returns: An `AnalyticsScreen` representing the account tab view.
    static func accountScreen() -> AnalyticsScreen {
        return AnalyticsScreen(name: ScreenType.account.rawValue)
    }
    
    /// Creates and returns a custom `AnalyticsScreen` for the article detail view.
    /// - returns: An `AnalyticsScreen` representing the article detail view.
    static func articleScreen() -> AnalyticsScreen {
        return AnalyticsScreen(name: ScreenType.article.rawValue)
    }
    
    /// Creates and returns a custom `AnalyticsScreen` for the video tab view.
    /// - returns: An `AnalyticsScreen` representing the video tab view.
    static func videoScreen() -> AnalyticsScreen {
        return AnalyticsScreen(name: ScreenType.video.rawValue)
    }
    
    /// Creates and returns a custom `AnalyticsScreen` for the home tab view.
    /// - returns: An `AnalyticsScreen` representing the home tab view.
    static func homeScreen() -> AnalyticsScreen {
        return AnalyticsScreen(name: ScreenType.home.rawValue)
    }
}
