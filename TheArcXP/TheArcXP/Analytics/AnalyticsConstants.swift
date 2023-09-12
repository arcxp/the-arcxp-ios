//
//  AnalyticsConstants.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 8/8/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import Foundation

enum AnalyticsConstants: String {
    case signUpEvent = "signup"
    case signUpType = "signupType"
    case loginEvent = "login"
    case loginType = "loginType"
}

enum LoginSignUpType: String {
    case arcxp = "ArcXP"
    case apple = "Apple"
    case facebook = "Facebook"
}

enum ScreenType: String {
    case account = "AccountScreen"
    case home = "HomeScreen"
    case video = "VideoScreen"
    case article = "ArticleScreen"
}
